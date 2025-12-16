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
                            div(class = "seq-input", 
                                textInput(ns("txt_sequences"), "Space-separated sequences to visualise:", placeholder = "GGCGGCGGCGGCGGA AACGCGA", value = "GGCGGCGGCGGCGGA AACGCGA")
                            ),
                            div(class = "seq-input",
                                textInput(ns("txt_locations"), "Space-separated lists of modification locations:", placeholder = "3,6,9,12 3,5", value = "3,6,9,12 3,5")
                            ),
                            div(class = "seq-input",
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



methylation_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        max_grouping_depth <- 10
        termination_value <- "END GROUPING"
        
    })
}
