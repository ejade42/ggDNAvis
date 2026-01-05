library(dplyr)
library(shiny)
library(rlang)
library(bslib)
library(jsonlite)
library(markdown)
library(colourpicker)
library(stringr)
library(ggplot2)
library(ggDNAvis)

source("helpers.R")
source("mod_visualise_single_sequence.R")
source("mod_visualise_many_sequences.R")
source("mod_visualise_methylation.R")

## Define links for reuse
ggDNAvis_icon <- "https://raw.githubusercontent.com/ejade42/ggDNAvis/main/pkgdown/favicon/favicon-96x96.png"
ggDNAvis_icon_full_res <- "https://raw.githubusercontent.com/ejade42/ggDNAvis/main/pkgdown/favicon/web-app-manifest-512x512.png"
bugs_link <- extract_link("[link_bugs]: ")
citation_link <- extract_link("[link_citation]: ")
documentation_link <- extract_link("[link_documentation]: ")
source_link <- extract_link("[link_source]: ")


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
        card(
            card_body(
                layout_columns(
                    col_widths = c(9, 1),

                    ## Column 1
                    HTML(create_html_content("instructions.md", "links.md", "help/")),

                    ## Column 2
                    div(
                        style = "position: absolute; top: 20; right: 0",
                        tags$a(
                            href = documentation_link,
                            target = "_blank",
                            tags$img(src = ggDNAvis_icon_full_res, style = "width: 100%; max-width: 200px;")
                        )
                    )
                )
            )
        ),
        card(
            fill = FALSE,
            max_height = "30%",
            card_body(
                layout_columns(
                    col_widths = c(9, 1),
                    HTML(create_html_content("instructions_bottom.md", "links.md", "help/")),
                    div()
                )
            )
        )
    ),

    nav_panel(
        title = "Single sequence",
        single_sequence_ui("visualise-single-sequence")
    ),

    nav_panel(title = "Multiple sequences",
        many_sequences_ui("visualise-many-sequences")
    ),

    nav_panel(title = "Methylation/modification",
        methylation_ui("visualise-methylation")
    ),


    ## Right-hand links
    nav_spacer(), # Pushes next items to the right
    nav_item(
        tags$a(href = citation_link, target = "_blank", icon("google-scholar"), "Citation")
    ),
    nav_item(
        tags$a(href = source_link, target = "_blank", icon("github"), "Source")
    ),
    nav_item(
        tags$a(href = documentation_link, target = "_blank", icon("book"), "Documentation")
    ),
    nav_item(
        tags$a(href = bugs_link, target = "_blank", icon("bacterium"), "Bugs")
    ),
    nav_item(
        input_dark_mode(id = "theme_mode", mode = "light") ## Default to light
    )
)


server <- function(input, output, session) {
    #bs_themer()  ## Uncomment to check out different themes

    single_sequence_server("visualise-single-sequence")
    many_sequences_server("visualise-many-sequences")
    methylation_server("visualise-methylation")
}




shinyApp(ui, server)
