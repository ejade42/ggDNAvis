methylation_ui <- function(id) {
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
                        id = ns("tab_input_mode"),
                        tabPanel(
                            "Text input",
                            div(
                                class = "seq-input",
                                textInput(ns("txt_sequences"), "Space-separated sequences to visualise:", placeholder = "GGCGGCGGCGGCGGA AACGCGA", value = "GGCGGCGGCGGCGGA AACGCGA")
                            ),
                            div(
                                class = "seq-input",
                                textInput(ns("txt_locations"), "Space-separated lists of modification locations:", placeholder = "3,6,9,12 3,5", value = "3,6,9,12 3,5")
                            ),
                            div(
                                class = "seq-input",
                                textInput(ns("txt_probabilities"), "Space-separated lists of modification probabilities", placeholder = "228,12,127,194 2,86", value = "228,12,127,194 2,86")
                            ),
                            div(
                                style = "margin-bottom: 15px;",
                                actionLink(ns("methylation_input_details"), "View input requirements", icon = icon("info-circle"), class = "mt-0 mb-3")
                            )
                        ),
                        tabPanel(
                            "Upload",
                            fileInput(ns("fil_fastq_file"), "Upload modified FASTQ:", accept = c(".fastq", ".fq"), placeholder = "No file selected"),
                            fileInput(ns("fil_metadata_file"), "Upload metadata CSV:", accept = c(".csv"), placeholder = "No file selected"),
                            div(
                                style = "margin-bottom: 15px;",
                                actionLink(ns("methylation_upload_details"), "View file requirements", icon = icon("info-circle"), class = "mt-0 mb-3")
                            )
                        )
                    ),
                ),

                accordion_panel(
                    title = "Layout",
                    numericInput(ns("num_low_clamp"), "Low probability clamping value:", value = 0, step = 1),
                    numericInput(ns("num_high_clamp"), "High probability clamping value:", value = 255, step = 1),
                    actionLink(ns("clamping_details"), "View probability clamping explanation", icon = icon("info-circle"), class = "mt-0 mb-3"),
                    numericInput(ns("num_margin"), "Margin:", 0.5, min = 0, step = 0.5),
                    numericInput(ns("num_pixels_per_base"), "Pixels per base:", 100, min = 1, step = 10)
                ),


                accordion_panel(
                    title = "Colours",
                    colourInput(ns("col_low_colour"), "Colour for minimum modification probability:", value = "blue"),
                    colourInput(ns("col_high_colour"), "Colour for maximum modification probability:", value = "red"),
                    colourInput(ns("col_other_bases_colour"), "Colour for non-assessed bases:", value = "grey"),
                    colourInput(ns("col_background_colour"), "Background colour:", value = "#FFFFFF"),
                    colourInput(ns("col_sequence_text_colour"), "Sequence text colour:", value = "#000000"),
                    colourInput(ns("col_index_annotation_colour"), "Index annotation colour:", value = "darkred"),
                    tabsetPanel(
                        id = ns("tab_outline_colour_mode"),
                        tabPanel(
                            "Unified outline colour",
                            colourInput(ns("col_outline_colour"), "Outline colour:", value = "#000000")
                        ),
                        tabPanel(
                            "Split outline colours",
                            colourInput(ns("col_modified_bases_outline_colour"), "Outline colour for modification-assessed bases:", value = "black"),
                            colourInput(ns("col_other_bases_outline_colour"), "Outline colour for non-assessed bases:", value = "darkgrey")
                        )
                    )
                ),

                accordion_panel(
                    title = "Sizes and positions",
                    accordion(
                        id = ns("acc_sizes_positions"),
                        open = c("Sequence text", "Index annotations", "Outlines"),
                        accordion_panel(
                            title = "Sequence text",
                            selectInput(ns("sel_sequence_text_type"), "Sequence text type:", choices = c("Sequence", "Probability", "None")),

                            ## Give different size options behind the scenes to have proper defaults for different sequence text types
                            conditionalPanel(
                                condition = sprintf("input['%s'] == 'Sequence'", ns("sel_sequence_text_type")),
                                numericInput(ns("num_sequence_text_size_sequence"), "Sequence text size:", value = 16, step = 1),
                            ),
                            conditionalPanel(
                                condition = sprintf("input['%s'] == 'Probability' && input['%s'] == 'Integers'", ns("sel_sequence_text_type"), ns("sel_sequence_text_probability_type")),
                                numericInput(ns("num_sequence_text_size_integers"), "Sequence text size:", value = 11, step = 1)
                            ),
                            conditionalPanel(
                                condition = sprintf("input['%s'] == 'Probability' && input['%s'] == 'Probabilities'", ns("sel_sequence_text_type"), ns("sel_sequence_text_probability_type")),
                                numericInput(ns("num_sequence_text_size_probabilities"), "Sequence text size:", value = 10, step = 1)
                            ),
                            conditionalPanel(
                                condition = sprintf("input['%s'] == 'Probability' && input['%s'] == 'Custom'", ns("sel_sequence_text_type"), ns("sel_sequence_text_probability_type")),
                                numericInput(ns("num_sequence_text_size_custom"), "Sequence text size:", value = 10, step = 1)
                            ),

                            ## If type is probability, give options for how to scale
                            conditionalPanel(
                                condition = sprintf("input['%s'] == 'Probability'", ns("sel_sequence_text_type")),
                                selectInput(ns("sel_sequence_text_probability_type"), "Probability scaling:", choices = c("Integers", "Probabilities", "Custom"), selected = "Probabilities"),

                                conditionalPanel(
                                    condition = sprintf("input['%s'] == 'Probabilities'", ns("sel_sequence_text_probability_type")),
                                    numericInput(ns("num_sequence_text_rounding_probabilities"), "Decimal places to display:", value = 2, min = 0, step = 1)
                                ),
                                conditionalPanel(
                                    condition = sprintf("input['%s'] == 'Custom'", ns("sel_sequence_text_probability_type")),
                                    numericInput(ns("num_sequence_text_rounding_custom"), "Decimal places to display:", value = 2, min = 0, step = 1),
                                    numericInput(ns("num_sequence_text_scaling_min"), "Minimum value for scaling probabilities:", value = -0.5, step = 0.5),
                                    numericInput(ns("num_sequence_text_scaling_max"), "Maximum value for scaling probabilities:", value = 256, step = 5),
                                    actionLink(ns("scaling_details"), "View probability scaling explanation", icon = icon("info-circle"), class = "mt-0 mb-3")
                                )

                            )



                        ),
                        accordion_panel(
                            title = "Index annotations",
                            textInput(ns("txt_index_annotation_lines"), "Lines to annotate with indices (space-separated integers):", value = "1 2"),
                            numericInput(ns("num_index_annotation_size"), "Index annotation size:", value = 12.5, min = 0, step = 1),
                            numericInput(ns("num_index_annotation_interval"), "Index annotation interval:", value = 15, min = 0, step = 3),
                            numericInput(ns("num_index_annotation_vertical_position"), "Index annotation height:", value = 1/3, step = 1/6),
                            checkboxInput(ns("chk_index_annotations_above"), "Index annotations above boxes", value = TRUE),
                            checkboxInput(ns("chk_index_annotation_full_line"), "Index annotations always go to the end of the line", value = TRUE),
                            checkboxInput(ns("chk_index_annotation_always_first_base"), "Always annotate first base", value = TRUE),
                            checkboxInput(ns("chk_index_annotation_always_last_base"), "Always annotate last base", value = TRUE)
                        ),
                        accordion_panel(
                            title = "Outlines",
                            tabsetPanel(
                                id = ns("tab_outline_style_mode"),
                                tabPanel(
                                    "Unified outline style",
                                    numericInput(ns("num_outline_linewidth"), "Outline thickness:", value = 3, min = 0, step = 0.5),
                                    selectInput(ns("sel_outline_join"), "Outline corner style:", choices = c("mitre", "round", "bevel"))
                                ),
                                tabPanel(
                                    "Split outline styles",
                                    numericInput(ns("num_modified_bases_outline_linewidth"), "Outline thickness for modification-assessed bases:", value = 3, min = 0, step = 0.5),
                                    numericInput(ns("num_other_bases_outline_linewidth"), "Outline thickness for non-assessed bases:", value = 1, min = 0, step = 0.5),
                                    selectInput(ns("sel_modified_bases_outline_join"), "Outline corner style for modification-assessed bases:", choices = c("mitre", "round", "bevel")),
                                    selectInput(ns("sel_other_bases_outline_join"), "Outline corner style for non-assessed bases:", choices = c("mitre", "round", "bevel"))
                                )
                            )
                        )
                    ),



                ),

                accordion_panel(
                    title = "Scalebar",
                    numericInput(ns("num_scalebar_precision"), "Gradient precision:", value = 1000, step = 100),
                    colourInput(ns("col_scalebar_background"), "Background colour:", value = "white"),
                    colourInput(ns("col_scalebar_outline_colour"), "Outline colour:", value = "black"),
                    numericInput(ns("num_scalebar_outline_linewidth"), "Outline thickness", value = 1, min = 0, step = 0.25),
                    textInput(ns("txt_scalebar_x_axis_title"), "x-axis title:", value = "Modification probability", placeholder = "Title (optional)"),
                    checkboxInput(ns("chk_scalebar_do_x_ticks"), "Display ticks on x axis", value = TRUE),
                    numericInput(ns("num_scalebar_width"), "Scalebar width:", value = 6, step = 0.5),
                    numericInput(ns("num_scalebar_height"), "Scalebar height:", value = 1.5, step = 0.25, min = 0.5),
                    numericInput(ns("num_scalebar_dpi"), "Scalebar dpi:", value = 300, step = 100)
                ),

                panel_restore_settings(ns, "Note: if reading from a FASTQ+CSV, make sure you upload the files first <i>then</i> import the settings, otherwise grouping settings will not import properly.", modification_too = TRUE),

                downloadButton(ns("download_main_image"), "Download main image", class = "mt-3 w-100"),
                downloadButton(ns("download_scalebar"), "Download scalebar", class = "mt-3 w-100")
            )
        ),
        card(
            card_body(
                imageOutput(ns("main_visualisation"), width = "100%", height = "auto")
            ),
        ),
        card(
            fill = FALSE,
            max_height = "40%",
            card_body(
                div(
                    style = "display: block; margin: 0 auto; width: 50%",
                    imageOutput(ns("scalebar_visualisation"), width = "100%", height = "auto")
                )
            )
        )
    )
}



methylation_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        max_grouping_depth <- 10
        termination_value <- "END GROUPING"


        ## Logic for adding FASTQ parsing settings panel
        fastq_parsing_panel <- tagList(
            selectInput(session$ns("sel_modification_type"), "Modification type to visualise", choices = NULL),
            selectInput(session$ns("sel_reverse_mode"), "Reverse sequence processing:", choices = c("Reverse-complement to DNA", "Reverse-complement to RNA", "Reverse without complementing", "Don't reverse")),
            conditionalPanel(
                condition = sprintf("input['%s'].indexOf('Reverse-complement to') == 0", session$ns("sel_reverse_mode")),
                numericInput(session$ns("num_reverse_offset"), "Offset reverse-complemented modification locations by:", value = 0, min = 0, max = 1, step = 1),
                actionLink(session$ns("offset_details"), "View reverse-complementing offset explanation", icon = icon("info-circle"), class = "mt-0 mb-3"),
            ),
            selectInput(session$ns("sel_sort_by"), "Column to sort by:", choices = NULL),
            checkboxInput(session$ns("chk_desc_sort"), "Sort descending", value = TRUE),
            panel_grouping_levels(session, termination_value, max_grouping_depth)
        )
        panel_dynamic_fastq_parsing(input, session, panel_content = fastq_parsing_panel)

        ## Create FASTQ dataframe
        merged_fastq_reactive <- process_merge_input_files(input, fastq_modified_control = TRUE, merge_methylation = TRUE)

        ## Update sort_by and grouping_levels options from data colnames
        panel_update_sorting_grouping_from_colnames(input, session, merged_fastq_reactive, termination_value, max_grouping_depth, do_modification_types = TRUE)

        ## Extract grouping levels vector
        grouping_levels_vector <- process_grouping_levels(input, merged_fastq_reactive, termination_value, max_grouping_depth)

        parsed_inputs <- reactive({
            if (input$tab_input_mode == "Text input") {
                sequences <- strsplit(input$txt_sequences, split = " ")[[1]]
                locations <- strsplit(input$txt_locations, split = " ")[[1]]
                probabilities <- strsplit(input$txt_probabilities, split = " ")[[1]]
                result <- list(locations = locations, probabilities = probabilities, sequences = sequences)

            } else if (input$tab_input_mode == "Upload") {
                if (is.null(input$fil_fastq_file)) {
                    abort("Please upload a modified FASTQ file...")
                }
                if (is.null(input$fil_metadata_file)) {
                    abort("Please upload a metadata CSV file...")
                }

                ## Check sort_by choices are updated (no longer NULL)
                req(input$sel_sort_by)

                ## Choose whether to use forward-ified or original sequence
                if (input$sel_reverse_mode == "Don't reverse") {
                    sequence_variable <- "sequence"
                    locations_variable <- paste0(input$sel_modification_type, "_locations")
                    probabilities_variable <- paste0(input$sel_modification_type, "_probabilities")
                } else {
                    sequence_variable <- "forward_sequence"
                    locations_variable <- paste0("forward_", input$sel_modification_type, "_locations")
                    probabilities_variable <- paste0("forward_", input$sel_modification_type, "_probabilities")
                }

                ## Choose column (or NA) to sort by
                if (input$sel_sort_by == "Don't sort") {
                    sort_by <- NA
                } else {
                    sort_by <- input$sel_sort_by
                }

                ## Extract sequences vector
                result <- extract_and_sort_methylation(
                    merged_fastq_reactive(),
                    locations_colname = locations_variable,
                    probabilities_colname = probabilities_variable,
                    sequences_colname = sequence_variable,
                    grouping_levels = grouping_levels_vector(),
                    sort_by = sort_by,
                    desc_sort = input$chk_desc_sort
                )
            }

            validate_sequence(result$sequences, "Sequences vector for visualisation must contain only A/C/G/T/U and whitespace.")
            return(result)
        })

        ## Process index annotation lines
        index_annotation_lines <- reactive({process_index_annotation_lines(input$txt_index_annotation_lines, "Index annotation lines must contain only the characters 1/2/3/4/5/6/7/8/9/0 arranged as space-separated positive integers")})

        ## Process sequence text size and probability scaling
        sequence_text_options <- process_sequence_text_options(input, session)

        ## Create visualisation
        main_image_path <- reactive({
            ## Process outline
            if (input$tab_outline_colour_mode == "Unified outline colour") {
                modified_bases_outline_colour <- NA
                other_bases_outline_colour <- NA
            } else if (input$tab_outline_colour_mode == "Split outline colours") {
                modified_bases_outline_colour <- input$col_modified_bases_outline_colour
                other_bases_outline_colour <- input$col_other_bases_outline_colour
            }

            if (input$tab_outline_style_mode == "Unified outline style") {
                modified_bases_outline_linewidth <- NA
                modified_bases_outline_join <- NA
                other_bases_outline_linewidth <- NA
                other_bases_outline_join <- NA
            } else if (input$tab_outline_style_mode == "Split outline styles") {
                modified_bases_outline_linewidth <- input$num_modified_bases_outline_linewidth
                modified_bases_outline_join <- input$sel_modified_bases_outline_join
                other_bases_outline_linewidth <- input$num_other_bases_outline_linewidth
                other_bases_outline_join <- input$sel_other_bases_outline_join
            }

            ## Process scaling


            ## Make actual visualisation
            main_outfile <- tempfile(fileext = ".png")
            visualise_methylation(
                modification_locations = parsed_inputs()$locations,
                modification_probabilities = parsed_inputs()$probabilities,
                sequences = parsed_inputs()$sequences,
                low_colour = input$col_low_colour,
                high_colour = input$col_high_colour,
                low_clamp = input$num_low_clamp,
                high_clamp = input$num_high_clamp,
                background_colour = input$col_background_colour,
                other_bases_colour = input$col_other_bases_colour,
                sequence_text_type = input$sel_sequence_text_type,
                sequence_text_scaling = sequence_text_options()$scaling,
                sequence_text_rounding = sequence_text_options()$rounding,
                sequence_text_colour = input$col_sequence_text_colour,
                sequence_text_size = sequence_text_options()$size,
                index_annotation_lines = index_annotation_lines(),
                index_annotation_colour = input$col_index_annotation_colour,
                index_annotation_size = input$num_index_annotation_size,
                index_annotation_interval = input$num_index_annotation_interval,
                index_annotations_above = input$chk_index_annotations_above,
                index_annotation_vertical_position = input$num_index_annotation_vertical_position,
                index_annotation_full_line = input$chk_index_annotation_full_line,
                index_annotation_always_first_base = input$chk_index_annotation_always_first_base,
                index_annotation_always_last_base = input$chk_index_annotation_always_last_base,
                outline_colour = input$col_outline_colour,
                outline_linewidth = input$num_outline_linewidth,
                outline_join = input$sel_outline_join,
                modified_bases_outline_colour = modified_bases_outline_colour,
                modified_bases_outline_linewidth = modified_bases_outline_linewidth,
                modified_bases_outline_join = modified_bases_outline_join,
                other_bases_outline_colour = other_bases_outline_colour,
                other_bases_outline_linewidth = other_bases_outline_linewidth,
                other_bases_outline_join = other_bases_outline_join,
                margin = input$num_margin,
                return = FALSE,
                filename = main_outfile,
                force_raster = FALSE,
                render_device = ragg::agg_png,
                pixels_per_base = input$num_pixels_per_base,
                monitor_performance = FALSE
            )

            ## Return file
            return(main_outfile)
        })


        ## Create scalebar visualisation
        scalebar_image_path <- reactive({
            scalebar_outfile <- tempfile(fileext = ".png")

            scalebar <- visualise_methylation_colour_scale(
                low_colour = input$col_low_colour,
                high_colour = input$col_high_colour,
                low_clamp = input$num_low_clamp,
                high_clamp = input$num_high_clamp,
                full_range = c(0, 255), ## Currently hard-coded
                precision = input$num_scalebar_precision,
                background_colour = input$col_scalebar_background,
                x_axis_title = input$txt_scalebar_x_axis_title,
                do_x_ticks = input$chk_scalebar_do_x_ticks,
                do_side_scale = FALSE,  ## this looks dumb so not exposing it as an option
                outline_colour = input$col_scalebar_outline_colour,
                outline_linewidth = input$num_scalebar_outline_linewidth
            )

            ggsave(
                scalebar_outfile,
                plot = scalebar,
                width = input$num_scalebar_width,
                height = input$num_scalebar_height,
                dpi = input$num_scalebar_dpi,
                device = ragg::agg_png
            )

            return(scalebar_outfile)
        })

        ## Enable visualisation and downloads
        output$main_visualisation <- enable_live_visualisation(main_image_path)
        output$scalebar_visualisation <- enable_live_visualisation(scalebar_image_path)
        output$download_main_image <- enable_image_download(id, main_image_path)
        output$download_scalebar <- enable_image_download(paste0(id, "-scalebar"), scalebar_image_path)



        ## Export settings
        settings <- reactive({
            settings <- list(
                ## Layout
                num_low_clamp = input$num_low_clamp,
                num_high_clamp = input$num_high_clamp,
                num_margin = input$num_margin,
                num_pixels_per_base = input$num_pixels_per_base,

                ## Colours
                col_low_colour = input$col_low_colour,
                col_high_colour = input$col_high_colour,
                col_other_bases_colour = input$col_other_bases_colour,
                col_background_colour = input$col_background_colour,
                col_sequence_text_colour = input$col_sequence_text_colour,
                col_index_annotation_colour = input$col_index_annotation_colour,
                tab_outline_colour_mode = input$tab_outline_colour_mode,
                col_outline_colour = input$col_outline_colour,
                col_modified_bases_outline_colour = input$col_modified_bases_outline_colour,
                col_other_bases_outline_colour = input$col_other_bases_outline_colour,

                ## Sizes and positions
                sel_sequence_text_type = input$sel_sequence_text_type,
                num_sequence_text_size_sequence = input$num_sequence_text_size_sequence,
                num_sequence_text_size_integers = input$num_sequence_text_size_integers,
                num_sequence_text_size_probabilities = input$num_sequence_text_size_probabilities,
                num_sequence_text_size_custom = input$num_sequence_text_size_custom,
                sel_sequence_text_probability_type = input$sel_sequence_text_probability_type,
                num_sequence_text_rounding_probabilities = input$num_sequence_text_rounding_probabilities,
                num_sequence_text_rounding_custom = input$num_sequence_text_rounding_custom,
                num_sequence_text_scaling_max = input$num_sequence_text_scaling_max,
                num_sequence_text_scaling_min = input$num_sequence_text_scaling_min,

                txt_index_annotation_lines = input$txt_index_annotation_lines,
                num_index_annotation_size = input$num_index_annotation_size,
                num_index_annotation_interval = input$num_index_annotation_interval,
                num_index_annotation_vertical_position = input$num_index_annotation_vertical_position,
                chk_index_annotations_above = input$chk_index_annotations_above,
                chk_index_annotation_full_line = input$chk_index_annotation_full_line,
                chk_index_annotation_always_first_base = input$chk_index_annotation_always_first_base,
                chk_index_annotation_always_last_base = input$chk_index_annotation_always_last_base,

                tab_outline_style_mode = input$tab_outline_style_mode,
                num_outline_linewidth = input$num_outline_linewidth,
                num_modified_bases_outline_linewidth = input$num_modified_bases_outline_linewidth,
                num_other_bases_outline_linewidth = input$num_other_bases_outline_linewidth,
                sel_outline_join = input$sel_outline_join,
                sel_modified_bases_outline_join = input$sel_modified_bases_outline_join,
                sel_other_bases_outline_join = input$sel_other_bases_outline_join,

                ## Scalebar
                num_scalebar_precision = input$num_scalebar_precision,
                col_scalebar_background = input$col_scalebar_background,
                col_scalebar_outline_colour = input$col_scalebar_outline_colour,
                num_scalebar_outline_linewidth = input$num_scalebar_outline_linewidth,
                txt_scalebar_x_axis_title = input$txt_scalebar_x_axis_title,
                chk_scalebar_do_x_ticks = input$chk_scalebar_do_x_ticks,
                num_scalebar_width = input$num_scalebar_width,
                num_scalebar_height = input$num_scalebar_height,
                num_scalebar_dpi = input$num_scalebar_dpi,

                ## Restore settings
                chk_restore_sequence = input$chk_restore_sequence
            )

            if (input$tab_input_mode == "Upload") {
                ## FASTQ parsing
                settings[["sel_modification_type"]] = input$sel_modification_type
                settings[["sel_reverse_mode"]] = input$sel_reverse_mode
                settings[["num_reverse_offset"]] = input$num_reverse_offset
                settings[["sel_sort_by"]] = input$sel_sort_by
                settings[["chk_desc_sort"]] = input$chk_desc_sort


                for (i in 1:length(grouping_levels_vector())) {
                    settings[[paste0("sel_grouping_col_", i)]] <- input[[paste0("sel_grouping_col_", i)]]
                    settings[[paste0("num_grouping_int_", i)]] <- input[[paste0("num_grouping_int_", i)]]
                }
            }

            if (input$chk_restore_sequence) {
                settings <- append(list(txt_sequences = input$txt_sequences,
                                        txt_locations = input$txt_locations,
                                        txt_probabilities = input$txt_probabilities),
                                   settings)
            }

            return(settings)
        })
        output$export_settings <- enable_settings_export(settings, id)

        ## Import settings
        enable_settings_import(input, session, id, "import_settings")

        ## Help panels
        popup_markdown(input, "methylation_input_details", "Methylation text input requirements", "popup_methylation_input_details.md")
        popup_markdown(input, "methylation_upload_details", "Methylation file upload requirements", "popup_methylation_upload_details.md")
        popup_markdown(input, "clamping_details", "Methylation probability clamping", "popup_methylation_clamping_details.md")
        popup_markdown(input, "scaling_details", "Methylation custom probability scaling", "popup_methylation_scaling_details.md")
        popup_markdown(input, "offset_details", "Methylation location-reversing offset", "popup_methylation_offset_details.md")
    })
}
