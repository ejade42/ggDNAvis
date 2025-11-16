#' Visualise many DNA/RNA sequences
#'
#' This function takes a vector of DNA/RNA sequences (each sequence can be
#' any length and they can be different lengths), and plots each sequence
#' as base-coloured squares along a single line. Setting `filename` allows direct
#' export of a png image with the correct dimensions to make every base a perfect
#' square. Empty strings (`""`) within the vector can be utilised as blank spacing
#' lines. Colours and pixels per square when exported are configurable.
#'
#' @param sequences_vector `character vector`. The sequences to visualise, often created from a dataframe via [extract_and_sort_sequences()]. E.g. `c("GGCGGC", "", "AGCTAGCTA")`.
#' @param sequence_colours `character vector`, length 4. A vector indicating which colours should be used for each base. In order: `c(A_colour, C_colour, G_colour, T/U_colour)`.\cr\cr Defaults to red, green, blue, purple in the default shades produced by ggplot with 4 colours, i.e. `c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF")`, accessed via [`sequence_colour_palettes`]`$ggplot_style`.
#' @param background_colour `character`. The colour of the background. Defaults to white.
#' @param margin `numeric`. The size of the margin relative to the size of each base square. Defaults to `0.5` (half the side length of each base square).\cr\cr Very small margins (\eqn{\le}0.25) may cause thick outlines to be cut off at the edges of the plot. Recommended to either use a wider margin or a smaller `outline_linewidth`.
#' @param sequence_text_colour `character`. The colour of the text within the bases (e.g. colour of "A" letter within boxes representing adenosine bases). Defaults to black.
#' @param sequence_text_size `numeric`. The size of the text within the bases (e.g. size of "A" letter within boxes representing adenosine bases). Defaults to `16`. Set to `0` to hide sequence text (show box colours only).
#' @param index_annotation_lines `integer vector`. The lines (i.e. elements of `sequences_vector`) that should have their base incides annotated. 1-indexed e.g. `c(1, 10)` would annotate the first and tenth elements of `sequences_vector`.\cr\cr Extra lines are inserted above or below (depending on `index_annotations_above`) the selected lines - note that the line numbers come from `sequences_vector`, so are unaffected by these insertions.\cr\cr Setting to `NA` disables index annotations (and prevents adding additional blank lines). Defaults to `c(1)` i.e. first sequence is annotated.
#' @param index_annotation_colour `character`. The colour of the little numbers underneath indicating base index (e.g. colour of "15" label under the 15th base). Defaults to dark red.
#' @param index_annotation_size `numeric`. The size of the little number underneath indicating base index (e.g. size of "15" label under the 15th base). Defaults to `12.5`.\cr\cr Setting to `0` disables index annotations (and prevents adding additional blank lines).
#' @param index_annotation_interval `integer`. The frequency at which numbers should be placed underneath indicating base index, starting counting from the leftmost base. Defaults to `15` (every 15 bases along each row).\cr\cr Setting to `0` disables index annotations (and prevents adding additional blank lines).
#' @param index_annotations_above `logical`. Whether index annotations should go above (`TRUE`, default) or below (`FALSE`) each line of sequence.
#' @param index_annotation_vertical_position `numeric`. How far annotation numbers should be rendered above (if `index_annotations_above = TRUE`) or below (if `index_annotations_above = FALSE`) each base. Defaults to `1/3`.\cr\cr Not recommended to change at all. Strongly discouraged to set below 0 or above 1.
#' @param index_annotation_full_line `logical`. Whether index annotations should continue to the end of the longest sequence (`TRUE`, default) or should only continue as far as each selected line does (`FALSE`).
#' @param outline_colour `character`. The colour of the box outlines. Defaults to black.
#' @param outline_linewidth `numeric`. The linewidth of the box outlines. Defaults to `3`. Set to `0` to disable box outlines.
#' @param outline_join `character`. One of `"mitre"`, `"round"`, or `"bevel"` specifying how outlines should be joined at the corners of boxes. Defaults to `"mitre"`. It would be unusual to need to change this.
#' @param return `logical`. Boolean specifying whether this function should return the ggplot object, otherwise it will return `invisible(NULL)`. Defaults to `TRUE`.
#' @param filename `character`. Filename to which output should be saved. If set to `NA` (default), no file will be saved. Recommended to end with `".png"`, but can change if render device is changed.
#' @param render_device `function/character`. Device to use when rendering. See [ggplot2::ggsave()] documentation for options. Defaults to [`ragg::agg_png`]. Can be set to `NULL` to infer from file extension, but results may vary between systems.
#' @param pixels_per_base `integer`. How large each box should be in pixels, if file output is turned on via setting `filename`. Corresponds to dpi of the exported image.\cr\cr If text is shown (i.e. `sequence_text_size` is not 0), needs to be fairly large otherwise text is blurry. Defaults to `100`.
#'
#' @return A ggplot object containing the full visualisation, or `invisible(NULL)` if `return = FALSE`. It is often more useful to use `filename = "myfilename.png"`, because then the visualisation is exported at the correct aspect ratio.
#'
#' @examples
#' \donttest{
#' ## Create sequences vector
#' sequences <- extract_and_sort_sequences(example_many_sequences)
#'
#' ## Visualise example_many_sequences with all defaults
#' ## This looks ugly because it isn't at the right scale/aspect ratio
#' visualise_many_sequences(sequences)
#'
#' ## Export with all defaults rather than returning
#' visualise_many_sequences(
#'     sequences,
#'     filename = "example_vms_01.png",
#'     return = FALSE
#' )
#' ## View exported image
#' image <- png::readPNG("example_vms_01.png")
#' unlink("example_vms_01.png")
#' grid::grid.newpage()
#' grid::grid.raster(image)
#'
#' ## Export while customising appearance
#' visualise_many_sequences(
#'     sequences,
#'     filename = "example_vms_02.png",
#'     return = FALSE,
#'     sequence_colours = sequence_colour_palettes$bright_pale,
#'     sequence_text_colour = "white",
#'     background_colour = "lightgrey",
#'     outline_linewidth = 0,
#'     margin = 0
#' )
#' ## View exported image
#' image <- png::readPNG("example_vms_02.png")
#' unlink("example_vms_02.png")
#' grid::grid.newpage()
#' grid::grid.raster(image)
#' }
#'
#' @export
visualise_many_sequences <- function(
    sequences_vector,
    sequence_colours = sequence_colour_palettes$ggplot_style,
    background_colour = "white",
    margin = 0.5,
    sequence_text_colour = "black",
    sequence_text_size = 16,
    index_annotation_lines = c(1),
    index_annotation_colour = "darkred",
    index_annotation_size = 12.5,
    index_annotation_interval = 15,
    index_annotations_above = TRUE,
    index_annotation_vertical_position = 1/3,
    index_annotation_full_line = TRUE,
    outline_colour = "black",
    outline_linewidth = 3,
    outline_join = "mitre",
    return = TRUE,
    filename = NA,
    render_device = ragg::agg_png,
    pixels_per_base = 100
) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_null <- list(sequences_vector = sequences_vector, sequence_colours = sequence_colours, background_colour = background_colour, margin = margin, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, index_annotation_full_line = index_annotation_full_line, outline_colour = outline_colour, outline_linewidth = outline_linewidth, outline_join = outline_join, return = return, filename = filename, pixels_per_base = pixels_per_base)
    for (argument in names(not_null)) {
        if (any(is.null(not_null[[argument]]))) {bad_arg(argument, not_null, "must not be NULL.")}
    }
    not_null <- NULL

    length_1 <- list(background_colour = background_colour, margin = margin, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, index_annotation_full_line = index_annotation_full_line, outline_colour = outline_colour, outline_linewidth = outline_linewidth, outline_join = outline_join, return = return, filename = filename, pixels_per_base = pixels_per_base)
    for (argument in names(length_1)) {
        if (length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }
    length_1 <- NULL

    not_na <- list(sequences_vector = sequences_vector, sequence_colours = sequence_colours, background_colour = background_colour, margin = margin, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, index_annotation_full_line = index_annotation_full_line, outline_colour = outline_colour, outline_linewidth = outline_linewidth, outline_join = outline_join, return = return, pixels_per_base = pixels_per_base)
    for (argument in names(not_na)) {
        if (any(is.na(not_na[[argument]]))) {bad_arg(argument, not_na, "must not be NA.")}
    }
    not_na <- NULL

    ## Interpret NA/NULL/empty argument as not wanting any annotations
    if (any(is.na(index_annotation_lines)) || any(is.null(index_annotation_lines)) || length(index_annotation_lines) == 0) {
        index_annotation_lines <- integer(0)
    }

    if (!is.character(sequence_colours) || length(sequence_colours) != 4) {
        bad_arg("sequence_colours", list(sequence_colours = sequence_colours), "must provide exactly 4 sequence colours, in A C G T order, as a length-4 character vector.")
    }

    characters <- list(sequences_vector = sequences_vector, background_colour = background_colour, sequence_text_colour = sequence_text_colour, index_annotation_colour = index_annotation_colour, outline_colour = outline_colour, outline_join = outline_join)
    for (argument in names(characters)) {
        if (!is.character(characters[[argument]])) {bad_arg(argument, characters, "must be a character/string.")}
    }
    characters <- NULL

    non_neg_nums <- list(margin = margin, sequence_text_size = sequence_text_size, index_annotation_size = index_annotation_size, outline_linewidth = outline_linewidth, index_annotation_interval = index_annotation_interval, index_annotation_vertical_position = index_annotation_vertical_position, pixels_per_base = pixels_per_base)
    for (argument in names(non_neg_nums)) {
        if (!is.numeric(non_neg_nums[[argument]]) || any(non_neg_nums[[argument]] < 0)) {bad_arg(argument, non_neg_nums, "must be a non-negative number.")}
    }
    non_neg_nums <- NULL

    ints <- list(index_annotation_interval = index_annotation_interval, pixels_per_base = pixels_per_base)
    for (argument in names(ints)) {
        if (ints[[argument]] %% 1 != 0) {bad_arg(argument, ints, "must be an integer.")}
    }
    ints <- NULL

    pos <- list(pixels_per_base = pixels_per_base)
    for (argument in names(pos)) {
        if (any(pos[[argument]] <= 0)) {bad_arg(argument, pos, "must be positive.")}
    }
    pos <- NULL

    bools <- list(return = return, index_annotations_above = index_annotations_above, index_annotation_full_line = index_annotation_full_line)
    for (argument in names(bools)) {
        if (!is.logical(bools[[argument]])) {bad_arg(argument, bools, "must be logical/boolean.")}
    }
    bools <- NULL

    if (!(tolower(outline_join) %in% c("mitre", "round", "bevel"))) {
        bad_arg("outline_join", list(outline_join = outline_join), "must be one of 'mitre', 'round', or 'bevel'.")
    }

    if (length(index_annotation_lines) > 0 && (!is.numeric(index_annotation_lines) || any(index_annotation_lines %% 1 != 0) || any(index_annotation_lines <= 0))) {
        bad_arg("index_annotation_lines", list(index_annotation_lines = index_annotation_lines), "must be a vector of positive integers, or NA.")
    }

    ## Warn about outlines getting cut off
    if (margin <= 0.25 && outline_linewidth > 0) {
        warn("If margin is small and outlines are on (outline_linewidth > 0), outlines may be cut off at the edges of the plot. Check if this is happening and consider using a bigger margin.", class = "parameter_recommendation")
    }

    ## Accept NA as NULL for render_device
    if (is.atomic(render_device) && any(is.na(render_device))) {render_device <- NULL}


    ## Automatically turn off annotations if size or interval is set to 0.
    if (index_annotation_interval == 0 && length(index_annotation_lines) > 0 ) {
        cli_alert_info("Automatically emptying index_annotation_lines as index_annotation_interval is 0", class = "turn_off_annotations_by_other_argument")
        index_annotation_lines <- integer(0)
    } else if (index_annotation_size == 0 && length(index_annotation_lines) > 0 ) {
        cli_alert_info("Automatically emptying index_annotation_lines as index_annotation_size is 0", class = "turn_off_annotations_by_other_argument")
        index_annotation_lines <- integer(0)
    }

    ## Automatically sort and unique-ify index annotations lines
    sorted_index_annotation_lines <- sort(index_annotation_lines, na.last = TRUE)
    if (any(sorted_index_annotation_lines != index_annotation_lines)) {
        cli_alert_info(paste0("Automatically sorting index_annotation_lines.\nBefore: ", paste(index_annotation_lines, collapse = ", "), "\nAfter: ", paste(sorted_index_annotation_lines, collapse = ", ")), class = "sanitising_index_annotation_lines")
        index_annotation_lines <- sorted_index_annotation_lines
    }
    unique_index_annotation_lines <- unique(index_annotation_lines)
    if (length(unique_index_annotation_lines) != length(index_annotation_lines)) {
        cli_alert_info(paste0("Automatically making index_annotation_lines unique.\nBefore: ", paste(index_annotation_lines, collapse = ", "), "\nAfter: ", paste(unique_index_annotation_lines, collapse = ", ")), class = "sanitising_index_annotation_lines")
        index_annotation_lines <- unique_index_annotation_lines
    }
    ## ---------------------------------------------------------------------




    ## Insert additional blank lines for index annotations (nothing changes if length(index_annotation_lines) == 0)
    new_sequences_vector <- insert_at_indices(sequences_vector, index_annotation_lines, insert_before = index_annotations_above, insert = "", vert = index_annotation_vertical_position)


    ## Generate data for plotting
    image_data <- create_image_data(new_sequences_vector)
    sequence_text_data <- convert_sequences_to_annotations(new_sequences_vector, line_length = max(nchar(new_sequences_vector)), interval = 0)
    index_annotation_data <- create_many_sequence_index_annotations(new_sequences_vector, sequences_vector, index_annotation_lines, index_annotation_interval, index_annotation_full_line, index_annotations_above, index_annotation_vertical_position)


    ## Name the sequence colours vector
    names(sequence_colours) <- as.character(1:4)

    ## Calculate tile dimensions
    tile_width  <- 1/max(nchar(new_sequences_vector))
    tile_height <- 1/length(new_sequences_vector)

    ## Generate actual plot
    result <- ggplot(image_data, aes(x = .data$x, y = .data$y)) +
        ## Background
        geom_tile(data = filter(image_data, layer == 0), width = tile_width, height = tile_height, fill = background_colour) +

        ## Base boxes
        geom_tile(data = filter(image_data, layer != 0), width = tile_width, height = tile_height, aes(fill = as.character(.data$layer)),
                  col = outline_colour, linewidth = outline_linewidth, linejoin = tolower(outline_join)) +
        scale_fill_manual(values = sequence_colours) +

        ## General plot setup
        guides(x = "none", y = "none", fill = "none") +
        coord_cartesian(expand = FALSE, clip = "off") +
        theme_void() +
        theme(plot.background = element_rect(fill = background_colour, colour = NA),
              axis.title = element_blank())

    ## Add sequence text if desired
    if (sequence_text_size != 0) {
        result <- result +
            geom_text(data = sequence_text_data, aes(x = .data$x_position, y = .data$y_position, label = .data$annotation), col = sequence_text_colour, size = sequence_text_size, fontface = "bold", inherit.aes = F) +
            guides(col = "none", size = "none")
    }

    ## Add index annotations if desired
    if (length(index_annotation_lines) > 0) {
        result <- result +
            geom_text(data = index_annotation_data, aes(x = .data$x_position, y = .data$y_position, label = .data$annotation), col = index_annotation_colour, size = index_annotation_size, fontface = "bold", inherit.aes = F) +
            guides(col = "none", size = "none")
    }

    ## Correctly set margin, taking into consideration extra blank lines for annotations
    extra_spaces <- ceiling(index_annotation_vertical_position)
    if (1 %in% index_annotation_lines && index_annotations_above) {
        result <- result + theme(plot.margin = grid::unit(c(max(margin-extra_spaces, 0), margin, margin, margin), "inches"))
        extra_height <- margin + max(margin-extra_spaces, 0)
    } else if (length(sequences_vector) %in% index_annotation_lines && !index_annotations_above) {
        result <- result + theme(plot.margin = grid::unit(c(margin, margin, max(margin-extra_spaces, 0), margin), "inches"))
        extra_height <- margin + max(margin-extra_spaces, 0)
    } else {
        result <- result + theme(plot.margin = grid::unit(c(margin, margin, margin, margin), "inches"))
        extra_height <- 2 * margin
    }


    ## Check if filename is set and warn if not png, then export image
    if (is.na(filename) == FALSE) {
        if (is.character(filename) == FALSE) {
            bad_arg("filename", list(filename = filename), "must be a character/string (or NA if no file export wanted)")
        }
        if (tolower(substr(filename, nchar(filename)-3, nchar(filename))) != ".png") {
            warn("Not recommended to use non-png filetype (but may still work).", class = "filetype_recommendation")
        }
        ggsave(filename, plot = result, dpi = pixels_per_base, device = render_device, width = max(nchar(new_sequences_vector))+(2*margin), height = length(new_sequences_vector)+extra_height, limitsize = FALSE)
    }

    ## Return either the plot object or NULL
    if (return == TRUE) {
        return(result)
    }
    return(invisible(NULL))
}




#' Extract, sort, and add spacers between sequences in a dataframe
#'
#' This function takes a dataframe that contains sequences and metadata,
#' recursively splits it into multiple levels of groups defined by `grouping_levels`,
#' and adds breaks between each level of group as defined by `grouping_levels`.
#' Within each lowest-level group, reads are sorted by `sort_by`, with order determined
#' by `desc_sort`. \cr\cr Default values are set up to work with the included dataset
#' [`example_many_sequences`]. \cr\cr The returned sequences vector is ideal input for
#' [visualise_many_sequences()].\cr\cr Also called by [extract_methylation_from_dataframe()]
#' to produce input for [visualise_methylation()].
#'
#' @param sequence_dataframe `dataframe`. A dataframe containing the sequence information and all required meta-data. See [`example_many_sequences`] for an example of a compatible dataframe.
#' @param sequence_variable `character`. The name of the column within the dataframe containing the sequence information to be output. Defaults to `"sequence"`.
#' @param grouping_levels `named character vector`. What variables should be used to define the groups/chunks, and how large a gap should be left between groups at that level. Set to `NA` to turn off grouping.\cr\cr Defaults to `c("family" = 8, "individual" = 2)`, meaning the highest-level groups are defined by the `family` column, and there is a gap of 8 between each family. Likewise the second-level groups (within each family) are defined by the `individual` column, and there is a gap of 2 between each individual.\cr\cr Any number of grouping variables and gaps can be given, as long as each grouping variable is a column within the dataframe. It is recommended that lower-level groups are more granular and subdivide higher-level groups (e.g. first divide into families, then into individuals within families). \cr\cr To change the order of groups within a level, make that column a factor with the order specified e.g. `example_many_sequences$family <- factor(example_many_sequences$family, levels = c("Family 2", "Family 3", "Family 1"))` to change the order to Family 2, Family 3, Family 1.
#' @param sort_by `character`. The name of the column within the dataframe that should be used to sort/order the rows within each lowest-level group. Set to `NA` to turn off sorting within groups.\cr\cr Recommended to be the length of the sequence information, as is the case for the default `"sequence_length"` which was generated via `example_many_sequences$sequence_length <- nchar(example_many_sequences$sequence)`.
#' @param desc_sort `logical`. Boolean specifying whether rows within groups should be sorted by the `sort_by` variable descending (`TRUE`, default) or ascending (`FALSE`).
#'
#' @return `character vector`. The sequences ordered and grouped as specified, with blank sequences (`""`) inserted as spacers as specified.
#'
#' @examples
#' extract_and_sort_sequences(
#'     example_many_sequences,
#'     sequence_variable = "sequence",
#'     grouping_levels = c("family" = 8, "individual" = 2),
#'     sort_by = "sequence_length",
#'     desc_sort = TRUE
#' )
#'
#' extract_and_sort_sequences(
#'     example_many_sequences,
#'     sequence_variable = "sequence",
#'     grouping_levels = c("family" = 3),
#'     sort_by = "sequence_length",
#'     desc_sort = FALSE
#' )
#'
#' extract_and_sort_sequences(
#'     example_many_sequences,
#'     sequence_variable = "sequence",
#'     grouping_levels = NA,
#'     sort_by = "sequence_length",
#'     desc_sort = TRUE
#' )
#'
#' extract_and_sort_sequences(
#'     example_many_sequences,
#'     sequence_variable = "sequence",
#'     grouping_levels = c("family" = 8, "individual" = 2),
#'     sort_by = NA
#' )
#'
#' extract_and_sort_sequences(
#'     example_many_sequences,
#'     sequence_variable = "sequence",
#'     grouping_levels = NA,
#'     sort_by = NA
#' )
#'
#' extract_and_sort_sequences(
#'     example_many_sequences,
#'     sequence_variable = "quality",
#'     grouping_levels = c("individual" = 3),
#'     sort_by = "quality",
#'     desc_sort = FALSE
#' )
#'
#' @export
extract_and_sort_sequences <- function(
    sequence_dataframe,
    sequence_variable = "sequence",
    grouping_levels = c("family" = 8, "individual" = 2),
    sort_by = "sequence_length",
    desc_sort = TRUE
) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_null <- list(sequence_dataframe = sequence_dataframe, sequence_variable = sequence_variable, grouping_levels = grouping_levels, sort_by = sort_by, desc_sort = desc_sort)
    for (argument in names(not_null)) {
        if (any(is.null(not_null[[argument]]))) {bad_arg(argument, not_null, "must not be null.")}
    }
    not_null <- NULL

    length_1 <- list(sequence_variable = sequence_variable, sort_by = sort_by, desc_sort = desc_sort)
    for (argument in names(length_1)) {
        if (length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }
    length_1 <- NULL

    not_na <- list(sequence_variable = sequence_variable, desc_sort = desc_sort)
    for (argument in names(not_na)) {
        if (is.na(not_na[[argument]])) {bad_arg(argument, not_na, "must not be NA.")}
    }
    not_na <- NULL


    if (!any(is.na(grouping_levels))) {
        if (any(is.null(names(grouping_levels))) || any(names(grouping_levels) == "")) {
            bad_arg("grouping_levels", list(grouping_levels = grouping_levels), "must be a named vector (all elements named).", force_names = TRUE)
        }

        for (level in names(grouping_levels)) {
            if (level %in% colnames(sequence_dataframe) == FALSE  || is.character(level) == FALSE) {
                abort(paste0("Argument 'grouping_levels' must be a named numeric vector where all the names are columns in the input dataframe.\nCurrently '", level, "' is given as a grouping level name but is not a column in sequence_dataframe."), class = "argument_value_or_type")
            }
        }
        if (is.numeric(grouping_levels) == FALSE) {
            bad_arg("grouping_levels", list(grouping_levels = grouping_levels), "must be a named numeric vector. Currently it is not numeric.")
        }
    } else if (length(grouping_levels) > 1) {
        bad_arg("grouping_levels", list(grouping_levels = grouping_levels), "must be a single NA, or a named numeric vector with no NAs.\n  It cannot be a multi-element vector with some NA values.")
    }

    na_or_char_column <- list(sequence_variable = sequence_variable, sort_by = sort_by)
    for (argument in names(na_or_char_column)) {
        if (!is.na(na_or_char_column[[argument]]) && (!is.character(na_or_char_column[[argument]]) || !(na_or_char_column[[argument]] %in% colnames(sequence_dataframe)))) {
            bad_arg(argument, na_or_char_column, "must be a single character value and the name of a column within sequence_dataframe.")
        }
    }
    na_or_char_column <- FALSE

    bools <- list(desc_sort = desc_sort)
    for (argument in names(bools)) {
        if (!is.logical(bools[[argument]])) {bad_arg(argument, bools, "must be a logical/boolean value.")}
    }
    bools <- FALSE
    ## ---------------------------------------------------------------------



    ## Initialise
    sequence_dataframe <- as.data.frame(sequence_dataframe)
    sequence_variable  <- sym(sequence_variable)

    ## If grouping is off entirely, return sequences raw/sorted without breaks
    if (any(is.na(grouping_levels))) {
        if (!is.na(sort_by)) {
            sort_by <- sym(sort_by)
            if (desc_sort) {
                return(sequence_dataframe %>% arrange(desc(!!sort_by)) %>% pull(!!sequence_variable))
            } else {
                return(sequence_dataframe %>% arrange(!!sort_by) %>% pull(!!sequence_variable))
            }
        }
        return(sequence_dataframe %>% pull(!!sequence_variable))
    }



    ## Convert grouping levels to symbols and store gap values
    group_syms <- lapply(names(grouping_levels), sym)
    group_gaps <- as.numeric(unname(grouping_levels))

    ## Sort dataframe by grouping variables, with order within groups decided by sort_by
    if (!is.na(sort_by)) {
        sort_by <- sym(sort_by)
        if (desc_sort) {
            sequence_dataframe_sorted <- sequence_dataframe %>%
                arrange(!!!group_syms, desc(!!sort_by))
        } else {
            sequence_dataframe_sorted <- sequence_dataframe %>%
                arrange(!!!group_syms, !!sort_by)
        }
    } else {
        sequence_dataframe_sorted <- sequence_dataframe %>%
            arrange(!!!group_syms)
    }

    ## Recursive function to walk through grouping levels and
    ## add gaps between groups as specified by grouping_levels
    extract_sequences <- function(df, level = 1) {
        current_group <- group_syms[[level]]
        current_gap   <- group_gaps[[level]]
        sequences     <- character()

        group_vals <- unique(pull(df, !!current_group))
        for (i in seq_along(group_vals)) {
            group_val <- group_vals[[i]]
            df_sub <- df %>% filter(!!current_group == group_val)

            if (level < length(group_syms)) {
                sequences <- c(sequences, extract_sequences(df_sub, level + 1))
            } else {
                sequences <- c(sequences, pull(df_sub, !!sequence_variable))
            }

            # Add gap only if this is not the last subgroup
            if (i < length(group_vals)) {
                sequences <- c(sequences, rep("", current_gap))
            }
        }

        return(sequences)
    }

    ## Perform calculation and return outcome
    sequences <- extract_sequences(sequence_dataframe_sorted)
    return(sequences)
}




#' Insert blank items at specified indices in a vector ([visualise_many_sequences()] helper)
#'
#' This function takes a vector (e.g. the output of [extract_and_sort_sequences()]) and
#' inserts a specified "blank" value at the specified indices.
#' If `insert_before` is `TRUE` then the blank value will be inserted before each
#' specified index, whereas if `insert_before` is `FALSE` then the blank value
#' will be inserted after each specified index.
#'
#' @param original_vector `vector`. The vector to insert blanks into at specified locations (e.g. vector of sequences from extract_and_sort_sequences, but doesn't have to be).
#' @param insertion_indices `integer vector`. The indices (1-indexed) at which blanks should be inserted. If length 0, no blanks will be inserted.
#' @param insert_before `logical`. Whether blanks should be inserted before (`TRUE`, default) or after (`FALSE`) each specified index. Values must be sorted and unique.
#' @param insert `value`. The value that should be inserted before/after each specified index. Defaults to `""`. If length 0, nothing will be inserted. If length > 1, multiple items will be inserted at each specified index.
#' @param vert `numerical`. The vertical distance into the box that index annotations will be drawn. If set to `NA` (default) does nothing so that this function is more generalisable. If set to a number, then the `insert` will be repeated `ceiling(vert)` times each time it is inserted.
#'
#' @return `vector`. The original vector but with the `insert` value added before/after each specified index.
#'
#' @examples
#' insert_at_indices(c("A", "B", "C", "D", "E"), c(2, 4))
#'
#' insert_at_indices(
#'     c("A", "B", "C", "D", "E"),
#'     c(2, 4),
#'     insert_before = TRUE,
#'     insert = 0
#' )
#'
#' insert_at_indices(
#'     c("A", "B", "C", "D", "E"),
#'     c(2, 4),
#'     insert_before = FALSE,
#'     insert = 0
#' )
#'
#' insert_at_indices(
#'     original_vector = c("A", "B", "C", "D", "E"),
#'     insertion_indices = c(1, 4, 6),
#'     insert_before = TRUE,
#'     insert = c("X", "Y")
#' )
#'
#' insert_at_indices(
#'     list("A", "B", "C", "D", "E"),
#'     c(2, 4),
#'     insert = TRUE
#' )
#'
#' insert_at_indices(
#'     list("A", "B", "C", "D", "E"),
#'     c(2, 4),
#'     insert_before = FALSE,
#'     insert = list(TRUE, 7)
#' )
#'
#' insert_at_indices(
#'     NA,
#'     c(1, 2),
#'     FALSE
#' )
#'
#' insert_at_indices(
#'     c("A", "B", "C", "D", "E"),
#'     integer(0)
#' )
#'
#' @export
insert_at_indices <- function(
    original_vector,
    insertion_indices,
    insert_before = TRUE,
    insert = "",
    vert = NA
) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    if (is.vector(original_vector) == FALSE) {
        bad_arg("original_vector", list(original_vector = original_vector), "must be a vector.")
    }
    if (is.vector(insert) == FALSE) {
        bad_arg("insert", list(insert = insert), "must be a vector-coercable value.")
    }
    if (any(is.na(insert_before)) || any(is.null(insert_before)) || length(insert_before) != 1 || is.logical(insert_before) == FALSE) {
        bad_arg("insert_before", list(insert_before = insert_before), "must be a single logical/boolean value.")
    }
    if (any(is.na(insertion_indices)) || any(is.null(insertion_indices)) || !(is.numeric(insertion_indices)) || any(insertion_indices %% 1 != 0) || any(insertion_indices < 1)) {
        bad_arg("insertion_indices", list(insertion_indices = insertion_indices), "must be a vector of positive integers with no missing values.")
    }
    if (length(insertion_indices) > 0 && max(insertion_indices) > length(original_vector)) {
        warn(paste0("One or more indices are beyond the length of the vector and will be ignored.\nLength: ", length(original_vector), "\nIndices: ", paste(insertion_indices, collapse = ", ")), class = "length_exceeded")
    }
    if (length(vert) != 1 || is.null(vert) || (is.na(vert) == FALSE && (is.numeric(vert) == FALSE))) {
        bad_arg("vert", list(vert = vert), "must be NA or numeric. Recommended to leave it NA for most purposes.")
    }
    ## Check sorting and uniqueness
    if (any(sort(insertion_indices, na.last = TRUE) != insertion_indices)) {
        bad_arg("insertion_indices", list(insertion_indices = insertion_indices), "must be sorted.")
    }
    if (length(unique(insertion_indices)) != length(insertion_indices)) {
        bad_arg("insertion_indices", list(insertion_indices = insertion_indices), "must be unique.")
    }
    ## ---------------------------------------------------------------------




    ## Insert additional blanks if vert is specified
    if (is.na(vert) == FALSE) {
        insert <- rep(insert, ceiling(vert))
    }

    ## Insert blanks
    new_vector <- NULL
    for (i in 1:length(original_vector)) {
        if (i %in% insertion_indices) {
            if (insert_before == TRUE) {
                new_vector <- c(new_vector, insert, original_vector[i])
            } else {
                new_vector <- c(new_vector, original_vector[i], insert)
            }
        } else {
            new_vector <- c(new_vector, original_vector[i])
        }
    }

    return(new_vector)
}




#' Create index annotations at variable line positions in many sequences data ([visualise_many_sequences()] helper)
#'
#' This function is called by [visualise_many_sequences()] to create the x/y position
#' data for placing the index annotations on the graph.
#' Its arguments are either intermediate variables produced by [visualise_many_sequences()],
#' or arguments of [visualise_many_sequences()] directly passed through.\cr\cr
#' Returns a dataframe with `x_position`, `y_position`, `annotation`, and `type` columns.
#' `type` is always `"Number"` (unused, but for consistency with [convert_sequences_to_annotations()]).
#' `annotation` is always the position of the base along the line. In this function, the count
#' is reset each line (compared to counting consistenly along in [convert_sequences_to_annotations()])
#' because each line is a different sequence.
#'
#' @param new_sequences_vector `vector`. The output of [insert_at_indices()] when used with identical arguments.
#' @param original_sequences_vector `vector`. The vector of sequences used for plotting, that was originally given to [visualise_many_sequences()]. Must also have been used as input to [insert_at_indices()] to create `new_sequences_vector`.
#' @param original_indices_to_annotate `positive integer vector`. The vector of lines (i.e. indices) of `original_vector` to be annotated. Read from `index_annotation_lines` argument to [visualise_many_sequences()] (but after processing, so is assumed to be unique and sorted). Must also have been used as input to [insert_at_indices()] to create `new_sequences_vector`. Setting to a length-0 value (e.g. `numeric(0)`) causes this function to return an empty dataframe.
#' @param annotation_interval `integer`. The frequency at which numbers should be placed underneath indicating base index, starting counting from the leftmost base. Setting to `0` causes this function to return an empty dataframe. Defaults to `15`.
#' @param annotate_full_lines `logical`. Whether annotations should be calculated up to the end of the longest line (`TRUE`, default) or to the end of each line being annotated (`FALSE`).
#' @param annotations_above `logical`. Whether annotations should be drawn above (`TRUE`, default) or below (`FALSE`) each annotated line. Must also have been used as input to [insert_at_indices()] to create `new_sequences_vector`.
#' @param annotation_vertical_position `numeric`. The vertical position above/below each annotated line that annotations should be drawn. Must also have been used as input to [insert_at_indices()] to create `new_sequences_vector`.
#'
#' @return `dataframe`. A dataframe with columns `x_position`, `y_position`, `annotation`, and `type`, with one observation per annotation number that needs to be drawn onto the ggplot.
#'
#' @examples
#' ## Set up arguments (e.g. from visualise_many_sequences() call)
#' sequences_data <- example_many_sequences
#' index_annotation_lines <- c(1, 23, 37)
#' index_annotation_interval <- 10
#' index_annotations_above <- TRUE
#' index_annotation_full_line <- FALSE
#' index_annotation_vertical_position <- 1/3
#'
#'
#' ## Create sequences vector
#' sequences <- extract_and_sort_sequences(
#'     example_many_sequences,
#'     grouping_levels = c("family" = 8, "individual" = 2)
#' )
#' sequences
#'
#' ## Insert blank rows as needed
#' new_sequences <- insert_at_indices(
#'     sequences,
#'     insertion_indices = index_annotation_lines,
#'     insert_before = index_annotations_above,
#'     insert = "",
#'     vert = index_annotation_vertical_position
#' )
#' new_sequences
#'
#' ## Create annnotation dataframe
#' create_many_sequence_index_annotations(
#'     new_sequences_vector = new_sequences,
#'     original_sequences_vector = sequences,
#'     original_indices_to_annotate = index_annotation_lines,
#'     annotation_interval = 10,
#'     annotate_full_lines = index_annotation_full_line,
#'     annotations_above = index_annotations_above,
#'     annotation_vertical_position = index_annotation_vertical_position
#' )
#'
#'
#' @export
create_many_sequence_index_annotations <- function(
    new_sequences_vector,
    original_sequences_vector,
    original_indices_to_annotate,
    annotation_interval = 15,
    annotate_full_lines = TRUE,
    annotations_above = TRUE,
    annotation_vertical_position = 1/3
) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_na <- list(new_sequences_vector = new_sequences_vector, original_sequences_vector = original_sequences_vector, original_indices_to_annotate = original_indices_to_annotate, annotation_interval = annotation_interval, annotate_full_lines = annotate_full_lines, annotations_above = annotations_above, annotation_vertical_position = annotation_vertical_position)
    for (argument in names(not_na)) {
        if (any(is.na(not_na[[argument]]))) {bad_arg(argument, not_na, "must not be NA.")}
    }
    not_na <- NULL

    not_null <- list(new_sequences_vector = new_sequences_vector, original_sequences_vector = original_sequences_vector, original_indices_to_annotate = original_indices_to_annotate, annotation_interval = annotation_interval, annotate_full_lines = annotate_full_lines, annotations_above = annotations_above, annotation_vertical_position = annotation_vertical_position)
    for (argument in names(not_null)) {
        if (any(is.null(not_null[[argument]]))) {bad_arg(argument, not_null, "must not be NULL.")}
    }
    not_null <- NULL

    vectors <- list(new_sequences_vector = new_sequences_vector, original_sequences_vector = original_sequences_vector)
    for (argument in names(vectors)) {
        if (is.vector(vectors[[argument]]) == FALSE) {bad_arg(argument, vectors, "must be a vector.")}
    }
    vectors <- NULL

    length_1 <- list(annotation_interval = annotation_interval, annotate_full_lines = annotate_full_lines, annotations_above = annotations_above, annotation_vertical_position = annotation_vertical_position)
    for (argument in names(length_1)) {
        if (length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }
    length_1 <- NULL

    non_neg_numeric <- list(original_indices_to_annotate = original_indices_to_annotate, annotation_interval = annotation_interval, annotation_vertical_position = annotation_vertical_position)
    for (argument in names(non_neg_numeric)) {
        if (is.numeric(non_neg_numeric[[argument]]) == FALSE || any(non_neg_numeric[[argument]] < 0)) {bad_arg(argument, non_neg_numeric, "must be numeric and non-negative.")}
    }
    non_neg_numeric <- NULL

    integers <- list(original_indices_to_annotate = original_indices_to_annotate, annotation_interval = annotation_interval)
    for (argument in names(integers)) {
        if (any(integers[[argument]] %% 1 != 0)) {bad_arg(argument, integers, "must be integer only.")}
    }
    integers <- NULL

    positive <- list(original_indices_to_annotate = original_indices_to_annotate)
    for (argument in names(positive)) {
        if (any(positive[[argument]] <= 0)) {bad_arg(argument, positive, "must be positive only.")}
    }
    positive <- NULL

    bools <- list(annotate_full_lines = annotate_full_lines, annotations_above = annotations_above)
    for (argument in names(bools)) {
        if (is.logical(bools[[argument]]) == FALSE) {bad_arg(argument, bools, "must be logical/boolean.")}
    }
    bools <- NULL

    ## Instantly return empty dataframe if interval or indices is blank
    if (annotation_interval == 0 || length(original_indices_to_annotate) == 0) {
        return(data.frame("x_position" = numeric(), "y_position" = numeric(), "annotation" = character(), "type" = character()))
    }

    ## Check sorting and uniqueness
    if (any(sort(original_indices_to_annotate, na.last = TRUE) != original_indices_to_annotate)) {
        bad_arg("original_indices_to_annotate", list(original_indices_to_annotate = original_indices_to_annotate), "must be sorted.")
    }
    if (length(unique(original_indices_to_annotate)) != length(original_indices_to_annotate)) {
        bad_arg("original_indices_to_annotate", list(original_indices_to_annotate = original_indices_to_annotate), "must be unique.")
    }
    ## ---------------------------------------------------------------------




    ## Calculate indices of the sequences we are annotating
    ## e.g. if sequences 1, 2, and 4 were annotated, they are now at positions:
    ## - 2, 4, and 7 if insertions went before
    ## - 1, 3, and 6 if insertions went after
    ## (assuming each insertion is only one line - seq_along term is scaled if needed)
    annotated_sequence_indices <- original_indices_to_annotate + seq_along(original_indices_to_annotate)*ceiling(annotation_vertical_position) - as.numeric(!annotations_above)*ceiling(annotation_vertical_position)


    ## Calculate scaling factors
    x_interval <- 1 / max(nchar(new_sequences_vector))
    y_interval <- 1 / length(new_sequences_vector)


    ## Create actual data
    ## Make sure we don't iterate further than lines exist
    annotation_data <- data.frame("x_position" = numeric(), "y_position" = numeric(), "annotation" = character(), "type" = character())
    for (i in 1:min(length(annotated_sequence_indices), length(original_sequences_vector))) {
        annotated_sequence_index <- annotated_sequence_indices[i]

        ## Set max length along the line to annotate up to
        ## Either from overall max length, or from length of annotated sequence
        if (!annotate_full_lines) {
            line_length <- nchar(new_sequences_vector[annotated_sequence_index])
            if (is.na(line_length)) {
                abort(paste("Provided indices go out of range, please avoid doing this.\nIndex:", annotated_sequence_index, "\nnew_sequences_vector length:", length(new_sequences_vector)), class = "out_of_range")
            }
        } else {
            line_length <- max(nchar(new_sequences_vector))
        }

        ## Iterate along line and create dataframe observations for annotations
        ## Need to avoid 1:0 situation with blank lines and !annotate_full_lines,
        ## as that stretches out the plot by rendering to the left of the 1st box
        for (j in 1:max(line_length, 1)) {
            if (j %% annotation_interval == 0) {
                x_position <- x_interval * (j - 1/2)

                if (annotations_above == TRUE) {
                    y_position <- 1 - y_interval * (annotated_sequence_index - 1 - annotation_vertical_position)
                } else if (annotations_above == FALSE) {
                    y_position <- 1 - y_interval * (annotated_sequence_index + annotation_vertical_position)
                }

                annotation <- as.character(j)
                type <- "Number"
                annotation_data <- rbind(annotation_data, data.frame(x_position, y_position, annotation, type))
            }
        }
    }

    colnames(annotation_data) <- c("x_position", "y_position", "annotation", "type")
    annotation_data$x_position <- as.numeric(annotation_data$x_position)
    annotation_data$y_position <- as.numeric(annotation_data$y_position)
    return(annotation_data)
}
