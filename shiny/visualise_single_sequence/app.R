library(shiny)
library(rlang)
library(bslib)
library(colourpicker)
library(ggDNAvis)

ui <- fluidPage(
    theme = bs_theme(version = 5),
    headerPanel("ggDNAvis single sequence visualisation"),
    sidebarLayout(
        sidebarPanel(
            tabsetPanel(
                id = "input_mode",
                tabPanel(
                    "Text input",
                    textInput("sequence", "Sequence to visualise:", placeholder = "ACGT", value = "ACGT")
                ),
                tabPanel(
                    "Upload",
                    fileInput("sequence_file", "Upload FASTA/text:", accept = c(".fasta", ".fa", ".txt"), placeholder = "No file selected"),
                    div(
                        style = "margin-bottom: 15px;",
                        actionLink("fasta_upload_details", "View file requirements", icon = icon("info-circle"), class = "mt-0 mb-3")
                    )
                )
            ),


            accordion(
                id = "acc",
                open = FALSE,

                accordion_panel(
                    title = "Layout",
                    numericInput("line_wrapping", "Bases per line:", 75, min = 1, step = 5),
                    numericInput("spacing", "Line spacing:", 1, min = 0, step = 1),
                    numericInput("margin", "Margin:", 0.5, min = 0, step = 0.5),
                    numericInput("pixels_per_base", "Pixels per base:", 100, min = 1, step = 10)
                ),


                accordion_panel(
                    title = "Colours",

                    selectInput("sequence_colour_palette", "Sequence colour palette:", choices = c(names(sequence_colour_palettes), "custom")),
                    conditionalPanel(
                        condition = "input.sequence_colour_palette == 'custom'",
                        fluidRow(
                            colourInput("custom_A", "A", value = "#000000"),
                            colourInput("custom_C", "C", value = "#000000"),
                            colourInput("custom_G", "G", value = "#000000"),
                            colourInput("custom_T", "T/U", value = "#000000")
                        )
                    ),

                    colourInput("background_colour", "Background colour:", value = "#FFFFFF"),
                    colourInput("sequence_text_colour", "Sequence text colour:", value = "#000000"),
                    colourInput("index_annotation_colour", "Index annotation colour:", value = "darkred"),
                    colourInput("outline_colour", "Outline colour:", value = "#000000")
                ),

                accordion_panel(
                    title = "Sizes and positions",
                    numericInput("sequence_text_size", "Sequence text size:", value = 16, step = 1),
                    numericInput("index_annotation_size", "Index annotation size:", value = 12.5, min = 0, step = 1),
                    numericInput("index_annotation_interval", "Index annotation interval:", value = 15, min = 0, step = 3),
                    numericInput("index_annotation_vertical_position", "Index annotation height:", value = 1/3, step = 1/6),
                    checkboxInput("index_annotations_above", "Index annotations above boxes", value = TRUE),
                    checkboxInput("index_annotation_always_first_base", "Always annotate first base", value = FALSE),
                    numericInput("outline_linewidth", "Outline thickness:", value = 3, min = 0, step = 0.5),
                    selectInput("outline_join", "Outline corner style:", choices = c("mitre", "round", "bevel"))
                )
            ),
            downloadButton("download_image", label = "Download image", class = "mt-3 w-100")
        ),
        mainPanel(
            # Use imageOutput to place the image on the page
            imageOutput("visualisation", width = "100%", height = "auto")
        )
    )
)

server <- function(input, output, session) {
    current_image_path <- reactive({

        ## Process sequence input
        if (input$input_mode == "Text input") {
            sequence <- input$sequence
        } else if (input$input_mode == "Upload") {
            if (is.null(input$sequence_file)) {
                abort("Please upload a file...")
            }

            lines <- readLines(input$sequence_file$datapath)
            sequence <- paste(lines[!grepl("^>", lines)], collapse = "\n")
        }

        ## Validate sequence input
        if (grepl("[^ACGTUacgtu\\s \t\r\n]", sequence)) {

            # Optional: Find the specific bad characters to show the user
            bad_chars <- unique(unlist(regmatches(sequence, gregexpr("[^ACGTUacgtu\\s]", sequence))))

            # Stop everything and show this error
            abort(paste("Input must contain only A/C/G/T/U and whitespace (not counting FASTA header lines).\nIllegal characters:", paste(bad_chars, collapse = ", ")))
        }

        ## Process sequence colours
        if (input$sequence_colour_palette == "custom") {
            sequence_colours = c(input$custom_A, input$custom_C, input$custom_G, input$custom_T)
        } else {
            sequence_colours = sequence_colour_palettes[[input$sequence_colour_palette]]
            updateColourInput(session, "custom_A", value = sequence_colours[1])
            updateColourInput(session, "custom_C", value = sequence_colours[2])
            updateColourInput(session, "custom_G", value = sequence_colours[3])
            updateColourInput(session, "custom_T", value = sequence_colours[4])
        }

        ## Create visualisation
        outfile <- tempfile(fileext = ".png")

        visualise_single_sequence(
            sequence = sequence,
            sequence_colours = sequence_colours,
            background_colour = input$background_colour,
            line_wrapping = input$line_wrapping,
            spacing = input$spacing,
            margin = input$margin,
            sequence_text_colour = input$sequence_text_colour,
            sequence_text_size = input$sequence_text_size,
            index_annotation_colour = input$index_annotation_colour,
            index_annotation_size = input$index_annotation_size,
            index_annotation_interval = input$index_annotation_interval,
            index_annotations_above = input$index_annotations_above,
            index_annotation_vertical_position = input$index_annotation_vertical_position,
            index_annotation_always_first_base = input$index_annotation_always_first_base,
            outline_colour = input$outline_colour,
            outline_linewidth = input$outline_linewidth,
            outline_join = input$outline_join,
            return = FALSE,
            filename = outfile,
            force_raster = FALSE,
            render_device = ragg::agg_png,
            pixels_per_base = input$pixels_per_base,
            monitor_performance = FALSE
        )

        ## Return file
        return(outfile)
    })


    output$visualisation <- renderImage({
        list(src = current_image_path(),
             contentType = 'image/png',
             width = "100%",
             height = "auto",
             alt = "DNA sequence visualisation")
    }, deleteFile = FALSE)

    output$download_image <- downloadHandler(
        filename = function() {
            paste("ggDNAvis_visualise-single-sequence_", format(Sys.time(), "%y%m%d-%H.%M.%S"), ".png", sep="")
        },
        content = function(file) {
            file.copy(current_image_path(), file)
        }
    )



    ## Helper popup
    observeEvent(input$fasta_upload_details, {
        showModal(modalDialog(
            title = "Single sequence file upload requirements",
            h5("Supported formats:"),
            tags$ul(
                tags$li(strong("FASTA:"), "Standard format starting with a '>' header line, followed by the sequence. The sequence is allowed to be on one or multiple lines after the header line. If multiple sequences are present they will be concatenated."),
                tags$li(strong("Plain Text:"), "A simple text file containing only the DNA sequence on one or multiple lines. Lines will be concatenated.")
            ),
            h5("Allowed characters:"),
            tags$ul(
                tags$li("A, C, G, T, and U (uppercase or lowercase)"),
                tags$li("Whitespace will be removed (spaces, tabs, and linebreaks)")
            ),

            easyClose = TRUE,
            footer = modalButton("Close")
        ))
    })
}


shinyApp(ui, server)
