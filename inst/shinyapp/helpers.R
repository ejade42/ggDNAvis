## READ/WRITE/DISPLAY
## ------------------------------------------------------------------------------
## Standardised timestamp formatting
get_current_time <- function() {format(Sys.time(), "%y%m%d-%H.%M.%S")}

## Import settings from JSON
enable_settings_import <- function(input, session, id, import_name = "import_settings") {
    observeEvent(input[[import_name]], {
        tryCatch({
            settings <- read_json(input[[import_name]]$datapath)
            lapply(names(settings), function(id) {
                val <- settings[[id]]

                if (startsWith(id, "num_")) {updateNumericInput(session, id, value = val)}
                if (startsWith(id, "col_")) {updateColourInput(session, id, value = val)}
                if (startsWith(id, "sel_")) {updateSelectInput(session, id, selected = val)}
                if (startsWith(id, "chk_")) {updateCheckboxInput(session, id, value = val)}
                if (startsWith(id, "txt_")) {updateTextInput(session, id, value = val)}
            })
        }, error = function(e) {
            showNotification(paste("Settings file invalid. Error when parsing:\n", e), type = "error")
        })
    })
}

## Export settings to JSON
enable_settings_export <- function(settings, id) {
    downloadHandler(
        filename = function() {
            paste0("ggDNAvis-settings_", id, "_", get_current_time(), ".json")
        },
        ## Can access the list from the wider function environment
        content = function(file) {
            write_json(settings(), file, pretty = TRUE, auto_unbox = TRUE)
        }
    )
}

## Export file to image
enable_image_download <- function(id, image_path) {
    downloadHandler(
        filename = function() {
            paste0("ggDNAvis_", id, "_", get_current_time(), ".png")
        },
        content = function(file) {
            file.copy(image_path(), file)
        }
    )
}

## Show file in browswer
enable_live_visualisation <- function(image_path, alt = "ggDNAvis DNA visualisation") {
    renderImage({
        list(src = image_path(),
             contentType = 'image/png',
             width = "100%",
             height = "auto",
             alt = alt)
    }, deleteFile = FALSE)
}
## ------------------------------------------------------------------------------



## INPUT PROCESSING
## ------------------------------------------------------------------------------
validate_sequence <- function(sequence, message) {
    ## Validate sequence input
    if (grepl("[^ACGTUacgtu\\s \t\r\n]", sequence)) {

        # Optional: Find the specific bad characters to show the user
        bad_chars <- unique(unlist(regmatches(sequence, gregexpr("[^ACGTUacgtu\\s]", sequence))))

        # Stop everything and show this error
        abort(paste0(message, "\nIllegal characters: ", paste(sort(bad_chars), collapse = ", ")))
    }
}


process_sequence_colours <- function(input, session, col_palette_name = "sel_sequence_colour_palette", col_prefix = "col_custom_") {
    if (input[[col_palette_name]] == "custom") {
        sequence_colours = c(input[[paste0(col_prefix, "A")]], input[[paste0(col_prefix, "C")]], input[[paste0(col_prefix, "G")]], input[[paste0(col_prefix, "T")]])
    } else {
        sequence_colours = sequence_colour_palettes[[input[[col_palette_name]]]]
        bases <- c("A", "C", "G", "T")
        for (i in seq_along(sequence_colours)) {
            updateColourInput(session, paste0(col_prefix, bases[i]), value = sequence_colours[i])
        }
    }
    return(sequence_colours)
}
## ------------------------------------------------------------------------------




## INPUT MODULES
## ------------------------------------------------------------------------------
panel_sequence_vis_colours <- function(ns) {
    accordion_panel(
        title = "Colours",

        selectInput(ns("sel_sequence_colour_palette"), "Sequence colour palette:", choices = c("bright_pale", "bright_pale2", "bright_deep", "ggplot_style", "sanger", "custom")),
        conditionalPanel(
            ns = ns,
            condition = "input.sel_sequence_colour_palette == 'custom'",
            fluidRow(
                colourInput(ns("col_custom_A"), "A", value = "#000000"),
                colourInput(ns("col_custom_C"), "C", value = "#000000"),
                colourInput(ns("col_custom_G"), "G", value = "#000000"),
                colourInput(ns("col_custom_T"), "T/U", value = "#000000")
            )
        ),

        colourInput(ns("col_background_colour"), "Background colour:", value = "#FFFFFF"),
        colourInput(ns("col_sequence_text_colour"), "Sequence text colour:", value = "#000000"),
        colourInput(ns("col_index_annotation_colour"), "Index annotation colour:", value = "darkred"),
        colourInput(ns("col_outline_colour"), "Outline colour:", value = "#000000")
    )
}


panel_restore_settings <- function(ns) {
    accordion_panel(
        title = "Restore settings",

        ## Import button is set up as a dummy actionButton linked to a fileInput
        actionButton(ns("import_settings_proxy"), "Import settings", class = "mt-0 w-100", icon = icon("upload"),
                     onclick = paste0("document.getElementById('", ns("import_settings"), "').click()")),
        div(style = "display: none",
            fileInput(ns("import_settings"), NULL, accept = ".json")),

        downloadButton(ns("export_settings"), "Export settings", class = "mt-2 mb-2 w-100"),

        checkboxInput(ns("chk_restore_sequence"), span("Export sequence text input value (will override current value when imported)", style = "font-size: 14px"), value = FALSE)
    )
}
## ------------------------------------------------------------------------------
