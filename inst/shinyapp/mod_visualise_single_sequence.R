single_sequence_ui <- function(id) {
    ns <- NS(id)

    layout_sidebar(
        sidebar = sidebar(
            title = "Settings",
            accordion(
                id = ns("acc"),
                open = c("Input"),

                accordion_panel(
                    title = "Input",
                    tabsetPanel(
                        id = ns("tab_input_mode"),
                        tabPanel(
                            "Text input",
                            div(
                                class = "seq-input",
                                textInput(ns("txt_sequence"), "Sequence to visualise:", placeholder = "ACGT", value = "ACGT")
                            )
                        ),
                        tabPanel(
                            "Upload",
                            fileInput(ns("fil_sequence_file"), "Upload FASTA/text:", accept = c(".fasta", ".fa", ".txt"), placeholder = "No file selected"),
                            div(
                                style = "margin-bottom: 15px;",
                                actionLink(ns("fasta_upload_details"), "View file requirements", icon = icon("info-circle"), class = "mt-0 mb-3")
                            )
                        )
                    ),
                ),

                accordion_panel(
                    title = "Layout",
                    numericInput(ns("num_line_wrapping"), "Bases per line:", 75, min = 1, step = 5),
                    numericInput(ns("num_spacing"), "Line spacing:", 1, min = 0, step = 1),
                    numericInput(ns("num_margin"), "Margin:", 0.5, min = 0, step = 0.5),
                    numericInput(ns("num_pixels_per_base"), "Pixels per base:", 100, min = 1, step = 10)
                ),


                panel_sequence_vis_colours(ns),

                accordion_panel(
                    title = "Sizes and positions",
                    accordion(
                        id = ns("acc_sizes_positions"),
                        open = c("Sequence text", "Index annotations", "Outlines"),
                        accordion_panel(
                            title = "Sequence text",
                            numericInput(ns("num_sequence_text_size"), "Sequence text size:", value = 16, step = 1)
                        ),
                        accordion_panel(
                            title = "Index annotations",
                            numericInput(ns("num_index_annotation_size"), "Index annotation size:", value = 12.5, min = 0, step = 1),
                            numericInput(ns("num_index_annotation_interval"), "Index annotation interval:", value = 15, min = 0, step = 3),
                            numericInput(ns("num_index_annotation_vertical_position"), "Index annotation height:", value = 1/3, step = 1/6),
                            checkboxInput(ns("chk_index_annotations_above"), "Index annotations above boxes", value = TRUE),
                            checkboxInput(ns("chk_index_annotation_always_first_base"), "Always annotate first base", value = FALSE)
                        ),
                        accordion_panel(
                            title = "Outlines",
                            numericInput(ns("num_outline_linewidth"), "Outline thickness:", value = 3, min = 0, step = 0.5),
                            selectInput(ns("sel_outline_join"), "Outline corner style:", choices = c("mitre", "round", "bevel"))
                        )
                    ),
                ),

                panel_restore_settings(ns),

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

single_sequence_server <- function(id) {
    moduleServer(id, function(input, output, session) {

        ## Process sequence input
        sequence <- reactive({
            if (input$tab_input_mode == "Text input") {
                sequence <- input$txt_sequence
            } else if (input$tab_input_mode == "Upload") {
                if (is.null(input$fil_sequence_file)) {
                    abort("Please upload a file...")
                }

                lines <- readLines(input$fil_sequence_file$datapath)
                sequence <- paste(lines[!grepl("^>", lines)], collapse = "\n")
            }

            validate_sequence(sequence, "Input must contain only A/C/G/T/U and whitespace (not counting FASTA header lines).")
            return(sequence)
        })



        ## Process sequence colours
        sequence_colours <- reactive({
            sequence_colours <- process_sequence_colours(input, session, "sel_sequence_colour_palette", "col_custom_")
            return(sequence_colours)
        })


        ## Create visualisation
        current_image_path <- reactive({
            outfile <- tempfile(fileext = ".png")
            visualise_single_sequence(
                sequence = sequence(),
                sequence_colours = sequence_colours(),
                background_colour = input$col_background_colour,
                line_wrapping = input$num_line_wrapping,
                spacing = input$num_spacing,
                margin = input$num_margin,
                sequence_text_colour = input$col_sequence_text_colour,
                sequence_text_size = input$num_sequence_text_size,
                index_annotation_colour = input$col_index_annotation_colour,
                index_annotation_size = input$num_index_annotation_size,
                index_annotation_interval = input$num_index_annotation_interval,
                index_annotations_above = input$chk_index_annotations_above,
                index_annotation_vertical_position = input$num_index_annotation_vertical_position,
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


        ## Outputs
        output$visualisation <- enable_live_visualisation(current_image_path)
        output$download_image <- enable_image_download(id, current_image_path)


        ## Export settings
        settings <- reactive({
            settings <- list(
                ## Layout
                num_line_wrapping = input$num_line_wrapping,
                num_spacing = input$num_spacing,
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
                num_index_annotation_interval = input$num_index_annotation_interval,
                num_index_annotation_vertical_position = input$num_index_annotation_vertical_position,
                chk_index_annotations_above = input$chk_index_annotations_above,
                chk_index_annotation_always_first_base = input$chk_index_annotation_always_first_base,
                num_outline_linewidth = input$num_outline_linewidth,
                sel_outline_join = input$sel_outline_join,

                ## Restore settings
                chk_restore_sequence = input$chk_restore_sequence
            )

            if (input$chk_restore_sequence) {
                settings <- append(list(tab_input_mode = input$tab_input_mode,
                                        txt_sequence = input$txt_sequence), settings)
            }

            return(settings)
        })
        output$export_settings <- enable_settings_export(settings, id)

        ## Import settings
        enable_settings_import(input, session, id, "import_settings")


        ## Helper popup
        popup_markdown(input, "fasta_upload_details", "Single sequence file upload requirements", "popup_single_upload_details.md")
    })
}
