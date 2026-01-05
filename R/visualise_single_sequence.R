#' Visualise a single DNA/RNA sequence
#'
#' @aliases visualize_single_sequence
#'
#' @description
#' `visualize_single_sequence()` is an alias for `visualise_single_sequence()` - see [aliases].
#'
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
#'     index_annotation_always_first_base = FALSE,
#'     index_annotation_always_last_base = FALSE,
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
    index_annotation_always_first_base = TRUE,
    index_annotation_always_last_base = TRUE,
    outline_colour = "black",
    outline_linewidth = 3,
    outline_join = "mitre",
    return = TRUE,
    filename = NA,
    force_raster = FALSE,
    render_device = ragg::agg_png,
    pixels_per_base = 100,
    monitor_performance = FALSE,
    ...
) {
    ## Validate monitor_performance then store start time
    start_time <- monitor_start(monitor_performance, "visualise_single_sequence")

    ## Process aliases
    ## ---------------------------------------------------------------------
    monitor_time <- monitor(monitor_performance, start_time, start_time, "resolving aliases")
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
    index_annotation_always_first_base <- resolve_alias("index_annotation_always_first_base", index_annotation_always_first_base, "index_annotations_always_first_base", dots[["index_annotations_always_first_base"]], TRUE)
    index_annotation_always_last_base <- resolve_alias("index_annotation_always_last_base", index_annotation_always_last_base, "index_annotations_always_last_base", dots[["index_annotations_always_last_base"]], TRUE)
    ## ---------------------------------------------------------------------



    ## Validate arguments
    ## ---------------------------------------------------------------------
    monitor_time <- monitor(monitor_performance, start_time, monitor_time, "validating arguments")
    not_null <- list(sequence = sequence, sequence_colours = sequence_colours, background_colour = background_colour, line_wrapping = line_wrapping, spacing = spacing, margin = margin, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, index_annotation_always_first_base = index_annotation_always_first_base, index_annotation_always_last_base = index_annotation_always_last_base, outline_colour = outline_colour, outline_linewidth = outline_linewidth, outline_join = outline_join, return = return, force_raster = force_raster, filename = filename, pixels_per_base = pixels_per_base)
    for (argument in names(not_null)) {
        if (any(is.null(not_null[[argument]]))) {bad_arg(argument, not_null, "must not be NULL.")}
    }
    not_null <- NULL

    length_1 <- list(sequence = sequence, background_colour = background_colour, outline_colour = outline_colour, line_wrapping = line_wrapping, spacing = spacing, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, index_annotation_always_first_base = index_annotation_always_first_base, index_annotation_always_last_base = index_annotation_always_last_base, outline_colour = outline_colour, outline_linewidth = outline_linewidth, outline_join = outline_join, return = return, filename = filename, force_raster = force_raster, pixels_per_base = pixels_per_base, margin = margin)
    for (argument in names(length_1)) {
        if (length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }
    length_1 <- NULL

    not_na <- list(sequence = sequence, sequence_colours = sequence_colours, background_colour = background_colour, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, index_annotation_always_first_base = index_annotation_always_first_base, index_annotation_always_last_base = index_annotation_always_last_base, line_wrapping = line_wrapping, spacing = spacing, outline_colour = outline_colour, outline_linewidth = outline_linewidth, outline_join = outline_join, return = return, force_raster = force_raster, pixels_per_base = pixels_per_base, margin = margin)
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

    bool <- list(return = return, index_annotations_above = index_annotations_above, force_raster = force_raster, index_annotation_always_first_base = index_annotation_always_first_base, index_annotation_always_last_base = index_annotation_always_last_base)
    for (argument in names(bool)) {
        if (!is.logical(bool[[argument]])) {bad_arg(argument, bool, "must be a logical/boolean value.")}
    }
    bool <- NULL


    if (index_annotation_size == 0 && index_annotation_interval != 0) {
        cli_alert_info("Automatically setting index_annotation_interval to 0 as index_annotation_size is 0", class = "atypical_turn_off")
        index_annotation_interval <- 0
    }
    if (index_annotation_interval > min(nchar(sequence), line_wrapping) && !index_annotation_always_first_base) {
        cli_alert_info("Automatically disabling index annotations as index_annotation_interval is greater than the maximum line length")
        index_annotation_interval <- 0
    }

    ## If annotations are off, set vertical position to 0
    ## This helps with calculating margin later
    if (index_annotation_interval == 0) {
        index_annotation_vertical_position <- 0
    }

    if (spacing == 0 && index_annotation_interval != 0) {
        warn("Using spacing = 0 without disabling index annotation is not recommended.\nIt is likely to draw the annotations overlapping the sequence.\nRecommended to set index_annotation_interval = 0 to disable index annotations.", class = "parameter_recommendation")
    }
    if (index_annotation_interval == 0 && index_annotation_always_first_base) {
        warn("Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_first_base setting.\nIf you want the first base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.", class = "parameter_recommendation")
    }
    if (index_annotation_interval == 0 && index_annotation_always_last_base) {
        warn("Disabling index annotations via index_annotation_interval = 0 or index_annotation_size = 0 overrides the index_annotation_always_last_base setting.\nIf you want the last base in each line to be annotated but no other bases, set index_annotation_interval greater than line_wrapping.", class = "parameter_recommendation")
    }


    if (!(tolower(outline_join) %in% c("mitre", "round", "bevel"))) {
        bad_arg("outline_join", list(outline_join = outline_join), "must be one of 'mitre', 'round', or 'bevel'.")
    }

    ## Error out if sequence length is 0
    if (nchar(sequence) == 0) {
        bad_arg("sequence", list(sequence = sequence), "must contain at least 1 base.")
    }

    ## Warn about outlines getting cut off
    if (margin <= 0.25 && outline_linewidth > 0) {
        warn(paste("If margin is small and outlines are on (outline_linewidth > 0), outlines may be cut off at the edges of the plot. Check if this is happening and consider using a bigger margin.\nCurrent margin:", margin), class = "parameter_recommendation")
    }
    ## Accept NA as NULL for render_device
    if (is.atomic(render_device) && any(is.na(render_device))) {render_device <- NULL}

    ## Strip whitespace from sequence
    sequence <- gsub("\\s+", "", sequence)
    ## ---------------------------------------------------------------------



    ## Generate data for plotting
    monitor_time <- monitor(monitor_performance, start_time, monitor_time, "splitting input seq to sequence vector")
    starts <- seq(1, nchar(sequence), line_wrapping)
    ends   <- seq(line_wrapping, nchar(sequence) + line_wrapping - 1, line_wrapping)
    split_sequences <- substring(sequence, starts, ends)

    ## Check if last line should be annotated or not
    extra_spaces_start <- 0
    extra_spaces_end   <- 0
    offset_start <- 0
    offset_end   <- 0
    if (nchar(tail(split_sequences, 1)) >= index_annotation_interval || index_annotation_always_first_base || index_annotation_always_last_base) {
        index_annotation_lines <- seq_along(split_sequences)
        annotation_lines_trimmed <- FALSE
    } else {
        index_annotation_lines <- head(seq_along(split_sequences), -1)
        annotation_lines_trimmed <- TRUE
    }

    ## But, if annotations are above, we need to insert the spacers for the last line anyway
    ## So override the previous setting and use 1:length anyway
    ## Use special case when spacing is 0 and index annotations are on to insert one line if needed
    if (index_annotations_above) {
        if (spacing > 0 || index_annotation_interval == 0) {
            sequences <- insert_at_indices(split_sequences, seq_along(split_sequences), index_annotations_above, insert = "", vert = spacing)
            extra_spaces_start <- extra_spaces_start + spacing
        } else {
            sequences <- insert_at_indices(split_sequences, 1, index_annotations_above, insert = "", vert = index_annotation_vertical_position)
            extra_spaces_start <- extra_spaces_start + ceiling(index_annotation_vertical_position)
            offset_start <- ceiling(index_annotation_vertical_position)
            index_annotation_lines <- seq_along(split_sequences) + offset_start
        }
    } else {
        if (spacing > 0 || index_annotation_interval == 0 || annotation_lines_trimmed) {
            sequences <- insert_at_indices(split_sequences, index_annotation_lines, index_annotations_above, insert = "", vert = spacing)
            if (!annotation_lines_trimmed) {
                extra_spaces_end <- extra_spaces_end + spacing
            }
        } else {
            sequences <- insert_at_indices(split_sequences, length(split_sequences), index_annotations_above, insert = "", vert = index_annotation_vertical_position)
            if (!annotation_lines_trimmed) {
                extra_spaces_end <- extra_spaces_end + ceiling(index_annotation_vertical_position)
                offset_end <- ceiling(index_annotation_vertical_position)
            }
        }
    }

    if (spacing > ceiling(index_annotation_vertical_position)) {
        if (index_annotations_above) {
            offset_start <- spacing - ceiling(index_annotation_vertical_position)
            sequences <- sequences[(offset_start+1):length(sequences)]
            extra_spaces_start <- extra_spaces_start - offset_start

        ## Remove extra lines at end, but if the last line isn't annotated then there's nothing to remove
        } else if (!annotation_lines_trimmed) {
            offset_end <- spacing - ceiling(index_annotation_vertical_position)
            sequences <- sequences[1:(length(sequences)-offset_end)]
            extra_spaces_end <- extra_spaces_end - offset_end
        }
    }


    # Finish generating data for plotting
    if (max(nchar(sequences)) < line_wrapping) {line_wrapping <- max(nchar(sequences))}
    monitor_time <- monitor(monitor_performance, start_time, monitor_time, "rasterising image data")
    image_data <- create_image_data(sequences)


    ## Name the sequence colours vector
    names(sequence_colours) <- as.character(1:4)


    ## Determine whether to use geom_raster as a faster but more limited alternative to geom_tile
    monitor_time <- monitor(monitor_performance, start_time, monitor_time, "choosing rendering method")
    raster <- FALSE
    if (sequence_text_size == 0 && index_annotation_interval == 0 && outline_linewidth == 0) {
        cli_alert_info("Automatically using geom_raster (much faster than geom_tile) as no sequence text, index annotations, or outlines are present.")
        raster <- TRUE
    } else if (force_raster) {
        warn("Forcing geom_raster via force_raster = TRUE will remove all sequence text, index annotations (though any inserted blank lines/spacers will remain), and box outlines.", class = "raster_is_forced")
        raster <- TRUE
        sequence_text_size <- 0
        index_annotation_interval <- 0
        index_annotation_vertical_position <- 0
        outline_linewidth = 0
    }

    ## Make actual plot
    ## Fast rasterisation if possible
    if (raster) {
        if (pixels_per_base > 20) {
            warn(paste("When using geom_raster, it is recommended to use a smaller pixels_per_base e.g. 10, as there is no text/outlines that would benefit from higher resolution.\nCurrent value:", pixels_per_base), class = "parameter_recommendation")
        }

        monitor_time <- monitor(monitor_performance, start_time, monitor_time, "creating basic plot via geom_raster")
        result <- ggplot(image_data, aes(x = .data$x, y = .data$y, fill = as.character(.data$value))) +
            geom_raster() +
            scale_fill_manual(values = c("0" = background_colour, sequence_colours))


        ## Otherwise slow geom_tile
    } else {

        ## Calculate tile dimensions
        monitor_time <- monitor(monitor_performance, start_time, monitor_time, "calculating tile sizes")
        tile_width  <- 1/max(nchar(sequences))
        tile_height <- 1/length(sequences)

        ## Generate plot
        monitor_time <- monitor(monitor_performance, start_time, monitor_time, "creating basic plot via geom_tile")
        result <- ggplot(image_data, aes(x = .data$x, y = .data$y)) +
            ## Background
            geom_tile(data = filter(image_data, .data$value == 0), width = tile_width, height = tile_height, fill = background_colour) +

            ## Base boxes
            geom_tile(data = filter(image_data, .data$value != 0), width = tile_width, height = tile_height, aes(fill = as.character(.data$value)),
                      col = outline_colour, linewidth = outline_linewidth, linejoin = tolower(outline_join)) +
            scale_fill_manual(values = sequence_colours)


        ## Add sequence text if desired
        if (sequence_text_size > 0) {
            monitor_time <- monitor(monitor_performance, start_time, monitor_time, "generating sequence text")
            sequence_text_matrix <- convert_sequences_to_matrix(sequences, line_wrapping)
            sequence_text_data <- rasterise_matrix(sequence_text_matrix)

            monitor_time <- monitor(monitor_performance, start_time, monitor_time, "adding sequence text")
            result <- result +
                geom_text(data = sequence_text_data, aes(x = .data$x, y = .data$y, label = .data$value), col = sequence_text_colour, size = sequence_text_size, fontface = "bold", inherit.aes = F)
        }

        ## Add index annotations if desired
        if (index_annotation_interval > 0) {
            monitor_time <- monitor(monitor_performance, start_time, monitor_time, "generating index annotations")
            index_annotation_data <- rasterise_index_annotations(new_sequences_vector = sequences, original_sequences_vector = split_sequences, index_annotation_lines = index_annotation_lines, index_annotation_interval = index_annotation_interval, index_annotation_full_line = FALSE, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, index_annotation_always_first_base = index_annotation_always_first_base, index_annotation_always_last_base = index_annotation_always_last_base, sum_indices = TRUE, spacing = spacing, offset_start = offset_start)

            monitor_time <- monitor(monitor_performance, start_time, monitor_time, "adding index annotations")
            result <- result +
                geom_text(data = index_annotation_data, aes(x = .data$x, y = .data$y, label = .data$value), col = index_annotation_colour, size = index_annotation_size, fontface = "bold", inherit.aes = F)
        }
    }

    ## Do general plot setup
    monitor_time <- monitor(monitor_performance, start_time, monitor_time, "adding general plot themes")
    result <- result +
        coord_cartesian(expand = FALSE, clip = "off") +
        guides(x = "none", y = "none", fill = "none", col = "none", size = "none") +
        theme_void() +
        theme(plot.background = element_rect(fill = background_colour, colour = NA),
              axis.title = element_blank())

    ## Calculate margins
    ## single_sequence just keeps a tally of when lines at the top and bottom are removed so this is easy
    monitor_time <- monitor(monitor_performance, start_time, monitor_time, "calculating margin")
    result <- result + theme(plot.margin = grid::unit(c(max(margin-extra_spaces_start, 0), margin, max(margin-extra_spaces_end, 0), margin), "inches"))
    extra_height <- max(margin-extra_spaces_start, 0) + max(margin-extra_spaces_end, 0)

    ## Check if filename is set and warn if not png, then export image
    if (is.na(filename) == FALSE) {
        monitor_time <- monitor(monitor_performance, start_time, monitor_time, "exporting image file")
        if (is.character(filename) == FALSE) {
            abort("Filename must be a character/string (or NA if no file export wanted)", class = "argument_value_or_type")
        }
        if (tolower(substr(filename, nchar(filename)-3, nchar(filename))) != ".png") {
            warn("Not recommended to use non-png filetype (but may still work).", class = "filetype_recommendation")
        }
        ggsave(filename, plot = result, dpi = pixels_per_base, device = render_device, width = max(nchar(sequences))+(2*margin), height = length(sequences)+extra_height, limitsize = FALSE)
    }

    ## Return either the plot object or NULL
    monitor_time <- monitor(monitor_performance, start_time, monitor_time, "done")
    if (return == TRUE) {
        return(result)
    }
    return(invisible(NULL))
}

## Define alias
#' @rdname visualise_single_sequence
#' @usage NULL
#' @export
visualize_single_sequence <- visualise_single_sequence

