#' Visualise a single DNA/RNA sequence
#'
#' This function takes a DNA/RNA sequence and returns a ggplot
#' visualising it, with the option to directly export a png image
#' with appropriate dimensions. Colours, line wrapping, index annotation
#' interval, and pixels per square when exported are configurable.
#'
#' @param sequence `character`. A DNA or RNA sequence to visualise e.g. `"AAATGCTGC"`.
#' @param sequence_colours `character vector`, length 4. A vector indicating which colours should be used for each base. In order: `c(A_colour, C_colour, G_colour, T/U_colour)`.\cr\cr Defaults to red, green, blue, purple in the default shades produced by ggplot with 4 colours, i.e. `c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF")`, accessed via [`sequence_colour_palettes`]`$ggplot_style`.
#' @param background_colour `character`. The colour of the background. Defaults to white.
#' @param line_wrapping `integer`. The number of bases that should be on each line before wrapping. Defaults to `75`. Recommended to make this a multiple of the repeat unit size (e.g. 3*n* for a trinucleotide repeat) if visualising a repeat sequence.
#' @param spacing `integer`. The number of blank lines between each line of sequence. Defaults to `1`.\cr\cr Be careful when setting to `0` as this means annotations have no space so might render strangely. Recommended to set `index_annotation_interval = 0` if doing so to disable annotations entirely.
#' @param margin `numeric`. The size of the margin relative to the size of each base square. Defaults to `0.5` (half the side length of each base square).\cr\cr Note that if index annotations are on (i.e. `index_annotation_interval` is not `0`), the top/bottom margin (depending on `index_annotations_above`) will always be at least 1 to leave space for them.\cr\cr Likewise, very small margins (\eqn{\le}0.25) may cause thick outlines to be cut off at the edges of the plot. Recommended to either use a wider margin or a smaller `outline_linewidth`.
#' @param sequence_text_colour `character`. The colour of the text within the bases (e.g. colour of "A" letter within boxes representing adenosine bases). Defaults to black.
#' @param sequence_text_size `numeric`. The size of the text within the bases (e.g. size of "A" letter within boxes representing adenosine bases). Defaults to `16`. Set to `0` to hide sequence text (show box colours only).
#' @param index_annotation_colour `character`. The colour of the little numbers underneath indicating base index (e.g. colour "15" label under the 15th base). Defaults to dark red.
#' @param index_annotation_size `numeric`. The size of the little number underneath indicating base index (e.g. size of "15" label under the 15th base). Defaults to `12.5`.\cr\cr Can sometimes be set to `0` to turn off annotations, but it is better/more reliable to do this via `index_annotation_interval = 0`.
#' @param index_annotation_interval `integer`. The frequency at which numbers should be placed underneath indicating base index, starting counting from the leftmost base in each row. Defaults to `15` (every 15 bases along each row).\cr\cr Recommended to make this a factor/divisor of the line wrapping length (meaning the final base in each line is annotated), otherwise the numbering interval resetting at the beginning of each row will result in uneven intervals at each line break.\cr\cr Set to `0` to turn off annotations (preferable over using `index_annotation_size = 0`).
#' @param index_annotations_above `logical`. Whether index annotations should go above (`TRUE`, default) or below (`FALSE`) each line of sequence.
#' @param index_annotation_vertical_position `numeric`. How far annotation numbers should be rendered above (if `index_annotations_above = TRUE`) or below (if `index_annotations_above = FALSE`) each base. Defaults to `1/3`.\cr\cr Not recommended to change at all. Strongly discouraged to set below 0 or above 1.
#' @param outline_colour `character`. The colour of the box outlines. Defaults to black.
#' @param outline_linewidth `numeric`. The linewidth of the box outlines. Defaults to `3`. Set to `0` to disable box outlines.
#' @param outline_join `character`. One of `"mitre"`, `"round"`, or `"bevel"` specifying how outlines should be joined at the corners of boxes. Defaults to `"mitre"`. It would be unusual to need to change this.
#' @param return `logical`. Boolean specifying whether this function should return the ggplot object, otherwise it will return `invisible(NULL)`. Defaults to `TRUE`.
#' @param filename `character`. Filename to which output should be saved. If set to `NA` (default), no file will be saved. Recommended to end with `".png"`, but can change if render device is changed.
#' @param render_device `function/character`. Device to use when rendering. See [ggplot2::ggsave()] documentation for options. Defaults to [`ragg::agg_png`]. Can be set to `NULL` to infer from file extension, but results may vary between systems.
#' @param pixels_per_base `integer`. How large each box should be in pixels, if file output is turned on via setting `filename`. Corresponds to dpi of the exported image. Large values recommended because text needs to be legible when rendered significantly smaller than a box. Defaults to `100`.
#'
#' @return A ggplot object containing the full visualisation, or `invisible(NULL)` if `return = FALSE`. It is often more useful to use `filename = "myfilename.png"`, because then the visualisation is exported at the correct aspect ratio.
#'
#' @examples
#' \donttest{
#' ## Create sequence to visualise
#' sequence <- paste(c(rep("GGC", 72), rep("GGAGGAGGCGGC", 15)), collapse = "")
#'
#' ## Visualise with all defaults
#' ## This looks ugly because it isn't at the right scale/aspect ratio
#' visualise_single_sequence(sequence)
#'
#' ## Export with all defaults rather than returning
#' visualise_single_sequence(
#'     sequence,
#'     filename = "example_vss_01.png",
#'     return = FALSE
#' )
#' ## View exported image
#' image <- png::readPNG("example_vss_01.png")
#' unlink("example_vss_01.png")
#' grid::grid.newpage()
#' grid::grid.raster(image)
#'
#' ## Export while customising appearance
#' visualise_single_sequence(
#'     sequence,
#'     filename = "example_vss_02.png",
#'     return = FALSE,
#'     sequence_colours = sequence_colour_palettes$bright_pale,
#'     sequence_text_colour = "white",
#'     background_colour = "lightgrey",
#'     line_wrapping = 60,
#'     spacing = 2,
#'     outline_linewidth = 0,
#'     index_annotations_above = FALSE,
#'     margin = 0
#' )
#' ## View exported image
#' image <- png::readPNG("example_vss_02.png")
#' unlink("example_vss_02.png")
#' grid::grid.newpage()
#' grid::grid.raster(image)
#' }
#'
#' @export
visualise_single_sequence <- function(sequence, sequence_colours = sequence_colour_palettes$ggplot_style, background_colour = "white",
                                      line_wrapping = 75, spacing = 1, margin = 0.5, sequence_text_colour = "black", sequence_text_size = 16,
                                      index_annotation_colour = "darkred", index_annotation_size = 12.5, index_annotation_interval = 15,
                                      index_annotations_above = TRUE, index_annotation_vertical_position = 1/3,
                                      outline_colour = "black", outline_linewidth = 3, outline_join = "mitre",
                                      return = TRUE, filename = NA, render_device = ragg::agg_png, pixels_per_base = 100) {
    ## Validate arguments
    for (argument in list(sequence, sequence_colours, background_colour, line_wrapping, spacing, margin, sequence_text_colour, sequence_text_size, index_annotation_colour, index_annotation_size, index_annotation_interval, index_annotations_above, index_annotation_vertical_position, outline_colour, outline_linewidth, outline_join, return, filename, pixels_per_base)) {
        if (mean(is.null(argument)) != 0) {abort(paste("Argument", argument, "must not be null."), class = "argument_value_or_type")}
    }
    for (argument in list(sequence, background_colour, outline_colour, line_wrapping, spacing, sequence_text_colour, sequence_text_size, index_annotation_colour, index_annotation_size, index_annotation_interval, index_annotations_above, index_annotation_vertical_position, outline_colour, outline_linewidth, outline_join, return, filename, pixels_per_base, margin)) {
        if (length(argument) != 1) {abort(paste("Argument", argument, "must have length 1"), class = "argument_value_or_type")}
    }
    for (argument in list(sequence, sequence_colours, background_colour, sequence_text_colour, sequence_text_size, index_annotation_colour, index_annotation_size, index_annotation_interval, index_annotations_above, index_annotation_vertical_position, line_wrapping, spacing, outline_colour, outline_linewidth, outline_join, return, pixels_per_base, margin)) {
        if (mean(is.na(argument)) != 0) {abort(paste("Argument", argument, "must not be NA"), class = "argument_value_or_type")}
    }
    if (is.character(sequence_colours) == FALSE || length(sequence_colours) != 4) {
        abort("Must provide exactly 4 sequence colours, in A C G T order, as a length-4 character vector.", class = "argument_value_or_type")
    }
    for (argument in list(sequence, background_colour, sequence_text_colour, index_annotation_colour, outline_colour, outline_join)) {
        if (is.character(argument) == FALSE) {abort(paste("Argument", argument, "must be a character/string value."), class = "argument_value_or_type")}
    }
    if (is.numeric(index_annotation_vertical_position) == FALSE) {
        abort("Index annotation vertical position must be a numeric value", class = "argument_value_or_type")
    }
    if (index_annotation_vertical_position < 0 || index_annotation_vertical_position > 1) {
        warn("Not recommended to set index annotation vertical position outside range 0-1.", class = "parameter_recommendation")
    }
    for (argument in list(sequence_text_size, index_annotation_size, index_annotation_interval, spacing, pixels_per_base, line_wrapping, margin, outline_linewidth)) {
        if (is.numeric(argument) == FALSE || is.logical(argument) == TRUE || argument < 0) {abort(paste("Argument", argument, "must be a non-negative number."), class = "argument_value_or_type")}
    }
    for (argument in list(line_wrapping, spacing, pixels_per_base, index_annotation_interval)) {
        if (argument %% 1 != 0) {abort(paste("Argument", argument, "must be an integer."), class = "argument_value_or_type")}
    }
    for (argument in list(line_wrapping, pixels_per_base)) {
        if (argument < 1) {abort(paste("Argument", argument, "must be at least 1."), class = "argument_value_or_type")}
    }
    for (argument in list(return, index_annotations_above)) {
        if (is.logical(argument) == FALSE) {abort(paste("Argument:", argument, "must be a logical/boolean value."), class = "argument_value_or_type")}
    }
    if (spacing == 0 && !(index_annotation_size == 0 || index_annotation_interval == 0)) {
        warn("Using spacing = 0 without disabling index annotation is not recommended.\nIt is likely to draw the annotations overlapping the sequence.\nRecommended to set index_annotation_interval = 0 to disable index annotations.", class = "parameter_recommendation")
    }
    if (!(tolower(outline_join) %in% c("mitre", "round", "bevel"))) {
        abort("outline_join must be one of 'mitre', 'round', or 'bevel'.", class = "argument_value_or_type")
    }
    ## If annotations are disabled via size, spacing is set to 0, but there would be an
    ## annotation on the last line (i.e. seq_length %% line_wrapping >= index_annotation_interval)
    ## then some grey boxes show up at the bottom. This cautions against setting parameters
    ## in such a way that that would happen
    if (index_annotation_size == 0 && index_annotation_interval != 0) {
        warn("It is better to disable index annotations via index_annotation_interval = 0.\nDoing so via index_annotation_size = 0 can lead to rendering issues in some cases.", class = "parameter_recommendation")
    }
    ## Warn about outlines getting cut off
    if (margin <= 0.25 && outline_linewidth > 0) {
        warn("If margin is small and outlines are on (outline_linewidth > 0), outlines may be cut off at the edges of the plot. Check if this is happening and consider using a bigger margin.", class = "parameter_recommendation")
    }
    ## Accept NA as NULL for render_device
    if (is.atomic(render_device) && any(is.na(render_device))) {render_device <- NULL}


    ## Generate data for plotting
    sequences <- convert_input_seq_to_sequence_list(sequence, line_wrapping, spacing, index_annotations_above)

    ## Trim extra spacing if >1 so margins don't go crazy
    if (spacing > 1) {
        if (index_annotations_above == TRUE) {
            sequences <- sequences[spacing:length(sequences)]
        } else if (index_annotations_above == FALSE) {
            sequences <- sequences[1:(length(sequences)-spacing+1)]
        }
    }

    # Finish generating data for plotting
    if (max(nchar(sequences)) < line_wrapping) {line_wrapping <- max(nchar(sequences))}
    annotations <- convert_sequences_to_annotations(sequences, line_wrapping, index_annotation_interval, index_annotations_above, index_annotation_vertical_position)
    image_data <- create_image_data(sequences)


    ## Name the sequence colours vector
    names(sequence_colours) <- as.character(1:4)

    ## Calculate tile dimensions
    tile_width  <- 1/max(nchar(sequences))
    tile_height <- 1/length(sequences)

    ## Generate plot
    result <- ggplot(image_data, aes(x = .data$x, y = .data$y)) +
        ## Background
        geom_tile(data = filter(image_data, layer == 0), width = tile_width, height = tile_height, fill = background_colour) +

        ## Base boxes
        geom_tile(data = filter(image_data, layer != 0), width = tile_width, height = tile_height, aes(fill = as.character(.data$layer)),
                  col = outline_colour, linewidth = outline_linewidth, linejoin = tolower(outline_join)) +
        scale_fill_manual(values = sequence_colours) +

        ## Text (sequence and annotations)
        geom_text(data = annotations, aes(x = .data$x_position, y = .data$y_position, label = .data$annotation, col = .data$type, size = .data$type), fontface = "bold", inherit.aes = F) +
        scale_colour_manual(values = c("Number" = index_annotation_colour, "Sequence" = sequence_text_colour)) +
        scale_discrete_manual("size", values = c("Number" = index_annotation_size, "Sequence" = sequence_text_size)) +

        ## General plot setup
        guides(x = "none", y = "none", fill = "none", col = "none", size = "none") +
        coord_cartesian(expand = FALSE, clip = "off") +
        theme(axis.title = element_blank(),
              plot.background = element_rect(fill = background_colour, colour = NA))


    ## As long as the lines are spaced out, don't need a bottom margin as the blank spacer line does that
    ## But if spacing is turned off, need to add a bottom margin
    if (spacing == 0) {
        result <- result + theme(plot.margin = grid::unit(c(margin, margin, margin, margin), "inches"))
        extra_height <- 2 * margin
    } else if (index_annotations_above == TRUE) {
        result <- result + theme(plot.margin = grid::unit(c(max(margin-1, 0), margin, margin, margin), "inches"))
        extra_height <- margin + max(margin-1, 0)
    } else if (index_annotations_above == FALSE) {
        result <- result + theme(plot.margin = grid::unit(c(margin, margin, max(margin-1, 0), margin), "inches"))
        extra_height <- margin + max(margin-1, 0)
    } else {
        abort("Unexpected value of spacing and/or index_annotations_above. Should have been caught by previous test. Please report.")
    }

    ## Check if filename is set and warn if not png, then export image
    if (is.na(filename) == FALSE) {
        if (is.character(filename) == FALSE) {
            abort("Filename must be a character/string (or NA if no file export wanted)", class = "argument_value_or_type")
        }
        if (tolower(substr(filename, nchar(filename)-3, nchar(filename))) != ".png") {
            warn("Not recommended to use non-png filetype (but may still work).", class = "filetype_recommendation")
        }
        ggsave(filename, plot = result, dpi = pixels_per_base, device = render_device, width = max(nchar(sequences))+(2*margin), height = length(sequences)+extra_height, limitsize = FALSE)
    }

    ## Return either the plot object or NULL
    if (return == TRUE) {
        return(result)
    }
    return(invisible(NULL))
}


## UNIQUE HELPER FUNCTIONS
## "Missing" functions are likely in dna_tools.R as they are common to multiple visualisations


#' Split a single input sequence into a vector of "lines" for visualisation ([visualise_single_sequence()] helper)
#'
#' Takes a single input sequence and an integer line length, and splits the input
#' sequence into lines of that length (with the last line potentially being shorter). \cr\cr
#' Optionally inserts empty strings `""` after each line to space them out.
#'
#' @param input_seq `character`. A DNA/RNA sequence (or for the purposes of this function, any string, though only DNA/RNA will work with later functions) to be split up.
#' @param line_length `integer`. How long each line (split-up section) should be.
#' @param spacing `integer`. How many blank lines to leave before/after each line of sequence. Defaults to `0`.
#' @param spaces_first `logical`. Whether blank lines should come before (`TRUE`, default) or after (`FALSE`) each line of sequence.
#'
#' @return `character vector`. The input sequence split into multiple lines, with specified spacing in between.
#'
#' @examples
#' convert_input_seq_to_sequence_list(
#'     "GGCGGCGGC",
#'     line_length = 6,
#'     spacing = 1,
#'     spaces_first = TRUE
#' )
#'
#' convert_input_seq_to_sequence_list(
#'     "GGCGGCGGC",
#'     line_length = 3,
#'     spacing = 2,
#'     spaces_first = FALSE
#' )
#'
#' convert_input_seq_to_sequence_list(
#'     "GGCGGCGGC",
#'     line_length = 6,
#'     spacing = 0
#' )
#'
#' @export
convert_input_seq_to_sequence_list <- function(input_seq, line_length, spacing = 1, spaces_first = TRUE) {
    for (argument in list(input_seq, line_length, spacing, spaces_first)) {
        if (mean(is.null(argument)) != 0 || mean(is.na(argument)) != 0) {abort(paste("Argument", argument, "must not be null or NA."), class = "argument_value_or_type")}
    }
    if (length(input_seq) != 1 || length(line_length) != 1 || length(spacing) != 1 || length(spaces_first) != 1) {
        abort("Input sequence, line length, spacing, and top/bottom spaces setting must all be single values (length 1).", class = "argument_value_or_type")
    }
    if (is.numeric(line_length) == FALSE || line_length %% 1 != 0 || line_length < 1 ||
        is.numeric(spacing) == FALSE     || spacing %% 1 != 0     || spacing < 0) {
        abort("Line length must be a positive integer and spacing must be a non-negative integer.", class = "argument_value_or_type")
    }
    if (is.character(input_seq) == FALSE) {
        abort("Input sequence must be a character/string.", class = "argument_value_or_type")
    }
    if (is.logical(spaces_first) == FALSE) {
        abort("Spaces on top setting must be a logical/boolean value.", class = "argument_value_or_type")
    }

    sequences <- NULL
    full_rows <- nchar(input_seq) %/% line_length
    remainder <- nchar(input_seq) %% line_length
    if (full_rows > 0) {
        for (i in 1:full_rows) {
            start <- (i-1)*line_length + 1
            stop  <- i*line_length
            line <- substr(input_seq, start, stop)
            if (spaces_first == TRUE) {
                sequences <- c(sequences, rep("", spacing), line)
            } else if (spaces_first == FALSE) {
                sequences <- c(sequences, line, rep("", spacing))
            } else {
                abort("spaces_first must be a logical value.", class = "argument_value_or_type")
            }
        }
    }
    if (remainder > 0) {
        start <- full_rows*line_length + 1
        stop  <- nchar(input_seq)
        line <- substr(input_seq, start, stop)
        if (spaces_first == TRUE) {
            sequences <- c(sequences, rep("", spacing), line)
        } else if (spaces_first == FALSE) {
            sequences <- c(sequences, line, rep("", spacing))
        } else {
            abort("spaces_first must be a logical value.", class = "argument_value_or_type")
        }
    }
    return(sequences)
}



#' Convert a vector of sequences to a dataframe for plotting sequence contents and index annotations ([visualise_single_sequence()] helper)
#'
#' Takes the sequence list output from [convert_input_seq_to_sequence_list()] and creates a dataframe
#' specifying x and y coordinates and the character to plot at each coordinate. This applies to both
#' the sequence itself (e.g. determining where on the plot to place an `"A"`) and the periodicit
#' annotations of index number (e.g. determining where on the plot to annotate base number `15`).
#'
#' @param sequences `character vector`. Sequence to be plotted, split into lines and optionally including blank spacer lines. Output of [convert_input_seq_to_sequence_list()].
#' @param line_length `integer`. How long each line should be.
#' @param interval `integer`. How frequently bases should be annotated with their index. Defaults to `15`.
#' @param annotations_above `logical`. Whether annotations should go above (`TRUE`, default) or below (`FALSE`) each line of sequence.
#' @param annotation_vertical_position `numeric`. How far annotation numbers should be rendered above (if `index_annotations_above = TRUE`) or below (if `index_annotations_above = FALSE`) each base. Defaults to `1/3`. Not recommended to change at all. Strongly discouraged to set below 0 or above 1.
#'
#' @return `dataframe` Dataframe of coordinates and labels (e.g. `"A"` or `"15`), readable by geom_text.
#'
#' @examples
#' convert_sequences_to_annotations(
#'     c("GGCGGC", "", "ATCG", ""),
#'     line_length = 6,
#'     interval = 3,
#'     annotations_above = TRUE,
#'     annotation_vertical_position = 1/3
#' )
#'
#' convert_sequences_to_annotations(
#'     c("GGCGGC", "", "ATCG", ""),
#'     line_length = 6,
#'     interval = 0
#')
#'
#' @export
convert_sequences_to_annotations <- function(sequences, line_length, interval = 15, annotations_above = TRUE, annotation_vertical_position = 1/3) {
    for (argument in list(sequences, line_length, interval, annotations_above, annotation_vertical_position)) {
        if (mean(is.null(argument)) != 0 || mean(is.na(argument)) != 0) {abort(paste("Argument", argument, "must not be null or NA."), class = "argument_value_or_type")}
    }
    if (is.numeric(line_length) == FALSE || length(line_length) != 1 || line_length %% 1 != 0 || line_length < 1 ||
        is.numeric(interval) == FALSE    || length(interval) != 1    || interval %% 1 != 0    || interval < 0) {
        abort("Line length must be a positive integer and annotation interval must be a single non-negative integer", class = "argument_value_or_type")
    }
    if (is.logical(annotations_above) == FALSE || length(annotations_above) != 1) {
        abort("annotations_above must be a single logical/boolean value.", class = "argument_value_or_type")
    }
    if (is.numeric(annotation_vertical_position) == FALSE || length(annotation_vertical_position) != 1) {
        abort("Annotation vertical position must be a single numeric value", class = "argument_value_or_type")
    }
    if (annotation_vertical_position < 0 || annotation_vertical_position > 1) {
        warn("Not recommended to set index annotation vertical position outside range 0-1\n(though if spacing is much higher than 1, it is possible that values >1 might be acceptable).", class = "parameter_recommendation")
    }
    if (is.character(sequences) == FALSE) {
        abort("Input sequence must be a character vector.", class = "argument_value_or_type")
    }

    x_interval <- 1 / line_length
    y_interval <- 1 / length(sequences)

    annotation_data <- data.frame(NULL)

    i_values_to_ignore <- 0
    for (i in 1:length(sequences)) {
        ## Don't count blank/spacer rows when adding up numbers
        if (sequences[i] == "") {
            i_values_to_ignore <- i_values_to_ignore + 1
        }

        if (sequences[i] != "") {
            for (j in 1:nchar(sequences[i])) {
                ## Annotate actual sequence
                x_position <- x_interval * (j - 1/2)
                y_position <- 1 - y_interval * (i - 1/2)
                annotation <- substr(sequences[i], j, j)
                type <- "Sequence"
                annotation_data <- rbind(annotation_data, c(x_position, y_position, annotation, type))

                ## Annotate numbers every <interval> bases
                if (interval != 0 && j %% interval == 0) {
                    x_position <- x_interval * (j - 1/2)

                    if (annotations_above == TRUE) {
                        y_position <- 1 - y_interval * (i - 1 - annotation_vertical_position)
                    } else if (annotations_above == FALSE) {
                        y_position <- 1 - y_interval * (i + annotation_vertical_position)
                    } else {
                        abort("spaces_first must be a logical value.", class = "argument_value_or_type")
                    }

                    annotation <- as.character((i-1-i_values_to_ignore)*line_length + j)
                    type <- "Number"
                    annotation_data <- rbind(annotation_data, c(x_position, y_position, annotation, type))
                }
            }
        }
    }
    colnames(annotation_data) <- c("x_position", "y_position", "annotation", "type")
    annotation_data$x_position <- as.numeric(annotation_data$x_position)
    annotation_data$y_position <- as.numeric(annotation_data$y_position)
    return(annotation_data)
}
