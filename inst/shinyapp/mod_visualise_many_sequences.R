many_sequences_ui <- function(id) {
    ns <- NS(id)
    
    layout_sidebar(
        sidebar = sidebar(
            title = "Settings",
            accordion(
                id = ns("acc"),
                open = c("Input", "FASTQ parsing"),
                
                accordion_panel(
                    title = "Input",
                    tabsetPanel(
                        id = ns("input_mode"),
                        tabPanel(
                            "Text input",
                            div(class = "seq-input", 
                                textInput(ns("txt_sequence"), "Space-separated sequences to visualise:", placeholder = "GGCGGC ACGT", value = "GGCGGC ACGT")
                            ),
                            div(
                                style = "margin-bottom: 15px;",
                                actionLink(ns("sequence_input_details"), "View input requirements", icon = icon("info-circle"), class = "mt-0 mb-3")
                            )
                        ),
                        tabPanel(
                            "Upload",
                            fileInput(ns("fil_fastq_file"), "Upload FASTQ:", accept = c(".fastq", ".fq"), placeholder = "No file selected"),
                            fileInput(ns("fil_metadata_file"), "Upload metadata CSV:", accept = c(".csv"), placeholder = "No file selected"),
                            div(
                                style = "margin-bottom: 15px;",
                                actionLink(ns("fastq_upload_details"), "View file requirements", icon = icon("info-circle"), class = "mt-0 mb-3")
                            )
                        )
                    ),
                ),
                
                accordion_panel(
                    title = "Layout",
                    numericInput(ns("num_margin"), "Margin:", 0.5, min = 0, step = 0.5),
                    numericInput(ns("num_pixels_per_base"), "Pixels per base:", 100, min = 1, step = 10)
                ),
                
                
                panel_sequence_vis_colours(ns),
                
                accordion_panel(
                    title = "Sizes and positions",
                    numericInput(ns("num_sequence_text_size"), "Sequence text size:", value = 16, step = 1),
                    numericInput(ns("num_index_annotation_size"), "Index annotation size:", value = 12.5, min = 0, step = 1),
                    textInput(ns("txt_index_annotation_lines"), "Lines to annotate with indices (space-separated integers):", value = "1 2"),
                    numericInput(ns("num_index_annotation_interval"), "Index annotation interval:", value = 15, min = 0, step = 3),
                    numericInput(ns("num_index_annotation_vertical_position"), "Index annotation height:", value = 1/3, step = 1/6),
                    checkboxInput(ns("chk_index_annotations_above"), "Index annotations above boxes", value = TRUE),
                    checkboxInput(ns("chk_index_annotation_full_line"), "Index annotations always go to the end of the line", value = TRUE),
                    checkboxInput(ns("chk_index_annotation_always_first_base"), "Always annotate first base", value = TRUE),
                    numericInput(ns("num_outline_linewidth"), "Outline thickness:", value = 3, min = 0, step = 0.5),
                    selectInput(ns("sel_outline_join"), "Outline corner style:", choices = c("mitre", "round", "bevel"))
                ),
                
                panel_restore_settings(ns, "Note: if reading from a FASTQ+CSV, make sure you upload the files first <i>then</i> import the settings, otherwise grouping settings will not import properly."),
                
                downloadButton(ns("download_image"), "Download image", class = "mt-3 w-100"),
            )
        ),
        card(
            card_body(
                # Use imageOutput to place the image on the page
                imageOutput(ns("visualisation"), width = "100%", height = "auto"),
            )
        )
    )
}



many_sequences_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        max_grouping_depth <- 10
        termination_value <- "END GROUPING"
        
        
        ## Logic for adding FASTQ parsing settings panel
        fastq_parsing_panel <- tagList(
            checkboxInput(session$ns("chk_fastq_is_modified"), "FASTQ header contains modification information", value = FALSE),
            actionLink(session$ns("fastq_header_details"), "View FASTQ header explanation", icon = icon("info-circle"), class = "mt-0 mb-3"),
            selectInput(session$ns("sel_reverse_mode"), "Reverse sequence processing:", choices = c("Reverse-complement to DNA", "Reverse-complement to RNA", "Reverse without complementing", "Don't reverse")),
            selectInput(session$ns("sel_sort_by"), "Column to sort by:", choices = NULL),
            checkboxInput(session$ns("chk_desc_sort"), "Sort descending", value = TRUE),
            panel_grouping_levels(session, termination_value, max_grouping_depth)
        )
        panel_dynamic_fastq_parsing(input, session, panel_content = fastq_parsing_panel)
        
        
        ## Logic for creating fastq dataframe
        merged_fastq_reactive <- reactive({
            req(input$input_mode == "Upload")
            req(input$fil_fastq_file, input$fil_metadata_file)
            
            ## Read FASTQ
            fastq_data <- if (isTRUE(input$chk_fastq_is_modified)) {
                tryCatch({
                    read_modified_fastq(input$fil_fastq_file$datapath)
                }, error = function(e) {
                    showNotification(paste("Modified FASTQ invalid. Error when parsing:\n", e), type = "error")
                    NULL
                })
            } else {
                tryCatch({
                    read_fastq(input$fil_fastq_file$datapath)
                }, error = function(e) {
                    showNotification(paste("FASTQ invalid. Error when parsing:\n", e), type = "error")
                    NULL
                })
            }
            
            ## Read metadata
            metadata <- tryCatch({
                read.csv(input$fil_metadata_file$datapath)
            }, error = function(e) {
                showNotification(paste("Metadata invalid. Error when parsing:\n", e), type = "error")
                NULL
            })
            
            ## Check it read properly
            req(fastq_data)  
            req(metadata)
                
                
            ## Determine which reversing mode to use
            reverse_complement_mode <- switch(
                input$sel_reverse_mode,
                "Reverse-complement to DNA" = "DNA",
                "Reverse-complement to RNA" = "RNA",
                "Reverse without complementing" = "reverse_only",
                "Don't reverse" = "DNA"
            )
            
            ## Merge and return dataframe
            return(merge_fastq_with_metadata(fastq_data, metadata, reverse_complement_mode = reverse_complement_mode))
        })
        
        
        ## Update sort_by and grouping_levels options from data colnames
        panel_update_sorting_grouping_from_colnames(input, session, merged_fastq_reactive, termination_value, max_grouping_depth)
        
        ## Extract grouping levels vector
        grouping_levels_vector <- process_grouping_levels(input, merged_fastq_reactive, termination_value, max_grouping_depth)
        
        ## Logic for constructing actual input sequences vector
        parsed_sequences <- reactive({
            ## Process input
            if (input$input_mode == "Text input") {
                sequences <- strsplit(input$txt_sequence, split = " ")[[1]]
                
            } else if (input$input_mode == "Upload") {
                if (is.null(input$fil_fastq_file)) {
                    abort("Please upload a FASTQ file...")
                }
                if (is.null(input$fil_metadata_file)) {
                    abort("Please upload a metadata CSV file...")
                }
                
                ## Check sort_by choices are updated (no longer NULL)
                req(input$sel_sort_by)
                
                ## Choose whether to use forward-ified or original sequence
                if (input$sel_reverse_mode == "Don't reverse") {
                    sequence_variable <- "sequence"
                } else {
                    sequence_variable <- "forward_sequence"
                }
                
                ## Choose column (or NA) to sort by
                if (input$sel_sort_by == "Don't sort") {
                    sort_by <- NA
                } else {
                    sort_by <- input$sel_sort_by
                }
                
                ## Extract sequences vector
                sequences <- extract_and_sort_sequences(
                    merged_fastq_reactive(),
                    sequence_variable = sequence_variable,
                    grouping_levels = grouping_levels_vector(),
                    sort_by = sort_by,
                    desc_sort = input$chk_desc_sort
                )
            }
            
            ## Validate and return sequences vector
            validate_sequence(sequences, "Sequences vector for visualisation must contain only A/C/G/T/U and whitespace.")
            return(sequences)
        })
        
        ## Process sequence colours
        sequence_colours <- reactive({process_sequence_colours(input, session, "sel_sequence_colour_palette", "col_custom_")})
        
        ## Process index annotation lines
        index_annotation_lines <- reactive({process_index_annotation_lines(input$txt_index_annotation_lines, "Index annotation lines must contain only the characters 1/2/3/4/5/6/7/8/9/0 arranged as space-separated positive integers")})
        
        ## Create visualisation
        current_image_path <- reactive({
            outfile <- tempfile(fileext = ".png")
            visualise_many_sequences(
                sequences_vector = parsed_sequences(),
                sequence_colours = sequence_colours(),
                background_colour = input$col_background_colour,
                margin = input$num_margin,
                sequence_text_colour = input$col_sequence_text_colour,
                sequence_text_size = input$num_sequence_text_size,
                index_annotation_lines = index_annotation_lines(),
                index_annotation_colour = input$col_index_annotation_colour,
                index_annotation_size = input$num_index_annotation_size,
                index_annotation_interval = input$num_index_annotation_interval,
                index_annotations_above = input$chk_index_annotations_above,
                index_annotation_vertical_position = input$num_index_annotation_vertical_position,
                index_annotation_full_line = input$chk_index_annotation_full_line,
                index_annotation_always_first_base = input$chk_index_annotation_always_first_base,
                outline_colour = input$col_outline_colour,
                outline_linewidth = input$num_outline_linewidth,
                outline_join = input$sel_outline_join,
                return = FALSE,
                filename = outfile,
                force_raster = FALSE,
                render_device = ragg::agg_png,
                pixels_per_base = input$num_pixels_per_base,
                monitor_performance = FALSE
            )
            
            ## Return file
            return(outfile)
        })
        
        output$visualisation <- enable_live_visualisation(current_image_path)
        output$download_image <- enable_image_download(id, current_image_path)
        
        
        
        ## Export settings
        settings <- reactive({
            settings <- list(
                ## Layout
                num_margin = input$num_margin,
                num_pixels_per_base = input$num_pixels_per_base,
                
                ## Colours
                sel_sequence_colour_palette = input$sel_sequence_colour_palette,
                col_custom_A = input$col_custom_A,
                col_custom_C = input$col_custom_C,
                col_custom_G = input$col_custom_G,
                col_custom_T = input$col_custom_T,
                col_background_colour = input$col_background_colour,
                col_sequence_text_colour = input$col_sequence_text_colour,
                col_index_annotation_colour = input$col_index_annotation_colour,
                col_outline_colour = input$col_outline_colour,
                
                ## Sizes and positions
                num_sequence_text_size = input$num_sequence_text_size,
                num_index_annotation_size = input$num_index_annotation_size,
                txt_index_annotation_lines = input$txt_index_annotation_lines,
                num_index_annotation_interval = input$num_index_annotation_interval,
                num_index_annotation_vertical_position = input$num_index_annotation_vertical_position,
                chk_index_annotations_above = input$chk_index_annotations_above,
                chk_index_annotation_full_line = input$chk_index_annotation_full_line,
                chk_index_annotation_always_first_base = input$chk_index_annotation_always_first_base,
                num_outline_linewidth = input$num_outline_linewidth,
                sel_outline_join = input$sel_outline_join,
                
                ## Restore settings
                chk_restore_sequence = input$chk_restore_sequence,
                
                ## FASTQ parsing
                chk_fastq_is_modified = input$chk_fastq_is_modified,
                sel_reverse_mode = input$sel_reverse_mode,
                sel_sort_by = input$sel_sort_by,
                chk_desc_sort = input$chk_desc_sort
            )
            
            for (i in 1:length(grouping_levels_vector())) {
                settings[[paste0("sel_grouping_col_", i)]] <- input[[paste0("sel_grouping_col_", i)]]
                settings[[paste0("num_grouping_int_", i)]] <- input[[paste0("num_grouping_int_", i)]]
            }
            
            if (input$chk_restore_sequence) {
                settings <- append(
                    list(
                        ## Input
                        txt_sequence = input$txt_sequence
                        #fil_sequence_file = input$fil_sequence_file,
                    ),
                    settings
                )
            }
            
            return(settings)
        })
        output$export_settings <- enable_settings_export(settings, id)
        
        ## Import settings
        enable_settings_import(input, session, id, "import_settings")
        
    })
}
