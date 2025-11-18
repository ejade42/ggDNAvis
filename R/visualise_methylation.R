## FOR FUTURE - possibly add in overlaying sequence and/or numbers
## onto methylation visualisation?


#' Visualise methylation probabilities for many DNA sequences
#'
#' @aliases visualize_methylation
#'
#' @description
#' `visualize_methylation()` is an alias for `visualise_methylation()` - see [aliases].
#'
#' This function takes vectors of modifications locations, modification probabilities,
#' and sequence lengths (e.g. created by [extract_methylation_from_dataframe()]) and
#' visualises the probability of methylation (or other modification) across each read.
#'
#' Assumes that the three main input vectors are of equal length \eqn{n} and represent \eqn{n} sequences
#' (e.g. Nanopore reads), where `locations` are the indices along each read at which modification
#' was assessed, `probabilities` are the probability of modification at each assessed site, and
#' `lengths` are the lengths of each sequence.
#'
#' For each sequence, renders non-assessed (e.g. non-CpG) bases as `other_bases_colour`, renders
#' background (including after the end of the sequence) as `background_colour`, and renders assessed
#' bases on a linear scale from `low_colour` to `high_colour`.
#'
#' Clamping means that the endpoints of the colour gradient can be set some distance into the probability
#' space e.g. with Nanopore > SAM probability values from 0-255, the default is to render 0 as fully blue
#' (`#0000FF`), 255 as fully red (`#FF0000`), and values in between linearly interpolated. However, clamping with
#' `low_clamp = 100` and `high_clamp = 200` would set *all probabilities up to 100* as fully blue,
#' *all probabilities 200 and above* as fully red, and linearly interpolate only over the `100-200` range.
#'
#' A separate scalebar plot showing the colours corresponding to each probability, with any/no clamping values,
#' can be produced via [visualise_methylation_colour_scale()].
#'
#' @param modification_locations `character vector`. One character value for each sequence, storing a condensed string (e.g. `"3,6,9,12"`, produced via [vector_to_string()]) of the indices along the read at which modification was assessed. Indexing starts at 1.
#' @param modification_probabilities `character vector`. One character value for each sequence, storing a condensed string (e.g. `"0,128,255,15"`, produced via [vector_to_string()]) of the probability of methylation/modification at each assessed base.\cr\cr Assumed to be Nanopore > SAM style modification stored as an 8-bit integer from 0 to 255, but changing other arguments could make this work on other scales.
#' @param sequences `character vector`. One character value for each sequence, storing the actual DNA sequence.
#' @param low_colour `character`. The colour that should be used to represent minimum probability of methylation/modification (defaults to blue).
#' @param high_colour `character`. The colour that should be used to represent maximum probability of methylation/modification (defaults to red).
#' @param low_clamp `numeric`. The minimum probability below which all values are coloured `low_colour`. Defaults to `0` (i.e. no clamping). To specify a proportion probability in 8-bit form, multiply by 255 e.g. to low-clamp at 30% probability, set this to `0.3*255`.
#' @param high_clamp `numeric`. The maximum probability above which all values are coloured `high_colour`. Defaults to `255` (i.e. no clamping, assuming Nanopore > SAM style modification calling where probabilities are 8-bit integers from 0 to 255).
#' @param background_colour `character`. The colour the background should be drawn (defaults to white).
#' @param other_bases_colour `character`. The colour non-assessed (e.g. non-CpG) bases should be drawn (defaults to grey).
#' @param sequence_text_type `character`. What type of text should be drawn in the boxes. One of `"sequence"` (to draw the base sequence in the boxes, similar to [visualise_many_sequences()]), `"probability"` (to draw the numerical probability of methylation in each assessed box, optionally scaled via `sequence_text_scaling`), or `"none"` (default, to draw the boxes only with no text).
#' @param sequence_text_scaling `numeric vector, length 2`. The min and max possible probability values, used to facilitate scaling of the text in each to 0-1. Scaling is implemented as \eqn{\frac{p - min}{max}}, so custom scalings (e.g. scaled to 0-9 space) can be implemented by setting this values as required.\cr\cr Set to `c(0, 1)` to not scale at all i.e. print the raw integer probability values. It is recommended to also set `sequence_text_rounding = 0` to print integers as the default value of `2` will result in e.g. `"128.00"`. \cr\cr Set to `c(-0.5, 256)` (default, results in \eqn{\frac{p+0.5}{256}}) to scale to the centre of the probability spaces defined by the SAMtools spec, where integer \eqn{p} represents the probability space from \eqn{\frac{p}{256}} to \eqn{\frac{p+1}{256}}. This is slightly better at representing the uncertainty compared to `c(0, 255)` as strictly speaking `0` represents the probability space from 0.000 to 0.004 and `255` represents the probability space from 0.996 to 1.000, so scaling them to 0.002 and 0.998 respectively is a more accurate representation of the probability space they each represent. Setting `c(0, 255)` would scale such that 0 is exactly 0.000 and 255 is exactly 1.000, which is not as accurate so it discouraged.
#' @param sequence_text_rounding `integer`. How many decimal places the text drawn in the boxes should be rounded to (defaults to `2`). Ignored if `sequence_text_type` is `"sequence"` or `"none"`.
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
#' @param modified_bases_outline_colour `character`. If `NA` (default), inherits from `outline_colour`. If not `NA`, overrides `outline_colour` for modification-assessed bases only.
#' @param modified_bases_outline_linewidth `numeric`. If `NA` (default), inherits from `outline_linewidth`. If not `NA`, overrides `outline_linewidth` for modification-assessed bases only.
#' @param modified_bases_outline_join `character`. If `NA` (default), inherits from `outline_join`. If not `NA`, overrides `outline_join` for modification-assessed bases only.
#' @param other_bases_outline_colour `character`. If `NA` (default), inherits from `outline_colour`. If not `NA`, overrides `outline_colour` for non-modification-assessed bases only.
#' @param other_bases_outline_linewidth `numeric`. If `NA` (default), inherits from `outline_linewidth`. If not `NA`, overrides `outline_linewidth` for non-modification-assessed bases only.
#' @param other_bases_outline_join `character`. If `NA` (default), inherits from `outline_join`. If not `NA`, overrides `outline_join` for non-modification-assessed bases only.
#' @param margin `numeric`. The size of the margin relative to the size of each base square. Defaults to `0.5` (half the side length of each base square).\cr\cr Note that index annotations can require a minimum margin size at the top or bottom if present above the first/below the last row. This is handled automatically but can mean the top/bottom margin is sometimes larger than the `margin` setting.\cr\cr Very small margins (\eqn{\le}0.25) may cause thick outlines to be cut off at the edges of the plot. Recommended to either use a wider margin or a smaller `outline_linewidth`.
#' @param return `logical`. Boolean specifying whether this function should return the ggplot object, otherwise it will return `invisible(NULL)`. Defaults to `TRUE`.
#' @param filename `character`. Filename to which output should be saved. If set to `NA` (default), no file will be saved. Recommended to end with `".png"`, but can change if render device is changed.
#' @param render_device `function/character`. Device to use when rendering. See [ggplot2::ggsave()] documentation for options. Defaults to [`ragg::agg_png`]. Can be set to `NULL` to infer from file extension, but results may vary between systems.
#' @param pixels_per_base `integer`. How large each box should be in pixels, if file output is turned on via setting `filename`. Corresponds to dpi of the exported image. Defaults to `100`.\cr\cr Large values (e.g. 100) are required to render small text properly. Small values (e.g. 20) will work when sequence/annotation text is off, and very small values (e.g. 10) will work when sequence/annotation text and outlines are all off.
#' @param ... Used to recognise aliases e.g. American spellings or common misspellings - see [aliases]. Contact maintainer if any American spellings do not work.
#'
#' @return A ggplot object containing the full visualisation, or `invisible(NULL)` if `return = FALSE`. It is often more useful to use `filename = "myfilename.png"`, because then the visualisation is exported at the correct aspect ratio.
#'
#' @examples
#' \donttest{
#' ## Extract info from dataframe
#' methylation_info <- extract_methylation_from_dataframe(example_many_sequences)
#'
#' ## Visualise example_many_sequences with all defaults
#' ## This looks ugly because it isn't at the right scale/aspect ratio
#' visualise_methylation(
#'     methylation_info$locations,
#'     methylation_info$probabilities,
#'     methylation_info$sequences
#' )
#'
#' ## Export with all defaults rather than returning
#' visualise_methylation(
#'     methylation_info$locations,
#'     methylation_info$probabilities,
#'     methylation_info$sequences,
#'     filename = "example_vm_01.png",
#'     return = FALSE
#' )
#' ## View exported image
#' image <- png::readPNG("example_vm_01.png")
#' unlink("example_vm_01.png")
#' grid::grid.newpage()
#' grid::grid.raster(image)
#'
#' ## Export with customisation
#' visualise_methylation(
#'     methylation_info$locations,
#'     methylation_info$probabilities,
#'     methylation_info$sequences,
#'     filename = "example_vm_02.png",
#'     return = FALSE,
#'     low_colour = "white",
#'     high_colour = "black",
#'     low_clamp = 0.3*255,
#'     high_clamp = 0.7*255,
#'     other_bases_colour = "lightblue1",
#'     other_bases_outline_linewidth = 1,
#'     other_bases_outline_colour = "grey",
#'     modified_bases_outline_linewidth = 3,
#'     modified_bases_outline_colour = "black",
#'     margin = 0.3
#' )
#' ## View exported image
#' image <- png::readPNG("example_vm_02.png")
#' unlink("example_vm_02.png")
#' grid::grid.newpage()
#' grid::grid.raster(image)
#' }
#'
#' @export
visualise_methylation <- function(
    modification_locations,
    modification_probabilities,
    sequences,
    low_colour = "blue",
    high_colour = "red",
    low_clamp = 0,
    high_clamp = 255,
    background_colour = "white",
    other_bases_colour = "grey",
    sequence_text_type = "none",
    sequence_text_scaling = c(-0.5, 256),
    sequence_text_rounding = 2,
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
    modified_bases_outline_colour = NA,
    modified_bases_outline_linewidth = NA,
    modified_bases_outline_join = NA,
    other_bases_outline_colour = NA,
    other_bases_outline_linewidth = NA,
    other_bases_outline_join = NA,
    margin = 0.5,
    return = TRUE,
    filename = NA,
    render_device = ragg::agg_png,
    pixels_per_base = 100,
    ...
) {
    ## Process aliases
    ## ---------------------------------------------------------------------
    dots <- list(...)
    low_colour <- resolve_alias("low_colour", low_colour, "low_color", dots[["low_color"]], "blue")
    low_colour <- resolve_alias("low_colour", low_colour, "low_col", dots[["low_col"]], "blue")
    high_colour <- resolve_alias("high_colour", high_colour, "high_color", dots[["high_color"]], "red")
    high_colour <- resolve_alias("high_colour", high_colour, "high_col", dots[["high_col"]], "red")
    background_colour <- resolve_alias("background_colour", background_colour, "background_color", dots[["background_color"]], "white")
    background_colour <- resolve_alias("background_colour", background_colour, "background_col", dots[["background_col"]], "white")
    other_bases_colour <- resolve_alias("other_bases_colour", other_bases_colour, "other_bases_color", dots[["other_bases_color"]], "grey")
    other_bases_colour <- resolve_alias("other_bases_colour", other_bases_colour, "other_bases_col", dots[["other_bases_col"]], "grey")
    sequence_text_colour <- resolve_alias("sequence_text_colour", sequence_text_colour, "sequence_text_color", dots[["sequence_text_color"]], "black")
    sequence_text_colour <- resolve_alias("sequence_text_colour", sequence_text_colour, "sequence_text_col", dots[["sequence_text_col"]], "black")
    index_annotation_colour <- resolve_alias("index_annotation_colour", index_annotation_colour, "index_annotation_color", dots[["index_annotation_color"]], "darkred")
    index_annotation_colour <- resolve_alias("index_annotation_colour", index_annotation_colour, "index_annotation_col", dots[["index_annotation_col"]], "darkred")
    outline_colour <- resolve_alias("outline_colour", outline_colour, "outline_color", dots[["outline_color"]], "black")
    outline_colour <- resolve_alias("outline_colour", outline_colour, "outline_col", dots[["outline_col"]], "black")
    modified_bases_outline_colour <- resolve_alias("modified_bases_outline_colour", modified_bases_outline_colour, "modified_bases_outline_color", dots[["modified_bases_outline_color"]], NA)
    modified_bases_outline_colour <- resolve_alias("modified_bases_outline_colour", modified_bases_outline_colour, "modified_bases_outline_col", dots[["modified_bases_outline_col"]], NA)
    other_bases_outline_colour <- resolve_alias("other_bases_outline_colour", other_bases_outline_colour, "other_bases_outline_color", dots[["other_bases_outline_color"]], NA)
    other_bases_outline_colour <- resolve_alias("other_bases_outline_colour", other_bases_outline_colour, "other_bases_outline_col", dots[["other_bases_outline_col"]], NA)
    index_annotations_above <- resolve_alias("index_annotations_above", index_annotations_above, "index_annotation_above", dots[["index_annotation_above"]], TRUE)
    index_annotation_full_line <- resolve_alias("index_annotation_full_line", index_annotation_full_line, "index_annotations_full_line", dots[["index_annotations_full_line"]], TRUE)
    index_annotation_full_line <- resolve_alias("index_annotation_full_line", index_annotation_full_line, "index_annotations_full_lines", dots[["index_annotations_full_lines"]], TRUE)
    index_annotation_full_line <- resolve_alias("index_annotation_full_line", index_annotation_full_line, "index_annotation_full_lines", dots[["index_annotation_full_lines"]], TRUE)
    ## ---------------------------------------------------------------------



    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_null <- list(modification_locations = modification_locations, modification_probabilities = modification_probabilities, sequences = sequences, background_colour = background_colour, other_bases_colour = other_bases_colour, low_colour = low_colour, high_colour = high_colour, low_clamp = low_clamp, high_clamp = high_clamp, sequence_text_type = sequence_text_type, sequence_text_rounding = sequence_text_rounding, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, index_annotation_full_line = index_annotation_full_line, outline_linewidth = outline_linewidth, outline_colour = outline_colour, outline_join = outline_join, modified_bases_outline_linewidth = modified_bases_outline_linewidth, modified_bases_outline_colour = modified_bases_outline_colour, modified_bases_outline_join = modified_bases_outline_join, other_bases_outline_linewidth = other_bases_outline_linewidth, other_bases_outline_colour = other_bases_outline_colour, other_bases_outline_join = other_bases_outline_join, margin = margin, return = return, filename = filename, pixels_per_base = pixels_per_base)
    for (argument in names(not_null)) {
        if (any(is.null(not_null[[argument]]))) {bad_arg(argument, not_null, "must not be NULL.")}
    }
    not_null <- NULL

    length_1 <- list(background_colour = background_colour, other_bases_colour = other_bases_colour, low_colour = low_colour, high_colour = high_colour, low_clamp = low_clamp, high_clamp = high_clamp,sequence_text_type = sequence_text_type, sequence_text_rounding = sequence_text_rounding, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, index_annotation_full_line = index_annotation_full_line, outline_linewidth = outline_linewidth, outline_colour = outline_colour, outline_join = outline_join, modified_bases_outline_linewidth = modified_bases_outline_linewidth, modified_bases_outline_colour = modified_bases_outline_colour, modified_bases_outline_join = modified_bases_outline_join, other_bases_outline_linewidth = other_bases_outline_linewidth, other_bases_outline_colour = other_bases_outline_colour, other_bases_outline_join = other_bases_outline_join, margin = margin, return = return, filename = filename, pixels_per_base = pixels_per_base)
    for (argument in names(length_1)) {
        if (length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }
    length_1 <- NULL

    not_na <- list(modification_locations = modification_locations, modification_probabilities = modification_probabilities, sequence = sequences, background_colour = background_colour, other_bases_colour = other_bases_colour, low_colour = low_colour, high_colour = high_colour, low_clamp = low_clamp, high_clamp = high_clamp, sequence_text_type = sequence_text_type, sequence_text_rounding = sequence_text_rounding, sequence_text_colour = sequence_text_colour, sequence_text_size = sequence_text_size, index_annotation_colour = index_annotation_colour, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, index_annotation_full_line = index_annotation_full_line, margin = margin, return = return, pixels_per_base = pixels_per_base)
    for (argument in names(not_na)) {
        if (any(is.na(not_na[[argument]]))) {bad_arg(argument, not_na, "must not be NA.")}
    }
    not_na <- NULL

    single_char <- list(background_colour = background_colour, other_bases_colour = other_bases_colour, sequence_text_colour = sequence_text_colour, index_annotation_colour = index_annotation_colour, low_colour = low_colour, high_colour = high_colour, outline_colour = outline_colour, modified_bases_outline_colour = modified_bases_outline_colour, other_bases_outline_colour = other_bases_outline_colour)
    for (argument in names(single_char)) {
        if (!is.na(single_char[[argument]]) && (!is.character(single_char[[argument]]) || length(single_char[[argument]]) != 1)) {bad_arg(argument, single_char, "must be a single character value, and a valid colour name or hexcode.")}
    }
    single_char <- NULL

    ## Interpret NA/NULL/empty argument as not wanting any annotations
    if (any(is.na(index_annotation_lines)) || any(is.null(index_annotation_lines)) || length(index_annotation_lines) == 0) {
        index_annotation_lines <- integer(0)
    }

    single_num <- list(low_clamp = low_clamp, high_clamp = high_clamp, margin = margin, sequence_text_rounding = sequence_text_rounding, sequence_text_size = sequence_text_size, index_annotation_size = index_annotation_size, index_annotation_interval = index_annotation_interval, index_annotation_vertical_position = index_annotation_vertical_position, pixels_per_base = pixels_per_base, outline_linewidth = outline_linewidth, modified_bases_outline_linewidth = modified_bases_outline_linewidth, other_bases_outline_linewidth = other_bases_outline_linewidth)
    for (argument in names(single_num)) {
        if (!is.na(single_num[[argument]]) && (!is.numeric(single_num[[argument]]) || length(single_num[[argument]]) != 1)) {bad_arg(argument, single_num, "must be a single numeric value.")}
    }
    single_num <- NULL

    pos_int <- list(pixels_per_base = pixels_per_base, index_annotation_lines = index_annotation_lines)
    for (argument in names(pos_int)) {
        if (!is.numeric(pos_int[[argument]]) || any(pos_int[[argument]] %% 1 != 0) || any(pos_int[[argument]] < 1)) {bad_arg(argument, pos_int, "must be a positive integer.")}
    }
    pos_int <- NULL

    non_neg_int <- list(index_annotation_interval = index_annotation_interval, sequence_text_rounding = sequence_text_rounding)
    for (argument in names(non_neg_int)) {
        if (!is.numeric(non_neg_int[[argument]]) || any(non_neg_int[[argument]] %% 1 != 0) || any(non_neg_int[[argument]] < 0)) {bad_arg(argument, non_neg_int, "must be a non-negative integer.")}
    }
    non_neg_int <- NULL

    non_neg_num <- list(index_annotation_size = index_annotation_size, index_annotation_vertical_position = index_annotation_vertical_position, sequence_text_size = sequence_text_size)
    for (argument in names(non_neg_num)) {
        if (!is.numeric(non_neg_num[[argument]]) || any(non_neg_num[[argument]] < 0)) {bad_arg(argument, non_neg_num, "must be a non-negative number.")}
    }
    non_neg_num <- NULL

    bool <- list(return = return, index_annotations_above = index_annotations_above, index_annotation_full_line = index_annotation_full_line)
    for (argument in names(bool)) {
        if (!is.logical(bool[[argument]]) || length(bool[[argument]]) != 1) {bad_arg(argument, bool, "must be a single logical/boolean value.")}
    }
    bool <- NULL

    if (length(modification_locations) != length(modification_probabilities) ||
        length(modification_locations) != length(sequences) ||
        length(modification_probabilities) != length(sequences)) {
        abort(paste("Modification locations, modification probabilities, and sequences must all be the same length.\n'modification_locations' length:", length(modification_locations), "\n'modification_probabilities' length:", length(modification_probabilities), "\n'sequences' length:", length(sequences)), class = "argument_value_or_type")
    }

    string_to_vector_valid <- list(modification_locations = modification_locations, modification_probabilities = modification_probabilities)
    for (argument in names(string_to_vector_valid)) {
        if (!is.character(string_to_vector_valid[[argument]])) {bad_arg(argument, string_to_vector_valid, "must be a character vector.")}
        if (any(is.na(string_to_vector(string_to_vector_valid[[argument]])))) {bad_arg(argument, string_to_vector_valid, "must expand to a numeric vector via string_to_vector().\nCheck that all its values are comma-separated numbers e.g. '1,2,3,4'.")}
    }
    string_to_vector_valid <- NULL

    valid_seq <- list(sequences = sequences)
    for (argument in names(valid_seq)) {
        if (!is.character(valid_seq[[argument]])) {bad_arg(argument, valid_seq, "must be a character vector.")}
        if (any(!(toupper(strsplit(paste(sequences, collapse = ""), "")[[1]]) %in% c("A", "C", "G", "T", "U")))) {bad_arg(argument, valid_seq, "must consist only of A/C/G/T/U.")}
    }
    valid_seq <- NULL

    ## Overwrite outline parameters if needed
    if (is.na(modified_bases_outline_colour))    {modified_bases_outline_colour    <- outline_colour}
    if (is.na(modified_bases_outline_linewidth)) {modified_bases_outline_linewidth <- outline_linewidth}
    if (is.na(modified_bases_outline_join))      {modified_bases_outline_join      <- outline_join}
    if (is.na(other_bases_outline_colour))       {other_bases_outline_colour       <- outline_colour}
    if (is.na(other_bases_outline_linewidth))    {other_bases_outline_linewidth    <- outline_linewidth}
    if (is.na(other_bases_outline_join))         {other_bases_outline_join         <- outline_join}

    ## Check colour, linewidth, and join are specified for both
    for (argument in list(modified_bases_outline_linewidth, modified_bases_outline_colour, modified_bases_outline_join, other_bases_outline_linewidth, other_bases_outline_colour, other_bases_outline_join)) {
        if (is.na(argument)) {abort("Outline colour, linewidth, and join must all be specified generally (via outline_colour etc) or for both modified bases and other bases (via both modified_bases_outline_colour and other_bases_outline_colour etc). Currently there is an NA.", class = "argument_value_or_type")}
    }

    ## Check join is valid
    for (argument in list(modified_bases_outline_join, other_bases_outline_join)) {
        if (!(tolower(argument) %in% c("mitre", "round", "bevel"))) {
            abort(paste("All outline join arguments must be one of 'mitre', 'round', or 'bevel'.\nCurrent value(s):", paste(unique(c(modified_bases_outline_join, other_bases_outline_join)), collapse = ", ")), class = "argument_value_or_type")
        }
    }

    ## Make sequence_text_type all lowercase, then check it is a valid option
    sequence_text_type <- tolower(sequence_text_type)
    if (!is.character(sequence_text_type) || !(sequence_text_type %in% c("sequence", "probability", "none"))) {
        bad_arg("sequence_text_type", list(sequence_text_type = sequence_text_type), "must be one of 'sequence', 'probability', or 'none'.")
    }

    scaling_list <- list(sequence_text_scaling = sequence_text_scaling)
    for (argument in names(scaling_list)) {
        if (!is.numeric(scaling_list[[argument]]) || length(scaling_list[[argument]]) != 2) {bad_arg(argument, scaling_list, "must be a length-2 numerical vector.")}
        if (all(scaling_list[[argument]] == c(0, 255))) {
            warn("Setting sequence_text_scaling to 'c(0, 255)' is generally not recommended as it does not capture the uncertainty in the 8-bit integer probabilities.\nIf you are trying to scale the 8-bit integers to probabilities, you should probably use 'c(-0.5, 256)' - see the documentation for the sequence_text_scaling argument of visualise_methylation for more details.\nIf trying to scale the displayed probabilities without accounting for this uncertainty is a deliberate choice then the code will work, but proceed with caution.", class = "unrecommended_argument")
        } else if (!(all(scaling_list[[argument]] == c(0, 1)) || all(scaling_list[[argument]] == c(-0.5, 256)))) {
            warn(paste("Setting sequence_text_scaling to something other than 'c(0, 1)' or 'c(-0.5, 256)' is advanced use and should be done intentionally and with caution.\nCurrent value:", paste(scaling_list[[argument]], collapse = ", ")), class = "advanced_use")
        }
    }
    scaling_list <- NULL

    ## Warn about margin
    if (margin <= 0.25 && (modified_bases_outline_linewidth > 0 || other_bases_outline_linewidth > 0)) {
        warn(paste("If margin is small and outlines are on (outline_linewidth > 0), outlines may be cut off at the edges of the plot. Check if this is happening and consider using a bigger margin.\nCurrent margin:", margin), class = "parameter_recommendation")
    }
    ## Check clamping values
    if (low_clamp >= high_clamp) {
        abort(paste("Low clamp value must be strictly less than high clamp value.\nCurrent 'low_clamp' value:", low_clamp, "\nCurrent 'high_clamp' value:", high_clamp), class = "argument_value_or_type")
    }
    ## Accept NA as NULL for render_device
    if (is.atomic(render_device) && any(is.na(render_device))) {render_device <- NULL}

    ## Automatically turn off annotations if size or interval is set to 0.
    if (index_annotation_interval == 0 && length(index_annotation_lines) > 0 ) {
        cli_alert_info("Automatically emptying index_annotation_lines as index_annotation_interval is 0.", class = "turn_off_annotations_by_other_argument")
        index_annotation_lines <- integer(0)
    } else if (index_annotation_size == 0 && length(index_annotation_lines) > 0 ) {
        cli_alert_info("Automatically emptying index_annotation_lines as index_annotation_size is 0.", class = "turn_off_annotations_by_other_argument")
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

    ## Automatically turn off sequences if size is 0
    if (sequence_text_size == 0 && sequence_text_type != "none") {
        cli_alert_info("Automatically setting sequence_text_type to 'none' as sequence_text_size is 0.")
        sequence_text_type <- "none"
    }

    ## Warn about showing probabilities if text size is too large
    if (sequence_text_type == "probability" && sequence_text_size == 16) {
        warn("The default sequence_text_size of 16 is likely to be too large for displaying probabilities.\nConsider setting sequence_text_size to a smaller value e.g. 10.", class = "default_text_too_large_for_prob")
    }
    ## ---------------------------------------------------------------------




    ## Set up original vectors, so I can then modify the ones with the direct argument names
    modification_locations_original     <- modification_locations
    modification_probabilities_original <- modification_probabilities
    sequences_original <- sequences

    ## Insert blanks as required
    modification_locations <- insert_at_indices(modification_locations_original,     index_annotation_lines, insert_before = index_annotations_above, insert = "", vert = index_annotation_vertical_position)
    suppressWarnings({ ## suppress duplicate warnings about out-of-range indices
        modification_probabilities <- insert_at_indices(modification_probabilities_original, index_annotation_lines, insert_before = index_annotations_above, insert = "", vert = index_annotation_vertical_position)
        sequences <- insert_at_indices(sequences_original, index_annotation_lines, insert_before = index_annotations_above, insert = "", vert = index_annotation_vertical_position)
    }, classes = "length_exceeded")
    index_annotation_data <- convert_many_sequences_to_index_annotations(sequences, sequences_original, index_annotation_lines, index_annotation_interval, index_annotation_full_line, index_annotations_above, index_annotation_vertical_position)


    ## Generate rasterised dataframes of methylation and masking layer
    max_length <- max(nchar(sequences))
    image_matrix <- matrix(NA, nrow = length(modification_locations), ncol = max_length)
    for (i in 1:length(modification_locations)) {
        numeric_sequence_representation <- convert_modification_to_number_vector(modification_locations[i], modification_probabilities[i], max_length, nchar(sequences[i]))
        image_matrix[i, ] <- numeric_sequence_representation
    }
    image_data <- rasterise_matrix(image_matrix)

    ## Transform image data if clamping limits are set
    image_data$clamped_layer <- pmin(pmax(image_data$layer, low_clamp), high_clamp)


    ## Generate sequence text data based on the chosen setting
    if (sequence_text_type == "sequence") {
        sequence_text_data <- convert_sequences_to_annotations(sequences, line_length = max(nchar(sequences)), interval = 0)
    } else if (sequence_text_type == "probability") {
        probability_data <- convert_probabilities_to_annotations(modification_locations, modification_probabilities, sequences, sequence_text_scaling, sequence_text_rounding)
    }


    ## Calculate width and height of tiles based on sequences
    tile_width  <- 1/max(nchar(sequences))
    tile_height <- 1/length(sequences)

    ## Make methylation visualisation plot
    result <- ggplot(mapping = aes(x = .data$x, y = .data$y)) +
        ## Background
        geom_tile(data = filter(image_data, layer == -2), fill = background_colour, width = tile_width, height = tile_height) +

        ## Non-assessed bases
        geom_tile(data = filter(image_data, layer == -1), fill = other_bases_colour, width = tile_width, height = tile_height,
                  col = other_bases_outline_colour, linewidth = other_bases_outline_linewidth, linejoin = tolower(other_bases_outline_join)) +

        ## Modification-assessed bases
        geom_tile(data = filter(image_data, layer >= 0), aes(fill = .data$clamped_layer), width = tile_width, height = tile_height,
                  col = modified_bases_outline_colour, linewidth = modified_bases_outline_linewidth, linejoin = tolower(modified_bases_outline_join)) +
        scale_fill_gradient(low = low_colour, high = high_colour, limits = c(low_clamp, high_clamp)) +

        ## General plot setup
        coord_cartesian(expand = FALSE, clip = "off") +
        guides(x = "none", y = "none", fill = "none") +
        theme_void() +
        theme(plot.background = element_rect(fill = background_colour, colour = NA),
              axis.title = element_blank())

    ## Add sequence text or probability labels if desired
    if (sequence_text_type == "sequence") {
        result <- result +
            geom_text(data = sequence_text_data, aes(x = .data$x_position, y = .data$y_position, label = .data$annotation), col = sequence_text_colour, size = sequence_text_size, fontface = "bold", inherit.aes = F) +
            guides(col = "none", size = "none")
    } else if (sequence_text_type == "probability") {
        result <- result +
            geom_text(data = probability_data, aes(x = .data$x_position, y = .data$y_position, label = .data$annotation), col = sequence_text_colour, size = sequence_text_size, fontface = "bold", inherit.aes = F) +
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
    } else if (length(modification_locations_original) %in% index_annotation_lines && !index_annotations_above) {
        result <- result + theme(plot.margin = grid::unit(c(margin, margin, max(margin-extra_spaces, 0), margin), "inches"))
        extra_height <- margin + max(margin-extra_spaces, 0)
    } else {
        result <- result + theme(plot.margin = grid::unit(c(margin, margin, margin, margin), "inches"))
        extra_height <- 2 * margin
    }

    ## Validate filename and export image
    if (is.na(filename) == FALSE) {
        if (is.character(filename) == FALSE) {
            bad_arg("filename", list(filename = filename), "must be a character/string (or NA if no file export wanted).")
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



#' Visualise methylation colour scalebar
#'
#' @aliases visualize_methylation_color_scale
#'
#' @description
#' `visualize_methylation_color_scale()` is an alias for `visualise_methylation_colour_scale()` - see [aliases].
#'
#' This function creates a scalebar showing the colouring scheme based on methylation
#' probability that is used in [visualise_methylation()]. Showing this is particularly
#' important when the colour range is clamped via `low_clamp` and `high_clamp` (e.g.
#' setting that all values below 100 are fully blue (`#0000FF`), all values above 200 are
#' fully red (`#FF0000`), and colour interpolation occurs only in the range 100-200, rather
#' than across the whole range 0-255). If clamping is off (default), then 0 is fully blue,
#' 255 is fully read, and all values are linearly interpolated. NB: colours are configurable
#' but default to blue = low modification probability and red = high modification probability.
#'
#' @param full_range `numeric vector`, length 2. The total range of possible probabilities. Defaults to `c(0, 255)`, which is appropriate for Nanopore > SAM style modification calling where probabilities are 8-bit integers from 0 to 255.\cr\cr May need to be set to `c(0, 1)` if probabilites are instead stored as decimals. Setting any other value is advanced use and should be done for a good reason.
#' @param precision `integer`. How many different shades should be rendered. Larger values give a smoother gradient. Defaults to `10^3` i.e. `1000`, which looks smooth to my eyes and isn't too intensive to calculate.
#' @param x_axis_title `character`. The desired x-axis title. Defaults to `NULL`.
#' @param do_x_ticks `logical`. Boolean specifying whether x axis ticks should be enabled (`TRUE`, default) or disabled (`FALSE`).
#' @param do_side_scale `logical`. Boolean specifying whether a smaller scalebar should be rendered on the right. Defaults to `FALSE`.\cr\cr I think it is unlikely anyone would want to use this, but the option is here. One potential usecase is that this scalebar shows the raw probability values (e.g. 0 to 255), whereas the x-axis is normalised to 0-1.
#' @param side_scale_title `character`. The desired title for the right-hand scalebar, if turned on. Defaults to `NULL`.
#' @param outline_colour `character`. The colour of the scalebar outline. Defaults to black.
#' @param outline_linewidth `numeric`. The linewidth of the scalebar outline. Defaults to `1`. Set to `0` to disable scalebar outline.
#'
#' @inheritParams visualise_methylation
#'
#' @return ggplot of the scalebar.\cr\cr Unlike the other `visualise_<>` functions in this package, does not directly export a png. This is because there are no squares that need to be rendered at a precise aspect ratio in this function. It can just be saved normally with [ggplot2::ggsave()] with any sensible combination of height and width.
#'
#' @examples
#' ## Defaults match defaults of visualise_methylation()
#' visualise_methylation_colour_scale()
#'
#' ## Use clamping and change colours
#' visualise_methylation_colour_scale(
#'     low_colour = "white",
#'     high_colour = "black",
#'     low_clamp = 0.3*255,
#'     high_clamp = 0.7*255,
#'     full_range = c(0, 255),
#'     background_colour = "lightblue1",
#'     x_axis_title = "Methylation probability"
#' )
#'
#' ## Lower precision = colour banding
#' visualise_methylation_colour_scale(
#'     precision = 10,
#'     do_x_ticks = FALSE
#' )
#'
#' @export
visualise_methylation_colour_scale <- function(
    low_colour = "blue",
    high_colour = "red",
    low_clamp = 0,
    high_clamp = 255,
    full_range = c(0, 255),
    precision = 10^3,
    background_colour = "white",
    x_axis_title = NULL,
    do_x_ticks = TRUE,
    do_side_scale = FALSE,
    side_scale_title = NULL,
    outline_colour = "black",
    outline_linewidth = 1,
    ...
) {
    ## Process aliases
    ## ---------------------------------------------------------------------
    dots <- list(...)
    low_colour <- resolve_alias("low_colour", low_colour, "low_color", dots[["low_color"]], "blue")
    low_colour <- resolve_alias("low_colour", low_colour, "low_col", dots[["low_col"]], "blue")
    high_colour <- resolve_alias("high_colour", high_colour, "high_color", dots[["high_color"]], "red")
    high_colour <- resolve_alias("high_colour", high_colour, "high_col", dots[["high_col"]], "red")
    background_colour <- resolve_alias("background_colour", background_colour, "background_color", dots[["background_color"]], "white")
    background_colour <- resolve_alias("background_colour", background_colour, "background_col", dots[["background_col"]], "white")
    outline_colour <- resolve_alias("outline_colour", outline_colour, "outline_color", dots[["outline_color"]], "black")
    outline_colour <- resolve_alias("outline_colour", outline_colour, "outline_col", dots[["outline_col"]], "black")
    ## ---------------------------------------------------------------------



    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_null_or_na <- list(low_colour = low_colour, high_colour = high_colour, low_clamp = low_clamp, high_clamp = high_clamp, full_range = full_range, precision = precision, background_colour = background_colour, do_x_ticks = do_x_ticks, do_side_scale = do_side_scale, outline_colour = outline_colour, outline_linewidth = outline_linewidth)
    for (argument in names(not_null_or_na)) {
        if (any(is.null(not_null_or_na[[argument]])) || any(is.na(not_null_or_na[[argument]]))) {bad_arg(argument, not_null_or_na, "must not be NULL or NA.")}
    }
    not_null_or_na <- NULL

    length_1 <- list(low_colour = low_colour, high_colour = high_colour, low_clamp = low_clamp, high_clamp = high_clamp, precision = precision, background_colour = background_colour, x_axis_title = x_axis_title, do_x_ticks = do_x_ticks, do_side_scale = do_side_scale, side_scale_title = side_scale_title, outline_colour = outline_colour, outline_linewidth = outline_linewidth)
    for (argument in names(length_1)) {
        if (!any(is.null(length_1[[argument]])) && length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }

    single_char <- list(background_colour = background_colour, low_colour = low_colour, high_colour = high_colour, outline_colour = outline_colour)
    for (argument in names(single_char)) {
        if (!is.na(single_char[[argument]]) && (!is.character(single_char[[argument]]) || length(single_char[[argument]]) != 1)) {bad_arg(argument, single_char, "must be a single character value, and a valid colour name or hexcode.")}
    }
    single_char <- NULL

    numerical <- list(low_clamp = low_clamp, high_clamp = high_clamp, full_range = full_range, precision = precision, outline_linewidth = outline_linewidth)
    for (argument in names(numerical)) {
        if (!is.numeric(numerical[[argument]])) {bad_arg(argument, numerical, "must be numeric.")}
    }
    numerical <- NULL

    bool <- list(do_x_ticks = do_x_ticks, do_side_scale = do_side_scale)
    for (argument in names(bool)) {
        if (!is.logical(bool[[argument]])) {bad_arg(argument, bool, "must be logical/boolean.")}
    }
    bool <- NULL

    char_or_na_null <- list(x_axis_title = x_axis_title, side_scale_title = side_scale_title)
    for (argument in names(char_or_na_null)) {
        if (!any(is.null(char_or_na_null[[argument]])) && !any(is.na(char_or_na_null[[argument]]))) {
            if (!is.character(char_or_na_null[[argument]]) || length(char_or_na_null[[argument]]) != 1) {bad_arg(argument, char_or_na_null, "must be a single character value, or NA/NULL.")}
        }
    }
    char_or_na_null <- NULL

    ## Accept NA as meaning NULL for titles
    if (any(is.null(x_axis_title)) || any(is.na(x_axis_title))) {x_axis_title <- NULL}
    if (any(is.null(side_scale_title)) || any(is.na(side_scale_title))) {side_scale_title <- NULL}


    if (length(full_range) != 2) {bad_arg("full_range", list(full_range = full_range), "must provide two numeric values e.g. c(0, 255) as the full probability range.")}

    if (any(full_range != c(0, 255)) && any(full_range != c(0, 1))) {
        warn("It is unusual to set full probabality range to something other than 0-255 or 0-1. Make sure you know what you're doing.", class = "parameter_recommendation")
    }
    ## Check clamping values
    if (low_clamp >= high_clamp) {
        abort(paste("Low clamp value must be strictly less than high clamp value.\nCurrent 'low_clamp' value:", low_clamp, "\nCurrent 'high_clamp' value:", high_clamp), class = "argument_value_or_type")
    }
    ## ---------------------------------------------------------------------



    ## Use arguments to calculate scales and evaluate at specified intervals
    x_scale <- seq(0, 1-1/precision, 1/precision)
    full_data_span <- full_range[2] - full_range[1]
    col_scale <- seq(0, 1, 1/(precision-1)) * full_data_span
    col_scale_clamped <- pmin(pmax(col_scale, low_clamp), high_clamp)

    ## Combine into dataframe
    scale_data <- data.frame(xmin = x_scale, xmax = x_scale + 1/precision, col_scale = col_scale, col_scale_clamped = col_scale_clamped)

    ## Plot
    result <- ggplot(scale_data) +
        geom_rect(aes(xmin = .data$xmin, xmax = .data$xmax, ymin = 0, ymax = 1, fill = .data$col_scale_clamped)) +
        scale_fill_gradient(low = low_colour, high = high_colour, limits = c(low_clamp, high_clamp)) +
        coord_cartesian(expand = F) +
        theme(axis.ticks.y = element_blank(), axis.text.y = element_blank()) +
        labs(x = x_axis_title, fill = side_scale_title) + guides(fill = "none") +
        theme(plot.background = element_rect(fill = background_colour, colour = NA),
              panel.border = element_rect(fill = NA, colour = outline_colour, linewidth = outline_linewidth),
              plot.margin = grid::unit(c(0.05, 0.16, 0.05, 0.16), "inches"))

    ## Alter plot according to arguments
    if (do_x_ticks == FALSE) {
        result <- result + theme(axis.ticks.x = element_blank(), axis.text.x = element_blank())
    }
    if (do_side_scale == TRUE) {
        result <- result + guides(fill = guide_legend())
    }

    ## Return plot
    return(result)
}





#' Extract methylation information from dataframe for visualisation
#'
#' This function takes a dataframe that contains methylation information in the form of
#' locations (indices along the read signifying bases at which modification probability
#' was assessed) and  probabilities (the probability of modification at each assessed
#' location, as an integer from 0 to 255).\cr\cr
#' Each observation/row in the dataframe represents one sequence (e.g. a Nanopore read).
#' In the locations and probabilities column, each sequence (row) has many numbers associated.
#' These are stored as one string per observation e.g. `"3,6,9,12"`, with the column representing
#' a character vector of such strings (e.g. `c("3,6,9,12", "1,2,3,4")`).\cr\cr
#' This function calls [extract_and_sort_sequences()] on the relevant columns and returns
#' a list of vectors stored in `$locations`, `$probabilities`, `$sequences`, and `$lengths`.
#' These can then be used as input for [visualise_methylation()]. \cr\cr
#' Default arguments are set up to work with the included [`example_many_sequences`] data.
#'
#' @param modification_data `dataframe`. A dataframe that must contain columns for methylation locations, methylation probabilities, and sequence length for each read. The former two should be condensed strings as produced by [vector_to_string()] e.g. `"1,2,3,4"`. The latter should be integer.\cr\cr See [`example_many_sequences`] for an example of a compatible dataframe.
#' @param locations_colname `character`. The name of the column within the input dataframe that contains methylation/modification location information. Defaults to `"methylation_locations"`.\cr\cr Values within this column must be a comma-separated string representing a condensed numerical vector (e.g. `"3,6,9,12"`, produced via [vector_to_string()]) of the indices along the read at which modification was assessed. Indexing starts at 1.
#' @param probabilities_colname `character`. The name of the column within the input dataframe that contains methylation/modification probability information. Defaults to `"methylation_probabilities"`.\cr\cr Values within this column must be a comma-separated string representing a condensed numerical vector (e.g. `"2,212,128,64"`, produced via [vector_to_string()]) of the probability of modification as an 8-bit (0-255) integer for each base where modification was assessed.
#' @param sequences_colname `character`. The name of the column within the input dataframe that contains the actual sequences. Defaults to `"sequence"`.\cr\cr Values within this column must be the actual sequences (e.g. `"GGCGGA"`).
#' @param lengths_colname `character`. The name of the column within the input dataframe that contains the length of each sequence. Defaults to `"sequence_length"`.\cr\cr Values within this column must be non-negative integers.
#'
#' @inheritParams extract_and_sort_sequences
#'
#' @return `list`, containing `$locations` (`character vector`), `$probabilities` (`character vector`), `$sequences` (`character vector`), and `$lengths` (`integer vector`).
#'
#' @examples
#' ## See documentation for extract_and_sort_sequences()
#' ## for more examples of changing sorting/grouping
#' extract_methylation_from_dataframe(
#'     example_many_sequences,
#'     locations_colname = "methylation_locations",
#'     probabilities_colname = "methylation_probabilities",
#'     lengths_colname = "sequence_length",
#'     grouping_levels = c("family" = 8, "individual" = 2),
#'     sort_by = "sequence_length",
#'     desc_sort = TRUE
#' )
#'
#' extract_methylation_from_dataframe(
#'     example_many_sequences,
#'     locations_colname = "hydroxymethylation_locations",
#'     probabilities_colname = "hydroxymethylation_probabilities",
#'     lengths_colname = "sequence_length",
#'     grouping_levels = c("family" = 8, "individual" = 2),
#'     sort_by = "sequence_length",
#'     desc_sort = TRUE
#' )
#'
#' @export
extract_methylation_from_dataframe <- function(
    modification_data,
    locations_colname = "methylation_locations",
    probabilities_colname = "methylation_probabilities",
    sequences_colname = "sequence",
    lengths_colname = "sequence_length",
    grouping_levels = c("family" = 8, "individual" = 2),
    sort_by = "sequence_length",
    desc_sort = TRUE
) {
    ## Doesn't need specific argument validation as extract_and_sort_sequences() handles that.

    locations <- extract_and_sort_sequences(modification_data, sequence_variable = locations_colname,
                                            grouping_levels = grouping_levels, sort_by = sort_by, desc_sort = desc_sort)
    probabilities <- extract_and_sort_sequences(modification_data, sequence_variable = probabilities_colname,
                                                grouping_levels = grouping_levels, sort_by = sort_by, desc_sort = desc_sort)
    sequences <- extract_and_sort_sequences(modification_data, sequence_variable = sequences_colname,
                                            grouping_levels = grouping_levels, sort_by = sort_by, desc_sort = desc_sort)
    lengths <- extract_and_sort_sequences(modification_data, sequence_variable = lengths_colname,
                                          grouping_levels = grouping_levels, sort_by = sort_by, desc_sort = desc_sort) %>%
        as.numeric() %>% replace_na(0)

    output <- list(locations = locations, probabilities = probabilities, sequences = sequences, lengths = lengths)
    return(output)
}






#' Convert string-ified modification probabilities and locations to a single vector of probabilities ([visualise_methylation()] helper)
#'
#' Takes modification locations (indices along the read signifying bases at which
#' modification probability was assessed) and modification probabilities (the probability
#' of modification at each assessed location, as an integer from 0 to 255), as comma-separated
#' strings (e.g. `"1,5,25"`) produced from numerical vectors via [vector_to_string()].
#' Outputs a numerical vector of the modification probability for each base along the read.
#' i.e. -2 for indices outside sequences, -1 for bases where modification was not assessed,
#' and probability from 0-255 for bases where modification was assessed.
#'
#' @param modification_locations_str `character`. A comma-separated string representing a condensed numerical vector (e.g. `"3,6,9,12"`, produced via [vector_to_string()]) of the indices along the read at which modification was assessed. Indexing starts at 1.
#' @param modification_probabilities_str `character`. A comma-separated string representing a condensed numerical vector (e.g. `"2,212,128,64"`, produced via [vector_to_string()]) of the probability of modification as an 8-bit (0-255) integer for each base where modification was assessed.
#' @param max_length `integer`. How long the output vector should be.
#' @param sequence_length `integer`. How long the sequence itself is. If smaller than `max_length`, the remaining spaces will be filled with `-2`s i.e. set to the background colour in [visualise_methylation()].
#'
#' @return `numeric vector`. A vector of length `max_length` indicating the probability of methylation at each index along the read - 0 where methylation was not assessed, and probability from 0-255 where methylation was assessed.
#'
#' @examples
#' convert_modification_to_number_vector(
#'     modification_locations_str = "3,6,9,12",
#'     modification_probabilities = "100,200,50,150",
#'     max_length = 15,
#'     sequence_length = 13
#' )
#'
#' @export
convert_modification_to_number_vector <- function(
    modification_locations_str,
    modification_probabilities_str,
    max_length,
    sequence_length
) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    single_not_na_null <- list(modification_locations_str = modification_locations_str, modification_probabilities_str = modification_probabilities_str, max_length = max_length, sequence_length = sequence_length)
    for (argument in names(single_not_na_null)) {
        if (any(is.null(single_not_na_null[[argument]])) || any(is.na(single_not_na_null[[argument]])) || length(single_not_na_null[[argument]]) != 1) {bad_arg(argument, single_not_na_null, "must be a single value, and not NULL or NA.")}
    }
    single_not_na_null <- NULL

    string_to_vector_valid <- list(modification_locations_str = modification_locations_str, modification_probabilities_str = modification_probabilities_str)
    for (argument in names(string_to_vector_valid)) {
        if (!is.character(string_to_vector_valid[[argument]])) {bad_arg(argument, string_to_vector_valid, "must be a character vector.")}
        if (any(is.na(string_to_vector(string_to_vector_valid[[argument]])))) {bad_arg(argument, string_to_vector_valid, "must expand to a numeric vector via string_to_vector().\nCheck that all its values are comma-separated numbers e.g. '1,2,3,4'.")}
    }
    string_to_vector_valid <- NULL

    non_neg_int <- list(sequence_length = sequence_length)
    for (argument in names(non_neg_int)) {
        if (!is.numeric(non_neg_int[[argument]]) || non_neg_int[[argument]] %% 1 != 0 || non_neg_int[[argument]] < 0) {bad_arg(argument, non_neg_int, "must be a non-negative integer.")}
    }
    non_neg_int <- NULL

    pos_int <- list(max_length = max_length)
    for (argument in names(pos_int)) {
        if (!is.numeric(pos_int[[argument]]) || pos_int[[argument]] %% 1 != 0 || pos_int[[argument]] < 0) {bad_arg(argument, pos_int, "must be a positive integer.")}
    }
    pos_int <- NULL
    ## ---------------------------------------------------------------------



    ## Convert input strings to vectors
    locations     <- string_to_vector(modification_locations_str)
    probabilities <- string_to_vector(modification_probabilities_str)

    ## Calculate output vector
    ## If there is no base at all at a position, value is -2
    ## If there is a non-modification-assessed base, value is -1
    ## If there is a modification-assessed base, value is the modification probability
    output_vector <- rep(-2, max_length)
    for (i in 1:max_length) {
        if (i %in% locations) {
            output_vector[i] <- probabilities[which(locations == i)]
        } else if (i <= sequence_length) {
            output_vector[i] <- -1
        }
    }

    ## Return output vector
    return(output_vector)
}



#' Create dataframe of locations and rendered probabilities ([visualise_methylation()] helper)
#'
#' @description
#' This function takes the locations/probabilities/sequences input to [visualise_methylation()],
#' as well as the scaling and rounding to apply to the probability text,
#' and produces a dataframe of the x and y coordinates to draw each probability at
#' (i.e. inside the coloured box for each assessed base)
#' and the probability text to draw inside each box.
#'
#' @inheritParams visualise_methylation
#' @return `dataframe`. Dataframe of `x_position`, `y_position`, `annotation` (i.e. probability to draw), and `type` (always `"Probability"`).
#'
#' @examples
#' d <- extract_methylation_from_dataframe(example_many_sequences)
#'
#' ## Unscaled i.e. integers
#' convert_probabilities_to_annotations(
#'     d$locations,
#'     d$probabilities,
#'     d$sequences,
#'     sequence_text_scaling = c(0, 1),
#'     sequence_text_rounding = 0
#' )
#'
#' ## Scaled to 0-1, 3 dp
#' convert_probabilities_to_annotations(
#'     d$locations,
#'     d$probabilities,
#'     d$sequences,
#'     sequence_text_scaling = c(-0.5, 256),
#'     sequence_text_rounding = 3
#' )
#'
#' ## Default (i.e. scaled to 0-1, 2 dp)
#' convert_probabilities_to_annotations(
#'     d$locations,
#'     d$probabilities,
#'     d$sequences
#' )
#'
#' @export
convert_probabilities_to_annotations <- function(
    modification_locations,
    modification_probabilities,
    sequences,
    sequence_text_scaling = c(-0.5, 256),
    sequence_text_rounding = 2
) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_na_or_null <- list(modification_locations = modification_locations, modification_probabilities = modification_probabilities, sequences = sequences, sequence_text_scaling = sequence_text_scaling, sequence_text_rounding = sequence_text_rounding)
    for (argument in names(not_na_or_null)) {
        if (any(is.null(not_na_or_null[[argument]])) || any(is.na(not_na_or_null[[argument]]))) {bad_arg(argument, not_na_or_null, "must not be NA or NULL.")}
    }
    not_na_or_null <- NULL

    chars <- list(modification_locations = modification_locations, modification_probabilities = modification_probabilities, sequences = sequences)
    for (argument in names(chars)) {
        if (!is.character(chars[[argument]])) {bad_arg(argument, chars, "must be a character vector.")}
    }
    chars <- NULL

    string_to_vector_valid <- list(modification_locations = modification_locations, modification_probabilities = modification_probabilities)
    for (argument in names(string_to_vector_valid)) {
        if (any(is.na(string_to_vector(string_to_vector_valid[[argument]])))) {bad_arg(argument, string_to_vector_valid, "must expand to a numeric vector via string_to_vector().\nCheck that all its values are comma-separated numbers e.g. '1,2,3,4'.")}
    }
    string_to_vector_valid <- NULL

    nums <- list(sequence_text_rounding = sequence_text_rounding, sequence_text_scaling = sequence_text_scaling)
    for (argument in names(nums)) {
        if (!is.numeric(nums[[argument]])) {bad_arg(argument, nums, "must be numeric.")}
    }
    nums <- NULL

    non_neg_single_int <- list(sequence_text_rounding = sequence_text_rounding)
    for (argument in names(non_neg_single_int)) {
        if (length(non_neg_single_int[[argument]]) != 1 || non_neg_single_int[[argument]] %% 1 != 0 || non_neg_single_int[[argument]] < 0) {bad_arg(argument, non_neg_single_int, "must be a single non-negative integer.")}
    }
    non_neg_single_int <- NULL

    length_2 <- list(sequence_text_scaling = sequence_text_scaling)
    for (argument in names(length_2)) {
        if (length(length_2[[argument]]) != 2) {bad_arg(argument, length_2, "must have length 2")}
    }
    length_2 <- NULL
    ## ---------------------------------------------------------------------



    ## Calculate width and height of tiles based on sequences
    tile_width  <- 1/max(nchar(sequences))
    tile_height <- 1/length(sequences)

    probability_data <- data.frame("x_position" = numeric(), "y_position" = numeric(), "annotation" = character(), "type" = character())
    for (i in 1:length(modification_locations)) {
        locations <- string_to_vector(modification_locations[i])
        probabilities <- string_to_vector(modification_probabilities[i])

        ## Scale probabilities as requested
        min <- sequence_text_scaling[1]
        max <- sequence_text_scaling[2]
        scaled_probabilities <- (probabilities - min) / max

        ## If there is an assessed base this line, calculate all coordinates
        if (length(locations) > 0) {
            for (j in 1:length(locations)) {
                x_position <- tile_width * (locations[j] - 1/2)
                y_position <- 1 - tile_height * (i - 1/2)
                annotation <- sprintf(paste0("%.", sequence_text_rounding, "f"), (scaled_probabilities[j]))
                type <- "Probability"
                probability_data <- rbind(probability_data, data.frame(x_position, y_position, annotation, type))
            }
        }
    }
    return(probability_data)
}



## Define aliases
#' @rdname visualise_methylation
#' @usage NULL
#' @export
visualize_methylation <- visualise_methylation

#' @rdname visualise_methylation_colour_scale
#' @usage NULL
#' @export
visualize_methylation_color_scale <- visualise_methylation_colour_scale
