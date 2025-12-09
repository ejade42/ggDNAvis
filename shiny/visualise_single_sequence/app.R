library(shiny)
library(bslib)
library(colourpicker)
library(ggDNAvis)
library(png)

ui <- fluidPage(
    theme = bs_theme(version = 5),
    headerPanel("ggDNAvis single sequence visualisation"),
    sidebarLayout(
        sidebarPanel(
            textInput("sequence", "Sequence to visualise:", placeholder = "ACGT", value = "ACGT"),

            numericInput("line_wrapping", "Bases per line:", 75, min = 1),
            accordion(
                id = "acc",
                open = FALSE,


                accordion_panel(
                    title = "Colours",

                    selectInput("sequence_colour_palette", "Sequence colour palette:", choices = c(names(sequence_colour_palettes), "custom")),
                    conditionalPanel(
                        condition = "input.sequence_colour_palette == 'custom'",
                        h4("Define Custom Colours"),

                        # Use splitLayout to put them side-by-side for a cleaner look
                        fluidRow(
                            colourInput("custom_A", "A", value = "#000000"),
                            colourInput("custom_C", "C", value = "#555555")
                        ),
                        fluidRow(
                            colourInput("custom_G", "G", value = "#AAAAAA"),
                            colourInput("custom_T", "T", value = "#FFFFFF")
                        ),
                        helpText("Click the boxes to pick a hex code.")
                    ),

                    colourInput("sequence_text_colour", "Sequence text colour:", value = "black")
                ),


                accordion_panel(
                    title = "Export settings",
                    numericInput("pixels_per_base", "Pixels per base:", 100, min = 1)
                )
            )
        ),
        mainPanel(
            # Use imageOutput to place the image on the page
            imageOutput("visualisation", width = "100%", height = "auto")
        )
    )
)

server <- function(input, output, session) {
    output$visualisation <- renderImage({
        outfile <- tempfile(fileext = ".png")

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
        suppressMessages(
            visualise_single_sequence(
                sequence = input$sequence,
                sequence_colours = sequence_colours,
                sequence_text_colour = input$sequence_text_colour,
                line_wrapping = input$line_wrapping,
                filename = outfile,
                return = FALSE,
                pixels_per_base = input$pixels_per_base
            )
        )

        ## Return file
        list(src = outfile,
             contentType = 'image/png',
             width = "100%",
             height = "auto",
             alt = "DNA sequence visualisation")

    }, deleteFile = TRUE)

}


shinyApp(ui, server)
