library(shiny)
library(rlang)
library(bslib)
library(jsonlite)
library(colourpicker)
library(ggDNAvis)

source("helpers.R")
source("mod_visualise_single_sequence.R")

ui <- page_navbar(
    title = "ggDNAvis interactive tools",
    theme = bs_theme(version = 5),

    nav_panel(title = "Single sequence",
              single_sequence_ui("visualise_single_sequence")),

    # Tab 2: Alignment App
    nav_panel(title = "Multiple sequences",
              # many_sequences_ui("align_app")
              h4("Multiple Sequences Placeholder")
    ),

    # Tab 3: Analysis App
    nav_panel(title = "Methylation/modification",
              # methylation_ui("analysis_app")
              h4("Methylation Placeholder")
    ),

    # Useful: A generic "About" or "Settings" tab
    nav_spacer(), # Pushes next items to the right
    nav_item(
        tags$a(href = "https://github.com/ejade42/ggDNAvis", target = "_blank", icon("github"), "Source"),
    ),
    nav_item(
        tags$a(href = "https://ejade42.github.io/ggDNAvis/", target = "_blank", "Documentation")
    )
)


server <- function(input, output, session) {
    single_sequence_server("visualise_single_sequence")
}




shinyApp(ui, server)
