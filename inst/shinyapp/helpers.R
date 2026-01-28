## READ/WRITE/DISPLAY
## ------------------------------------------------------------------------------
## Standardised timestamp formatting
get_current_time <- function(tz = NULL) {
    if (is.null(tz) || tz == "") {tz <- Sys.timezone()} ## Fallback
    timezone_format <- "%y.%m.%d-%H.%M.%S"
    tryCatch({
        format(Sys.time(), timezone_format, tz = tz)
    }, error = function(e) {
        format(Sys.time(), timezone_format)
    })
}

## Import settings from JSON
enable_settings_import <- function(input, session, id, import_name = "import_settings") {
    observeEvent(input[[import_name]], {
        tryCatch({
            settings <- read_json(input[[import_name]]$datapath)
            lapply(names(settings), function(setting) {
                val <- settings[[setting]]

                freezeReactiveValue(input, setting)
                if (startsWith(setting, "num_")) {updateNumericInput(session, setting, value = val)}
                if (startsWith(setting, "col_")) {updateColourInput(session, setting, value = val)}
                if (startsWith(setting, "sel_")) {updateSelectInput(session, setting, selected = val)}
                if (startsWith(setting, "chk_")) {updateCheckboxInput(session, setting, value = val)}
                if (startsWith(setting, "txt_")) {updateTextInput(session, setting, value = val)}
                if (startsWith(setting, "tab_")) {updateTabsetPanel(session, setting, selected = val)}
            })

            ## Register successful settings import
            shinyjs::runjs(sprintf(
                "gtag('event', 'settings_import', {'event_category': 'Restore', 'event_label': '%s'});",
                id
            ))

            showNotification("Settings imported successfully!", type = "message")
        }, error = function(e) {
            ## Register unsuccessful settings import
            shinyjs::runjs(sprintf(
                "gtag('event', 'settings_import_error', {'event_category': 'Restore', 'event_label': '%s'});",
                id
            ))

            showNotification(paste("Settings file invalid. Error when parsing:\n", e), type = "error")
        })
    })
}

## Export settings to JSON
enable_settings_export <- function(settings, id, reactive_tz) {
    downloadHandler(
        filename = function() {
            paste0("ggDNAvis-settings_", id, "_", get_current_time(reactive_tz()), ".json")
        },
        ## Can access the list from the wider function environment
        content = function(file) {
            write_json(settings(), file, pretty = TRUE, auto_unbox = TRUE)

            ## Register settings export
            shinyjs::runjs(sprintf(
                "gtag('event', 'settings_export', {'event_category': 'Restore', 'event_label': '%s'});",
                id
            ))
        }
    )
}

## Export file to image
enable_image_download <- function(id, image_path, reactive_tz) {
    downloadHandler(
        filename = function() {
            paste0("ggDNAvis_", id, "_", get_current_time(reactive_tz()), ".png")
        },
        content = function(file) {
            file.copy(image_path(), file)

            ## Register image download
            shinyjs::runjs(sprintf(
                "gtag('event', 'image_download', {'event_category': 'Download', 'event_label': '%s'});",
                id
            ))
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
    sequence <- paste(sequence, collapse = "")

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

process_index_annotation_lines <- function(input_lines, message) {
    ## Validate index annotation input
    if (grepl("[^0123456789\\s \t\r\n]", input_lines)) {

        # Optional: Find the specific bad characters to show the user
        bad_chars <- unique(unlist(regmatches(input_lines, gregexpr("[^0123456789\\s]", input_lines))))

        # Stop everything and show this error
        abort(paste0(message, "\nIllegal characters: ", paste(sort(bad_chars), collapse = ", ")))
    }

    as.integer(strsplit(input_lines, split = " ")[[1]])
}


## Logic for creating fastq dataframe
process_merge_input_files <- function(input, fastq_modified_control = FALSE, merge_methylation = FALSE) {
    reactive({
        req(input$tab_input_mode == "Upload")
        req(input$fil_fastq_file, input$fil_metadata_file)

        ## If control argument is a Bool, use that for T/F selecting modified parsing
        ## If it is a Char, look for an input with that name.
        if (is.logical(fastq_modified_control)) {
            do_modified <- fastq_modified_control
        } else if (is.character(fastq_modified_control) && fastq_modified_control %in% names(input)) {
            do_modified <- isTRUE(input[[fastq_modified_control]])
        } else {
            abort("Invalid fastq_modified_control value passed to process_merge_input_files")
        }

        ## Read FASTQ
        fastq_data <- if (do_modified) {
            tryCatch({
                read_modified_fastq(input$fil_fastq_file$datapath)
            }, error = function(e) {
                showNotification(paste("Modified FASTQ invalid. Error when parsing:\n", e), type = "error")
                NULL
            })
        } else {
            tryCatch({
                read_fastq(input$fil_fastq_file$datapath)
            }, error = function(e) {
                showNotification(paste("FASTQ invalid. Error when parsing:\n", e), type = "error")
                NULL
            })
        }

        ## Read metadata
        metadata <- tryCatch({
            read.csv(input$fil_metadata_file$datapath)
        }, error = function(e) {
            showNotification(paste("Metadata invalid. Error when parsing:\n", e), type = "error")
            NULL
        })

        ## Check it read properly
        req(fastq_data)
        req(metadata)


        ## Determine which reversing mode to use
        reverse_complement_mode <- switch(
            input$sel_reverse_mode,
            "Reverse-complement to DNA" = "DNA",
            "Reverse-complement to RNA" = "RNA",
            "Reverse without complementing" = "reverse_only",
            "Don't reverse" = "DNA"
        )

        ## Merge dataframe
        if (merge_methylation) {
            ## Determine which offset to use
            if (input$num_reverse_offset == 0 || reverse_complement_mode == "reverse_only") {
                reversed_location_offset <- 0
            } else {
                reversed_location_offset <- input$num_reverse_offset
            }
            merged_data <- merge_methylation_with_metadata(fastq_data, metadata, reversed_location_offset = reversed_location_offset, reverse_complement_mode = reverse_complement_mode)
        } else {
            merged_data <- merge_fastq_with_metadata(fastq_data, metadata, reverse_complement_mode = reverse_complement_mode)
        }

        ## Validate and return dataframe
        if (nrow(merged_data) == 0) {
            showNotification(paste0("0 read IDs present in both input FASTQ and metadata CSV.\nFirst 3 input FASTQ read IDs: ", paste(head(fastq_data$read, 3), collapse = " "),
                                    "\nFirst 3 metadata read IDs: ", paste(head(metadata$read, 3), collapse = " ")),
                             type = "error")
        }
        return(merged_data)
    })
}

## Logic for constructing vector out of selected choices
process_grouping_levels <- function(input, merged_data, termination_value, max_grouping_depth) {
    reactive({
        req(merged_data())

        collected_levels <- integer()
        for (i in 1:max_grouping_depth) {
            col_name <- input[[paste0("sel_grouping_col_", i)]]

            ## Exit if column is NULL or End
            if (is.null(col_name) || col_name == termination_value) {
                break
            }

            int_val <- input[[paste0("num_grouping_int_", i)]]

            ## Safety check: ensure integer exists (might be NULL during rendering split-second)
            if (is.null(int_val)) {
                int_val <- NA
            }

            ## Append to vector
            collected_levels[col_name] <- int_val
        }

        if (length(collected_levels) == 0) {
            return(NA)
        } else {
            return(collected_levels)
        }
    })
}

process_sequence_text_options <- function(input, session) {
    reactive({
        if (input$sel_sequence_text_type != "Probability") {
            scaling <- c(0, 1)
            size <- input$num_sequence_text_size_sequence
            rounding <- 0

        } else if (input$sel_sequence_text_probability_type == "Integers") {
            scaling <- c(0, 1)
            size <- input$num_sequence_text_size_integers
            rounding <- 0
            updateNumericInput(session, "num_sequence_text_scaling_min", value = scaling[1])
            updateNumericInput(session, "num_sequence_text_scaling_max", value = scaling[2])
            updateNumericInput(session, "num_sequence_text_size_custom", value = size)
            updateNumericInput(session, "num_sequence_text_rounding_custom", value = rounding)

        } else if (input$sel_sequence_text_probability_type == "Probabilities") {
            scaling <- c(-0.5, 256)
            size <- input$num_sequence_text_size_probabilities
            rounding <- input$num_sequence_text_rounding_probabilities
            updateNumericInput(session, "num_sequence_text_scaling_min", value = scaling[1])
            updateNumericInput(session, "num_sequence_text_scaling_max", value = scaling[2])
            updateNumericInput(session, "num_sequence_text_size_custom", value = size)
            updateNumericInput(session, "num_sequence_text_rounding_custom", value = rounding)

        } else if (input$sel_sequence_text_probability_type == "Custom") {
            scaling <- c(input$num_sequence_text_scaling_min, input$num_sequence_text_scaling_max)
            size <- input$num_sequence_text_size_custom
            rounding <- input$num_sequence_text_rounding_custom
        }

        return(list(scaling = scaling, size = size, rounding = rounding))
    })
}
## ------------------------------------------------------------------------------




## INPUT MODULES
## ------------------------------------------------------------------------------
## Panel for single sequence/multiple sequences colour selection
panel_sequence_vis_colours <- function(ns) {
    accordion_panel(
        title = "Colours",

        selectInput(ns("sel_sequence_colour_palette"), "Sequence colour palette:", choices = c("bright_pale", "bright_pale2", "bright_deep", "ggplot_style", "sanger", "accessible", "custom")),
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

## Panel for settings import/export
panel_restore_settings <- function(ns, help_message = NULL, modification_too = FALSE) {
    if (modification_too) {
        span_message <- "Export sequence / locations / probabilities text input value (will override current value when imported)"
    } else {
        span_message <- "Export sequence text input value (will override current value when imported)"
    }

    accordion_panel(
        title = "Restore settings",

        p(HTML(help_message), style = "font-size: 14px"),

        ## Import button is set up as a dummy actionButton linked to a fileInput
        actionButton(ns("import_settings_proxy"), "Import settings", class = "mt-0 w-100", icon = icon("upload"),
                     onclick = paste0("document.getElementById('", ns("import_settings"), "').click()")),
        div(style = "display: none",
            fileInput(ns("import_settings"), NULL, accept = ".json")),

        downloadButton(ns("export_settings"), "Export settings", class = "mt-2 mb-2 w-100"),

        checkboxInput(ns("chk_restore_sequence"), span(span_message, style = "font-size: 14px"), value = FALSE)
    )
}

## Dynamically inserted panel for FASTQ parsing settings
panel_dynamic_fastq_parsing <- function(
    input,
    session,
    panel_content,
    accordion_id = "acc",
    target_panel = "Input",
    trigger_var = "tab_input_mode"
) {
    observeEvent(input[[trigger_var]], {
        panel_id <- "fastq_parsing_settings"
        if (input[[trigger_var]] == "Upload") {
            tryCatch({
                ## Insert FASTQ parsing panel with specified content
                accordion_panel_insert(
                    id = accordion_id,

                    panel = accordion_panel(
                        title = "FASTQ parsing",
                        value = panel_id,
                        panel_content
                    ),

                    target = target_panel,
                    position = "after"
                )

                ## Automatically open the new panel
                accordion_panel_open(
                    id = accordion_id,
                    values = panel_id
                )

            }, error = function(e) message(paste("accordion insert failed:", e)))
        } else {
            ## Remove panel when close
            accordion_panel_remove(id = accordion_id, target = panel_id)
        }
    })
}

## Recursive conditional panels for grouping levels
panel_grouping_levels <- function(session, termination_value, max_grouping_depth) {
    lapply(1:max_grouping_depth, function(i) {
        ## Create previous-layer condition string to use for javascript flow
        if (i == 1) {
            cond_string <- "true"
        } else {
            cond_string <- sprintf("input['%s'] != '%s'", session$ns(paste0("sel_grouping_col_", i-1)), termination_value)
        }

        conditionalPanel(
            condition = cond_string,
            selectInput(
                session$ns(paste0("sel_grouping_col_", i)),
                label = if (i==1) {"(1) Firstly, group by column:"} else {paste0("(", i, ") Then, group by column:")},
                choices = c(termination_value)
            ),
            conditionalPanel(
                condition = sprintf("input['%s'] != '%s'", session$ns(paste0("sel_grouping_col_", i)), termination_value),
                numericInput(
                    session$ns(paste0("num_grouping_int_", i)),
                    label = "Lines between each value:",
                    value = 1,
                    step = 1,
                    min = 0
                )
            )

        )
    })
}

## Helper-helper function for updating selectInput based on colnames
update_selection_if_null <- function(current_val, cols, default) {
    if (!is.null(current_val) && current_val %in% cols) {
        return(current_val)
    } else {
        return(default)
    }
}

## Logic for updating sort_by and grouping_levels choices
panel_update_sorting_grouping_from_colnames <- function(input, session, data_to_read_cols, termination_value, max_grouping_depth, do_modification_types = FALSE) {
    observeEvent(data_to_read_cols(), {
        df <- data_to_read_cols()
        req(df)
        cols <- colnames(df)

        ## Update sort_by choices

        updateSelectInput(session, "sel_sort_by",
                          choices = c("Don't sort", cols),
                          selected = update_selection_if_null(input[["sel_sort_by"]], cols, "sequence_length"))

        ## If desired, update modification types choices
        if (do_modification_types) {
            modification_types <- sort(unique(string_to_vector(df[["modification_types"]], type = "character")))
            ## Default to 5-cytosine-methylation if available
            methylation_types <- sort(modification_types[substr(modification_types, 1, 3) == "C+m"])
            default_modification_type <- ifelse(length(methylation_types) >= 1, methylation_types[1], modification_types[1])
            updateSelectInput(session, "sel_modification_type",
                              choices = modification_types,
                              selected = update_selection_if_null(input[["sel_modification_type"]], cols, default_modification_type))
        }

        ## Update grouping levels choices
        lapply(1:max_grouping_depth, function(i) {
            updateSelectInput(
                session,
                paste0("sel_grouping_col_", i),
                choices = c(termination_value, cols),
                selected = update_selection_if_null(input[[paste0("sel_grouping_col_", i)]], cols, termination_value)
            )
        })
    })
}


## Show helper popup from markdown
popup_markdown <- function(input, button_name, title, filename, links_file = "links.md") {
    html_content <- create_html_content(filename, links_file, "help/")

    observeEvent(input[[button_name]], {
        showModal(modalDialog(
            title = title,
            withMathJax(HTML(html_content)),
            easyClose = TRUE,
            footer = modalButton("Close")
        ))
    })
}

## Create HTML from content + links markdowns
create_html_content <- function(content_file, links_file, directory = "help/") {
    content <- readLines(paste0(directory, content_file), warn = FALSE)
    links   <- readLines(paste0(directory, links_file), warn = FALSE)

    combined_text <- paste(c(content, "\n", links), collapse = "\n")
    combined_html <- markdown::markdownToHTML(text = combined_text, fragment.only = TRUE)
    combined_html <- gsub("<a ", "<a target='_blank' rel='noopener noreferrer' ", combined_html)

    return(combined_html)
}

## Extract link from links md
extract_link <- function(link_id, links_file = "help/links.md") {
    readLines(links_file) %>%
        str_subset(fixed(link_id)) %>%
        strsplit(., split = "]: ") %>%
        .[[1]] %>% .[2]
}
## ------------------------------------------------------------------------------
