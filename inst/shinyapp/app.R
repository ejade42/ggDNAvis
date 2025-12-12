library(shiny)
library(rlang)
library(bslib)
library(jsonlite)
library(colourpicker)
library(ggDNAvis)

source("helpers.R")
source("mod_visualise_single_sequence.R")
source("mod_visualise_many_sequences.R")


ggDNAvis_icon <- "https://raw.githubusercontent.com/ejade42/ggDNAvis/main/pkgdown/favicon/favicon-96x96.png"

ui <- page_navbar(

    header = tags$head(
        ## Icon in browser tab
        tags$link(rel = "icon", type = "image/png", href = ggDNAvis_icon),

        ## CSS
        tags$style(HTML("
            /* Target ONLY the input box inside the wrapper */
            .seq-input .form-control {
                font-family: 'Courier New', Courier, monospace !important;
                font-weight: bold; /* Optional: makes DNA easier to read */
                letter-spacing: 1px; /* Optional: adds breathing room */
            }
        "))
    ),

    ## Title
    title = tagList(img(src = ggDNAvis_icon, height = "30px"), "ggDNAvis interactive suite"),

    ## Theme
    theme = bs_theme(version = 5, bootswatch = "minty"),


    ## Main tool tabs
    nav_panel(
        title = "Instructions",
        h4("Instructions placeholder")
    ),

    nav_panel(
        title = "Single sequence",
        single_sequence_ui("visualise_single_sequence")
    ),

    nav_panel(title = "Multiple sequences",
        many_sequences_ui("visualise_many_sequences")
    ),

    nav_panel(title = "Methylation/modification",
        # methylation_ui("analysis_app")
        h4("Methylation Placeholder")
    ),


    ## Right-hand links
    nav_spacer(), # Pushes next items to the right
    nav_item(
        tags$a(href = "https://github.com/ejade42/ggDNAvis", target = "_blank", icon("google-scholar"), "Citation")
    ),
    nav_item(
        tags$a(href = "https://github.com/ejade42/ggDNAvis", target = "_blank", icon("github"), "Source")
    ),
    nav_item(
        tags$a(href = "https://ejade42.github.io/ggDNAvis/", target = "_blank", icon("book"), "Documentation")
    ),
    nav_item(
        tags$a(href = "https://github.com/ejade42/ggDNAvis/issues", target = "_blank", icon("bacterium"), "Bugs")
    ),
    nav_item(
        input_dark_mode(id = "theme_mode", mode = "light") # Default to light
    )
)


server <- function(input, output, session) {
    #bs_themer()  ## Uncomment to check out different themes

    single_sequence_server("visualise_single_sequence")
    many_sequences_server("visualise_many_sequences")
}




shinyApp(ui, server)
