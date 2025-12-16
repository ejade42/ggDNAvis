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
                        id = ns("input_mode"),
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
                                textInput(ns("txt_probabilities"), "Space-separated lists of modification probabilities", placeholder = "228,12,127,194,50 2,86", value = "228,12,127,194,50 2,86")
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
                        id = ns("outline_colour_mode"),
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
                            numericInput(ns("num_sequence_text_size"), "Sequence text size:", value = 16, step = 1),
                            selectInput(ns("sel_sequence_text_type"), "Sequence text type:", choices = c("Sequence", "Probability", "None")),
                            conditionalPanel(
                                condition = sprintf("input['%s'] == 'Probability'", ns("sel_sequence_text_type")),
                                numericInput(ns("num_sequence_text_scaling_min"), "Minimum value for scaling probabilities:", value = -0.5, step = 0.5),
                                numericInput(ns("num_sequence_text_scaling_max"), "Maximum value for scaling probabilities:", value = 256, step = 5),
                                actionLink(ns("scaling_details"), "View probability scaling explanation", icon = icon("info-circle"), class = "mt-0 mb-3"),
                                numericInput(ns("num_sequence_text_rounding"), "Decimal places to display:", value = 2, min = 0, step = 1)
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
                            checkboxInput(ns("chk_index_annotation_always_first_base"), "Always annotate first base", value = TRUE)
                        ),
                        accordion_panel(
                            title = "Outlines",
                            tabsetPanel(
                                id = ns("outline_size_mode"),
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
                    numericInput(ns("sel_scalebar_outline_colour"), "Outline thickness", value = 1, min = 0, step = 0.25),
                    textInput(ns("txt_scalebar_x_axis_title"), "x-axis title:", value = NULL, placeholder = "Title (optional)"),
                    checkboxInput(ns("chk_scalebar_do_x_ticks"), "Display ticks on x axis", value = TRUE),
                    checkboxInput(ns("chk_scalebar_do_side_scale"), "Show scale in side legend", value = FALSE),
                    conditionalPanel(
                        condition = sprintf("input['%s'] == true", ns("chk_scalebar_do_side_scale")),
                        textInput(ns("txt_scalebar_side_scale_title"), "Side legend title", value = NULL, placeholder = "Title (optional)")
                    )
                ),

                panel_restore_settings(ns, "Note: if reading from a FASTQ+CSV, make sure you upload the files first <i>then</i> import the settings, otherwise grouping settings will not import properly."),

                downloadButton(ns("download_main_image"), "Download main image", class = "mt-3 w-100"),
                downloadButton(ns("download_scalebar"), "Download scalebar", class = "mt-3 w-100")
            )
        ),
        card(
            card_body(
                # Use imageOutput to place the image on the page
                imageOutput(ns("main_visualisation"), width = "100%", height = "auto"),
            ),
            card_body(
                imageOutput(ns("scalebar_visualisation"), width = "50%", height = "auto"),
            )
        )
    )
}



methylation_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        max_grouping_depth <- 10
        termination_value <- "END GROUPING"


        ## Logic for adding FASTQ parsing settings panel - NEED TO UPDATE FOR METHYLATION
        fastq_parsing_panel <- tagList(
            checkboxInput(session$ns("chk_fastq_is_modified"), "FASTQ header contains modification information", value = FALSE),
            actionLink(session$ns("fastq_header_details"), "View FASTQ header explanation", icon = icon("info-circle"), class = "mt-0 mb-3"),
            selectInput(session$ns("sel_reverse_mode"), "Reverse sequence processing:", choices = c("Reverse-complement to DNA", "Reverse-complement to RNA", "Reverse without complementing", "Don't reverse")),
            selectInput(session$ns("sel_sort_by"), "Column to sort by:", choices = NULL),
            checkboxInput(session$ns("chk_desc_sort"), "Sort descending", value = TRUE),
            panel_grouping_levels(session, termination_value, max_grouping_depth)
        )
        panel_dynamic_fastq_parsing(input, session, panel_content = fastq_parsing_panel)



        ## HELP PANELS
        ## - methylation_input_details
        ## - methylation_upload_details
        ## - clamping_details
        ## - scaling_details
    })
}
