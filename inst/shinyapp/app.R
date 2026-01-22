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

ga_id <- "G-QB7HSZ4PJK"

ui <- page_navbar(

    header = list(shinyjs::useShinyjs(), tags$head(
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
        ")),

        ## Timezone detector
        tags$script(HTML("
            $(document).on('shiny:connected', function(event) {
              var timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;
              Shiny.setInputValue('client_time_zone', timeZone);
            });
        ")),

        ## Page view counter
        HTML(paste0("
            <script async src='https://www.googletagmanager.com/gtag/js?id=", ga_id, "'></script>
            <script>
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                gtag('js', new Date());

                // Detect if locally launched vs Posit cloud
                var env_mode = 'cloud'
                if (window.location.hostname === '127.0.0.1' || window.location.hostname === 'localhost') {
                    env_mode = 'local';
                }

                // Detect iframe vs direct
                var is_iframe = (window.self !== window.top);
                var nav_mode = is_iframe ? 'embedded' : 'direct';

                // Detect who is embedding if iframe
                var host_source = '(self)';
                if (is_iframe) {
                     // Use referrer, or fallback if policy blocks it
                    host_source = document.referrer || '(unknown_embedder)';
                }

                gtag('config', '", ga_id, "', {
                    'access_mode': env_mode,
                    'navigation_mode': nav_mode,
                    'parent_host': host_source,
                    'send_page_view': false
                });
            </script>
            "))
    )),

    ## Title & ID
    title = tagList(img(src = ggDNAvis_icon, height = "30px"), "ggDNAvis interactive suite"),
    id = "ggDNAvis_interactive_nav",

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
                        style = "position: absolute; top: 20; right: 0; text-align: center;",
                        tags$a(
                            href = documentation_link,
                            target = "_blank",
                            tags$img(src = ggDNAvis_icon_full_res, style = "width: 100%; max-width: 200px;")
                        ),
                        div(
                            style = "font-size: 0.85rem; color: #999; margin-top: 5px;",
                            paste0("v", packageVersion("ggDNAvis"))
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
    user_tz <- reactive(input$client_time_zone)

    single_sequence_server("visualise-single-sequence", user_tz)
    many_sequences_server("visualise-many-sequences", user_tz)
    methylation_server("visualise-methylation", user_tz)

    ## Check what tabs are most used
    observeEvent(input$ggDNAvis_interactive_nav, {
        current_tab <- input$ggDNAvis_interactive_nav
        clean_path <- paste0("/", gsub(" ", "_", tolower(current_tab)))

        js_command <- sprintf(
            "
            // Virtual Pageview (for Time metrics)
            gtag('event', 'page_view', {
                'page_title': '%s',
                'page_location': window.location.origin + '%s',
                'tab_name': '%s'
            });

            // Custom Event (for historical continuity)
            gtag('event', 'switch_tab', {
                'event_category': 'Navigation',
                'tab_name': '%s'
            });
            ",
            current_tab, clean_path, current_tab,
            current_tab
        )

        shinyjs::runjs(js_command)
    }, ignoreInit = FALSE)
}




shinyApp(ui, server)
