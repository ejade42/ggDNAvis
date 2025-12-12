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
                            fileInput(ns("fil_metadata_file"), "Upload metadata csv:", accept = c(".csv"), placeholder = "No file selected"),
                            div(
                                style = "margin-bottom: 15px;",
                                actionLink(ns("fastq_upload_details"), "View file requirements", icon = icon("info-circle"), class = "mt-0 mb-3")
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
                    numericInput(ns("num_sequence_text_size"), "Sequence text size:", value = 16, step = 1),
                    textInput(ns("txt_index_annotation_lines"), "Index annotation lines:", value = "1"),
                    numericInput(ns("num_index_annotation_size"), "Index annotation size:", value = 12.5, min = 0, step = 1),
                    numericInput(ns("num_index_annotation_interval"), "Index annotation interval:", value = 15, min = 0, step = 3),
                    numericInput(ns("num_index_annotation_vertical_position"), "Index annotation height:", value = 1/3, step = 1/6),
                    checkboxInput(ns("chk_index_annotations_above"), "Index annotations above boxes", value = TRUE),
                    checkboxInput(ns("chk_index_annotation_full_line"), "Index annotations always go to the end of the line", value = TRUE),
                    checkboxInput(ns("chk_index_annotation_always_first_base"), "Always annotate first base", value = FALSE),
                    numericInput(ns("num_outline_linewidth"), "Outline thickness:", value = 3, min = 0, step = 0.5),
                    selectInput(ns("sel_outline_join"), "Outline corner style:", choices = c("mitre", "round", "bevel"))
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



many_sequences_server <- function(id) {
    moduleServer(id, function(input, output, session) {
        ## Create visualisation
        current_image_path <- reactive({
            ## Process input
            if (input$input_mode == "Text input") {
                sequences <- strsplit(input$txt_sequence, split = " ")
            } else if (input$input_mode == "Upload") {
                if (is.null(input$fil_fastq_file)) {
                    abort("Please upload a FASTQ file...")
                }
                if (is.null(input$fil_metadata_file)) {
                    abort("Please upload a metadata CSV file...")
                }
                
                lines <- readLines(input$fil_fastq_file$datapath)
                sequence <- paste(lines[!grepl("^>", lines)], collapse = "\n")
            }
        })
        
        
        
        
        
        
        ## Logic for adding FASTQ parsing settings panel
        fastq_parsing_panel <- tagList(
            selectInput(session$ns("sel_reverse_mode"), "Reverse sequence processing:", choices = c("Reverse-complement DNA", "Reverse-complement RNA", "Reverse without complementing", "Don't reverse"))
        )
        panel_dynamic_fastq_parsing(input, session, panel_content = fastq_parsing_panel)
    })
}
