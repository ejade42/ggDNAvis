#' Visualise a single DNA/RNA sequence
#'
#' `visualize_single_sequence()` is an alias for `visualise_single_sequence()` - see [aliases].\cr\cr
#' This function takes a DNA/RNA sequence and returns a ggplot
#' visualising it, with the option to directly export a png image
#' with appropriate dimensions. Colours, line wrapping, index annotation
#' interval, and pixels per square when exported are configurable.
#'
#' @param sequence `character`. A DNA or RNA sequence to visualise e.g. `"AAATGCTGC"`.
#' @param line_wrapping `integer`. The number of bases that should be on each line before wrapping. Defaults to `75`. Recommended to make this a multiple of the repeat unit size (e.g. 3*n* for a trinucleotide repeat) if visualising a repeat sequence.
#' @param spacing `integer`. The number of blank lines between each line of sequence. Defaults to `1`.\cr\cr Be careful when setting to `0` as this means annotations have no space so might render strangely. Recommended to set `index_annotation_interval = 0` if doing so to disable annotations entirely.
#' @param index_annotation_interval `integer`. The frequency at which numbers should be placed underneath indicating base index, starting counting from the leftmost base in each row. Defaults to `15` (every 15 bases along each row).\cr\cr Recommended to make this a factor/divisor of the line wrapping length (meaning the final base in each line is annotated), otherwise the numbering interval resetting at the beginning of each row will result in uneven intervals at each line break.\cr\cr Setting to `0` disables index annotations (and prevents adding additional blank lines).
#'
#' @inheritParams visualise_many_sequences
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
visualise_single_sequence <- function(
    sequence,
    sequence_colours = sequence_colour_palettes$ggplot_style,
    background_colour = "white",
    line_wrapping = 75,
    spacing = 1,
    margin = 0.5,
    sequence_text_colour = "black",
    sequence_text_size = 16,
    index_annotation_colour = "darkred",
    index_annotation_size = 12.5,
    index_annotation_interval = 15,
    index_annotations_above = TRUE,
    index_annotation_vertical_position = 1/3,
    outline_colour = "black",
    outline_linewidth = 3,
    outline_join = "mitre",
    return = TRUE,
    filename = NA,
    render_device = ragg::agg_png,
    pixels_per_base = 100,
    ...
) {
    ## Process aliases
    ## ---------------------------------------------------------------------
    dots <- list(...)
    sequence_colours <- resolve_alias("sequence_colours", sequence_colours, "sequence_colors", dots[["sequence_colors"]], sequence_colour_palettes$ggplot_style)
    sequence_colours <- resolve_alias("sequence_colours", sequence_colours, "sequence_cols", dots[["sequence_cols"]], sequence_colour_palettes$ggplot_style)
    background_colour <- resolve_alias("background_colour", background_colour, "background_color", dots[["background_color"]], "white")
    background_colour <- resolve_alias("background_colour", background_colour, "background_col", dots[["background_col"]], "white")
    sequence_text_colour <- resolve_alias("sequence_text_colour", sequence_text_colour, "sequence_text_color", dots[["sequence_text_color"]], "black")
    sequence_text_colour <- resolve_alias("sequence_text_colour", sequence_text_colour, "sequence_text_col", dots[["sequence_text_col"]], "black")
    index_annotation_colour <- resolve_alias("index_annotation_colour", index_annotation_colour, "index_annotation_color", dots[["index_annotation_color"]], "darkred")
    index_annotation_colour <- resolve_alias("index_annotation_colour", index_annotation_colour, "index_annotation_col", dots[["index_annotation_col"]], "darkred")
    outline_colour <- resolve_alias("outline_colour", outline_colour, "outline_color", dots[["outline_color"]], "black")
    outline_colour <- resolve_alias("outline_colour", outline_colour, "outline_col", dots[["outline_col"]], "black")
    index_annotations_above <- resolve_alias("index_annotations_above", index_annotations_above, "index_annotation_above", dots[["index_annotation_above"]], TRUE)
    ## ---------------------------------------------------------------------



    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_null <- list(sequence = sequence, sequence_colours = sequence_colours, background_colour = background_colour, line_wrapping = line_wrapping, spacing = spacing, margin = margin, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, outline_colour = outline_colour, outline_linewidth = outline_linewidth, outline_join = outline_join, return = return, filename = filename, pixels_per_base = pixels_per_base)
    for (argument in names(not_null)) {
        if (any(is.null(not_null[[argument]]))) {bad_arg(argument, not_null, "must not be NULL.")}
    }
    not_null <- NULL

    length_1 <- list(sequence = sequence, background_colour = background_colour, outline_colour = outline_colour, line_wrapping = line_wrapping, spacing = spacing, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, outline_colour = outline_colour, outline_linewidth = outline_linewidth, outline_join = outline_join, return = return, filename = filename, pixels_per_base = pixels_per_base, margin = margin)
    for (argument in names(length_1)) {
        if (length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }
    length_1 <- NULL

    not_na <- list(sequence = sequence, sequence_colours = sequence_colours, background_colour = background_colour, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, line_wrapping = line_wrapping, spacing = spacing, outline_colour = outline_colour, outline_linewidth = outline_linewidth, outline_join = outline_join, return = return, pixels_per_base = pixels_per_base, margin = margin)
    for (argument in names(not_na)) {
        if (any(is.na(not_na[[argument]]))) {bad_arg(argument, not_na, "must not be NA.")}
    }
    not_na <- NULL

    if (!is.character(sequence_colours) || length(sequence_colours) != 4) {
        bad_arg("sequence_colours", list(sequence_colours = sequence_colours), "must provide exactly 4 sequence colours, in A C G T order, as a length-4 character vector.")
    }

    char <- list(sequence = sequence, background_colour = background_colour, sequence_text_colour = sequence_text_colour, index_annotation_colour = index_annotation_colour, outline_colour = outline_colour, outline_join = outline_join)
    for (argument in names(char)) {
        if (!is.character(char[[argument]])) {bad_arg(argument, char, "must be a character/string value.")}
    }
    char <- NULL

    nums <- list(index_annotation_vertical_position = index_annotation_vertical_position)
    for (argument in names(nums)) {
        if (!is.numeric(nums[[argument]])) {bad_arg(argument, nums, "must be numeric.")}
    }
    nums <- NULL

    if (index_annotation_vertical_position < 0 || index_annotation_vertical_position > 1) {
        warn(paste("Not recommended to set index_annotation_vertical_position outside range 0-1.\nCurrent value:", index_annotation_vertical_position), class = "parameter_recommendation")
    }

    non_neg_num <- list(sequence_text_size = sequence_text_size, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, spacing = spacing, pixels_per_base = pixels_per_base, line_wrapping = line_wrapping, margin = margin, outline_linewidth = outline_linewidth)
    for (argument in names(non_neg_num)) {
        if (!is.numeric(non_neg_num[[argument]]) || any(non_neg_num[[argument]] < 0)) {bad_arg(argument, non_neg_num, "must be a non-negative number.")}
    }
    non_neg_num <- NULL

    ints <- list(line_wrapping = line_wrapping, spacing = spacing, pixels_per_base = pixels_per_base, index_annotation_interval = index_annotation_interval)
    for (argument in names(ints)) {
        if (any(ints[[argument]] %% 1 != 0)) {bad_arg(argument, ints, "must be an integer.")}
    }
    ints <- NULL

    ge_1 <- list(line_wrapping = line_wrapping, pixels_per_base = pixels_per_base)
    for (argument in names(ge_1)) {
        if (any(ge_1[[argument]] < 1)) {bad_arg(argument, ge_1, "must be at least 1.")}
    }
    ge_1 <- NULL

    bool <- list(return = return, index_annotations_above = index_annotations_above)
    for (argument in names(bool)) {
        if (!is.logical(bool[[argument]])) {bad_arg(argument, bool, "must be a logical/boolean value.")}
    }
    bool <- NULL


    if (index_annotation_size == 0 && index_annotation_interval != 0) {
        cli_alert_info("Automatically setting index_annotation_interval to 0 as index_annotation_size is 0", class = "atypical_turn_off")
        index_annotation_interval <- 0
    }
    if (spacing == 0 && index_annotation_interval != 0) {
        warn("Using spacing = 0 without disabling index annotation is not recommended.\nIt is likely to draw the annotations overlapping the sequence.\nRecommended to set index_annotation_interval = 0 to disable index annotations.", class = "parameter_recommendation")
    }
    if (!(tolower(outline_join) %in% c("mitre", "round", "bevel"))) {
        bad_arg("outline_join", list(outline_join = outline_join), "must be one of 'mitre', 'round', or 'bevel'.")
    }

    ## Warn about outlines getting cut off
    if (margin <= 0.25 && outline_linewidth > 0) {
        warn(paste("If margin is small and outlines are on (outline_linewidth > 0), outlines may be cut off at the edges of the plot. Check if this is happening and consider using a bigger margin.\nCurrent margin:", margin), class = "parameter_recommendation")
    }
    ## Accept NA as NULL for render_device
    if (is.atomic(render_device) && any(is.na(render_device))) {render_device <- NULL}
    ## ---------------------------------------------------------------------



    ## Generate data for plotting
    sequences <- convert_input_seq_to_sequence_list(sequence, line_wrapping, spacing, FALSE, FALSE)

    ## Add extra top/bottom blank lines if needed for index annotations
    extra_spaces <- 0
    if (index_annotation_interval != 0) {
        extra_spaces <- ceiling(index_annotation_vertical_position)
        if (index_annotations_above) {
            sequences <- c(rep("", extra_spaces), sequences)
        } else {
            sequences <- c(sequences, rep("", extra_spaces))
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
        theme_void() +
        theme(axis.title = element_blank(),
              plot.background = element_rect(fill = background_colour, colour = NA))


    ## As long as the lines are spaced out, don't need a bottom margin as the blank spacer line does that
    ## But if spacing is turned off, need to add a bottom margin
    if (extra_spaces == 0) {
        result <- result + theme(plot.margin = grid::unit(c(margin, margin, margin, margin), "inches"))
        extra_height <- 2 * margin
    } else if (index_annotations_above == TRUE) {
        result <- result + theme(plot.margin = grid::unit(c(max(margin-extra_spaces, 0), margin, margin, margin), "inches"))
        extra_height <- margin + max(margin-extra_spaces, 0)
    } else if (index_annotations_above == FALSE) {
        result <- result + theme(plot.margin = grid::unit(c(margin, margin, max(margin-extra_spaces, 0), margin), "inches"))
        extra_height <- margin + max(margin-extra_spaces, 0)
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



#' Split a single input sequence into a vector of "lines" for visualisation ([visualise_single_sequence()] helper)
#'
#' Takes a single input sequence and an integer line length, and splits the input
#' sequence into lines of that length (with the last line potentially being shorter). \cr\cr
#' Optionally inserts empty strings `""` after each line to space them out.
#'
#' @param input_seq `character`. A DNA/RNA sequence (or for the purposes of this function, any string, though only DNA/RNA will work with later functions) to be split up.
#' @param line_length `integer`. How long each line (split-up section) should be.
#' @param spacing `integer`. How many blank lines to leave before/after each line of sequence. Defaults to `0`.
#' @param start_spaces `logical`. Whether blank lines should also be present before the first line of sequence. Defaults to `FALSE`.
#' @param end_spaces `logical`. Whether blank lines should also be present after the last line of sequence. Defaults to `FALSE`.
#'
#' @return `character vector`. The input sequence split into multiple lines, with specified spacing in between.
#'
#' @examples
#' convert_input_seq_to_sequence_list(
#'     "GGCGGCGGC",
#'     line_length = 6,
#'     spacing = 1,
#'     start_spaces = TRUE,
#'     end_spaces = TRUE
#' )
#'
#' convert_input_seq_to_sequence_list(
#'     "GGCGGCGGC",
#'     line_length = 3,
#'     spacing = 2
#' )
#'
#' convert_input_seq_to_sequence_list(
#'     "GGCGGCGGC",
#'     line_length = 3,
#'     spacing = 2,
#'     end_spaces = TRUE
#' )
#'
#' convert_input_seq_to_sequence_list(
#'     "GGCGGCGGC",
#'     line_length = 6,
#'     spacing = 0,
#'     start_spaces = TRUE,
#'     end_spaces = FALSE
#' )
#'
#' @export
convert_input_seq_to_sequence_list <- function(
    input_seq,
    line_length,
    spacing = 1,
    start_spaces = FALSE,
    end_spaces = FALSE
) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_null_or_na <- list(input_seq = input_seq, line_length = line_length, spacing = spacing, start_spaces = start_spaces, end_spaces = end_spaces)
    for (argument in names(not_null_or_na)) {
        if (any(is.null(not_null_or_na[[argument]])) || any(is.na(not_null_or_na[[argument]]))) {bad_arg(argument, not_null_or_na, "must not be NA or NULL.")}
    }
    not_null_or_na <- NULL

    length_1 <- list(input_seq = input_seq, line_length = line_length, spacing = spacing, start_spaces = start_spaces, end_spaces = end_spaces)
    for (argument in names(length_1)) {
        if (length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }
    length_1 <- NULL

    non_neg_int <- list(spacing = spacing)
    for (argument in names(non_neg_int)) {
        if (!is.numeric(non_neg_int[[argument]]) || any(non_neg_int[[argument]] %% 1 != 0) || any(non_neg_int[[argument]] < 0)) {bad_arg(argument, non_neg_int, "must be a non-negative integer.")}
    }
    non_neg_int <- NULL

    pos_int <- list(line_length = line_length)
    for (argument in names(pos_int)) {
        if (!is.numeric(pos_int[[argument]]) || any(pos_int[[argument]] %% 1 != 0) || any(pos_int[[argument]] < 1)) {bad_arg(argument, pos_int, "must be a positive integer.")}
    }
    pos_int <- NULL

    char <- list(input_seq = input_seq)
    for (argument in names(char)) {
        if (!is.character(char[[argument]])) {bad_arg(argument, char, "must be a character/string.")}
    }
    char <- NULL

    bool <- list(start_spaces = start_spaces, end_spaces = end_spaces)
    for (argument in names(bool)) {
        if (!is.logical(bool[[argument]])) {bad_arg(argument, bool, "must be a logical/boolean value.")}
    }
    bool <- NULL
    ## ---------------------------------------------------------------------



    ## Split sequences into a vector, without breaks
    starts <- seq(1, nchar(input_seq), line_length)
    ends   <- seq(line_length, nchar(input_seq) + line_length - 1, line_length)
    split_sequences <- substring(input_seq, starts, ends)

    interleaved_sequences <- as.vector(
        ## rbind creates matrix
        rbind(split_sequences, matrix("", nrow = spacing, ncol = length(split_sequences)))
    )
    if (start_spaces) {
        interleaved_sequences <- c(rep("", spacing), interleaved_sequences)
    }
    if (!end_spaces) {
        interleaved_sequences <- interleaved_sequences[1:(length(interleaved_sequences) - spacing)]
    }

    return(interleaved_sequences)
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
convert_sequences_to_annotations <- function(
    sequences,
    line_length,
    interval = 15,
    annotations_above = TRUE,
    annotation_vertical_position = 1/3
) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_null_or_na <- list(sequences = sequences, line_length = line_length, interval = interval, annotations_above = annotations_above, annotation_vertical_position = annotation_vertical_position)
    for (argument in names(not_null_or_na)) {
        if (any(is.null(not_null_or_na[[argument]])) || any(is.na(not_null_or_na[[argument]]))) {bad_arg(argument, not_null_or_na, "must not be NULL or NA.")}
    }
    not_null_or_na <- NULL

    length_1 <- list(line_length = line_length, interval = interval, annotations_above = annotations_above, annotation_vertical_position = annotation_vertical_position)
    for (argument in names(length_1)) {
        if (length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }
    length_1 <- NULL

    non_neg_int <- list(interval = interval)
    for (argument in names(non_neg_int)) {
        if (!is.numeric(non_neg_int[[argument]]) || any(non_neg_int[[argument]] %% 1 != 0) || any(non_neg_int[[argument]] < 0)) {bad_arg(argument, non_neg_int, "must be a non-negative integer.")}
    }
    non_neg_int <- NULL

    pos_int <- list(line_length = line_length)
    for (argument in names(pos_int)) {
        if (!is.numeric(pos_int[[argument]]) || any(pos_int[[argument]] %% 1 != 0) || any(pos_int[[argument]] < 1)) {bad_arg(argument, pos_int, "must be a positive integer.")}
    }
    pos_int <- NULL

    bool <- list(annotations_above = annotations_above)
    for (argument in names(bool)) {
        if (!is.logical(bool[[argument]])) {bad_arg(argument, bool, "must be a logical/boolean value.")}
    }
    bool <- NULL

    nums <- list(annotation_vertical_position = annotation_vertical_position)
    for (argument in names(nums)) {
        if (!is.numeric(nums[[argument]])) {bad_arg(argument, nums, "must be numeric.")}
    }
    nums <- NULL


    if (annotation_vertical_position < 0 || annotation_vertical_position > 1) {
        warn(paste("Not recommended to set index annotation vertical position outside range 0-1\n(though if spacing is much higher than 1, it is possible that values >1 might be acceptable).\nCurrent value:", annotation_vertical_position), class = "parameter_recommendation")
    }

    char <- list(sequences = sequences)
    for (argument in names(char)) {
        if (!is.character(char[[argument]])) {bad_arg(argument, char, "must be a character vector.")}
    }
    char <- NULL
    ## ---------------------------------------------------------------------

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


## Define alias
#' @rdname visualise_single_sequence
#' @usage NULL
#' @export
visualize_single_sequence <- visualise_single_sequence

