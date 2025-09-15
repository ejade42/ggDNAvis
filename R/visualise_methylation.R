## FOR FUTURE - possibly add in overlaying sequence and/or numbers
## onto methylation visualisation?


#' Visualise methylation probabilities for many DNA sequences
#'
#' This function takes vectors of modifications locations, modification probabilities,
#' and sequence lengths (e.g. created by [extract_methylation_from_dataframe()]) and
#' visualises the probability of methylation (or other modification) across each read.\cr\cr
#' Assumes that the three main input vectors are of equal length *n* and represent *n* sequences
#' (e.g. Nanopore reads), where `locations` are the indices along each read at which modification
#' was assessed, `probabilities` are the probability of modification at each assessed site, and
#' `lengths` are the lengths of each sequence.\cr\cr
#' For each sequence, renders non-assessed (e.g. non-CpG) bases as `other_bases_colour`, renders
#' background (including after the end of the sequence) as `background_colour`, and renders assessed
#' bases on a linear scale from `low_colour` to `high_colour`.\cr\cr
#' Clamping means that the endpoints of the colour gradient can be set some distance into the probability
#' space e.g. with Nanopore > SAM probability values from 0-255, the default is to render 0 as fully blue
#' (`#0000FF`), 255 as fully red (`#FF0000`), and values in between linearly interpolated. However, clamping with
#' `low_clamp = 100` and `high_clamp = 200` would set *all probabilities up to 100* as fully blue,
#' *all probabilities 200 and above* as fully red, and linearly interpolate only over the `100-200` range.\cr\cr
#' A separate scalebar plot showing the colours corresponding to each probability, with any/no clamping values,
#' can be produced via [visualise_methylation_colour_scale()].
#'
#' @param modification_locations `character vector`. One character value for each sequence, storing a condensed string (e.g. `"3,6,9,12"`, produced via [vector_to_string()]) of the indices along the read at which modification was assessed. Indexing starts at 1.
#' @param modification_probabilities `character vector`. One character value for each sequence, storing a condensed string (e.g. `"0,128,255,15"`, produced via [vector_to_string()]) of the probability of methylation/modification at each assessed base.\cr\cr Assumed to be Nanopore > SAM style modification stored as an 8-bit integer from 0 to 255, but changing other arguments could make this work on other scales.
#' @param sequence_lengths `numeric vector`. The length of each sequence.
#' @param low_colour `character`. The colour that should be used to represent minimum probability of methylation/modification (defaults to blue).
#' @param high_colour `character`. The colour that should be used to represent maximum probability of methylation/modification (defaults to red).
#' @param low_clamp `numeric`. The minimum probability below which all values are coloured `low_colour`. Defaults to `0` (i.e. no clamping). To specify a proportion probability in 8-bit form, multiply by 255 e.g. to low-clamp at 30% probability, set this to `0.3*255`.
#' @param high_clamp `numeric`. The maximum probability above which all values are coloured `high_colour`. Defaults to `255` (i.e. no clamping, assuming Nanopore > SAM style modification calling where probabilities are 8-bit integers from 0 to 255).
#' @param background_colour `character`. The colour the background should be drawn (defaults to white).
#' @param other_bases_colour `character`. The colour non-assessed (e.g. non-CpG) bases should be drawn (defaults to grey).
#' @param outline_colour `character`. The colour of the box outlines. Defaults to black.
#' @param outline_linewidth `numeric`. The linewidth of the box outlines. Defaults to `3`. Set to `0` to disable box outlines.
#' @param outline_join `character`. One of `"mitre"`, `"round"`, or `"bevel"` specifying how outlines should be joined at the corners of boxes. Defaults to `"mitre"`. It would be unusual to need to change this.
#' @param modified_bases_outline_colour `character`. If `NA` (default), inherits from `outline_colour`. If not `NA`, overrides `outline_colour` for modification-assessed bases only.
#' @param modified_bases_outline_linewidth `numeric`. If `NA` (default), inherits from `outline_linewidth`. If not `NA`, overrides `outline_linewidth` for modification-assessed bases only.
#' @param modified_bases_outline_join `character`. If `NA` (default), inherits from `outline_join`. If not `NA`, overrides `outline_join` for modification-assessed bases only.
#' @param other_bases_outline_colour `character`. If `NA` (default), inherits from `outline_colour`. If not `NA`, overrides `outline_colour` for non-modification-assessed bases only.
#' @param other_bases_outline_linewidth `numeric`. If `NA` (default), inherits from `outline_linewidth`. If not `NA`, overrides `outline_linewidth` for non-modification-assessed bases only.
#' @param other_bases_outline_join `character`. If `NA` (default), inherits from `outline_join`. If not `NA`, overrides `outline_join` for non-modification-assessed bases only.
#' @param margin `numeric`. The size of the margin relative to the size of each base square. Defaults to `0.5` (half the side length of each base square).
#' @param return `logical`. Boolean specifying whether this function should return the ggplot object, otherwise it will return `invisible(NULL)`. Defaults to `TRUE`.
#' @param filename `character`. Filename to which output should be saved. If set to `NA` (default), no file will be saved. Recommended to end with `".png"`, but can change if render device is changed.
#' @param render_device `function/character`. Device to use when rendering. See [ggplot2::ggsave()] documentation for options. Defaults to [`ragg::agg_png`]. Can be set to `NULL` to infer from file extension, but results may vary between systems.
#' @param pixels_per_base `integer`. How large each box should be in pixels, if file output is turned on via setting `filename`. Corresponds to dpi of the exported image. Defaults to `20`. Low values acceptable as currently this function does not write any text.
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
#'     methylation_info$lengths
#' )
#'
#' ## Export with all defaults rather than returning
#' visualise_methylation(
#'     methylation_info$locations,
#'     methylation_info$probabilities,
#'     methylation_info$lengths,
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
#'     methylation_info$lengths,
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
visualise_methylation <- function(modification_locations, modification_probabilities, sequence_lengths,
                                  low_colour = "blue", high_colour = "red", low_clamp = 0, high_clamp = 255,
                                  background_colour = "white", other_bases_colour = "grey",
                                  outline_colour = "black", outline_linewidth = 3, outline_join = "mitre",
                                  modified_bases_outline_colour = NA, modified_bases_outline_linewidth = NA, modified_bases_outline_join = NA,
                                  other_bases_outline_colour = NA, other_bases_outline_linewidth = NA, other_bases_outline_join = NA,
                                  margin = 0.5, return = TRUE, filename = NA, render_device = ragg::agg_png, pixels_per_base = 20) {
    ## Validate arguments
    for (argument in list(modification_locations, modification_probabilities, sequence_lengths, background_colour, other_bases_colour, low_colour, high_colour, low_clamp, high_clamp, outline_linewidth, outline_colour, outline_join, modified_bases_outline_linewidth, modified_bases_outline_colour, modified_bases_outline_join, other_bases_outline_linewidth, other_bases_outline_colour, other_bases_outline_join, margin, return, filename, pixels_per_base)) {
        if (mean(is.null(argument)) != 0) {abort(paste("Argument", argument, "must not be null."), class = "argument_value_or_type")}
    }
    for (argument in list(background_colour, other_bases_colour, low_colour, high_colour, low_clamp, high_clamp, outline_linewidth, outline_colour, outline_join, modified_bases_outline_linewidth, modified_bases_outline_colour, modified_bases_outline_join, other_bases_outline_linewidth, other_bases_outline_colour, other_bases_outline_join, margin, return, filename, pixels_per_base)) {
        if (length(argument) != 1) {abort(paste("Argument", argument, "must have length 1."), class = "argument_value_or_type")}
    }
    for (argument in list(modification_locations, modification_probabilities, sequence_lengths, background_colour, other_bases_colour, low_colour, high_colour, low_clamp, high_clamp, margin, return, pixels_per_base)) {
        if (mean(is.na(argument)) != 0) {abort(paste("Argument", argument, "must not be NA."), class = "argument_value_or_type")}
    }
    for (argument in list(background_colour, other_bases_colour, low_colour, high_colour, outline_colour, modified_bases_outline_colour, other_bases_outline_colour)) {
        if (is.na(argument) == FALSE && (is.character(argument) == FALSE || length(argument) != 1)) {abort(paste("All colours must be single character values.", argument, "is not valid."), class = "argument_value_or_type")}
    }
    for (argument in list(low_clamp, high_clamp, margin, pixels_per_base, outline_linewidth, modified_bases_outline_linewidth, other_bases_outline_linewidth)) {
        if (is.na(argument) == FALSE && (is.numeric(argument) == FALSE || length(argument) != 1)) {abort(paste("Argument", argument, "must be a single numeric value."), class = "argument_value_or_type")}
    }
    for (argument in list(pixels_per_base)) {
        if (argument %% 1 != 0 || argument < 1) {abort(paste("Argument", argument, "must be a positive integer."), class = "argument_value_or_type")}
    }
    for (argument in list(return)) {
        if (is.logical(argument) == FALSE || length(argument) != 1) {abort(paste("Argument", argument, "must be a single logical/boolean value."), class = "argument_value_or_type")}
    }
    if (length(modification_locations) != length(modification_probabilities) ||
        length(modification_locations) != length(sequence_lengths) ||
        length(modification_probabilities) != length(sequence_lengths)) {
        abort("Modification locations, modification probabilities, and sequence lengths must all be the same length", class = "argument_value_or_type")
    }
    for (argument in list(modification_locations, modification_probabilities)) {
        if (is.character(argument) == FALSE) {abort("Modification locations and probabilities must both be character vectors.", class = "argument value or type.")}
        if (mean(is.na(string_to_vector(argument))) != 0) {abort("Modification locations and probabilities must both expand to numeric vectors via string_to_vector(). Check that the values within these inputs are comma-separated numbers e.g. '1,2,3,4'.", class = "argument_value_or_type")}
    }
    for (argument in list(sequence_lengths)) {
        if (is.numeric(argument) == FALSE) {abort("Sequence lengths vector must be numeric.", class = "argument_value_or_type")}
    }
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
            abort("All outline join arguments must be one of 'mitre', 'round', or 'bevel'.", class = "argument_value_or_type")
        }
    }
    ## Warn about margin
    if (margin <= 0.25 && (modified_bases_outline_linewidth > 0 || other_bases_outline_linewidth > 0)) {
        warn("If margin is small and outlines are on (outline_linewidth > 0), outlines may be cut off at the edges of the plot. Check if this is happening and consider using a bigger margin.", class = "parameter_recommendation")
    }
    ## Check clamping values
    if (low_clamp >= high_clamp) {
        abort("Low clamp value must be strictly less than high clamp value", class = "argument_value_or_type")
    }
    ## Accept NA as NULL for render_device
    if (is.atomic(render_device) && any(is.na(render_device))) {render_device <- NULL}


    ## Generate rasterised dataframes of methylation and masking layer
    max_length <- max(sequence_lengths)
    image_matrix <- matrix(NA, nrow = length(modification_locations), ncol = max_length)
    for (i in 1:length(modification_locations)) {
        numeric_sequence_representation <- convert_modification_to_number_vector(modification_locations[i], modification_probabilities[i], max_length, sequence_lengths[i])
        image_matrix[i, ] <- numeric_sequence_representation
    }
    image_data <- raster::as.data.frame(raster::raster(image_matrix), xy = TRUE)

    ## Transform image data if clamping limits are set
    image_data$clamped_layer <- pmin(pmax(image_data$layer, low_clamp), high_clamp)

    tile_width  <- 1/max(sequence_lengths)
    tile_height <- 1/length(sequence_lengths)


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
        theme(plot.background = element_rect(fill = background_colour, colour = NA),
              axis.title = element_blank(), plot.margin = grid::unit(c(margin, margin, margin, margin), "inches"))


    ## Validate filename and export image
    if (is.na(filename) == FALSE) {
        if (is.character(filename) == FALSE) {
            abort("Filename must be a character/string (or NA if no file export wanted)", class = "argument_value_or_type")
        }
        if (tolower(substr(filename, nchar(filename)-3, nchar(filename))) != ".png") {
            warn("Not recommended to use non-png filetype (but may still work).", class = "filetype_recommendation")
        }
        ggsave(filename, plot = result, dpi = pixels_per_base, device = render_device, width = max(sequence_lengths)+(2*margin), height = length(sequence_lengths)+(2*margin), limitsize = FALSE)
    }

    ## Return either the plot object or NULL
    if (return == TRUE) {
        return(result)
    }
    return(invisible(NULL))
}



#' Visualise methylation colour scalebar
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
#' @param low_colour `character`. The colour that should be used to represent minimum probability of methylation/modification (defaults to blue).
#' @param high_colour `character`. The colour that should be used to represent maximum probability of methylation/modification (defaults to red).
#' @param low_clamp `numeric`. The minimum probability below which all values are coloured `low_colour`. Defaults to `0` (i.e. no clamping).
#' @param high_clamp `numeric`. The maximum probability above which all values are coloured `high_colour`. Defaults to `255` (i.e. no clamping, assuming Nanopore > SAM style modification calling where probabilities are 8-bit integers from 0 to 255).
#' @param full_range `numeric vector`, length 2. The total range of possible probabilities. Defaults to `c(0, 255)`, which is appropriate for Nanopore > SAM style modification calling where probabilities are 8-bit integers from 0 to 255.\cr\cr May need to be set to `c(0, 1)` if probabilites are instead stored as decimals. Setting any other value is advanced use and should be done for a good reason.
#' @param precision `integer`. How many different shades should be rendered. Larger values give a smoother gradient. Defaults to `10^3` i.e. `1000`, which looks smooth to my eyes and isn't too intensive to calculate.
#' @param background_colour `character`. The colour the background should be drawn (defaults to white).
#' @param x_axis_title `character`. The desired x-axis title. Defaults to `NULL`.
#' @param do_x_ticks `logical`. Boolean specifying whether x axis ticks should be enabled (`TRUE`, default) or disabled (`FALSE`).
#' @param do_side_scale `logical`. Boolean specifying whether a smaller scalebar should be rendered on the right. Defaults to `FALSE`.\cr\cr I think it is unlikely anyone would want to use this, but the option is here. One potential usecase is that this scalebar shows the raw probability values (e.g. 0 to 255), whereas the x-axis is normalised to 0-1.
#' @param side_scale_title `character`. The desired title for the right-hand scalebar, if turned on. Defaults to `NULL`.
#' @param outline_colour `character`. The colour of the scalebar outline. Defaults to black.
#' @param outline_linewidth `numeric`. The linewidth of the scalebar outline. Defaults to `1`. Set to `0` to disable scalebar outline.
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
visualise_methylation_colour_scale <- function(low_colour = "blue", high_colour = "red", low_clamp = 0, high_clamp = 255, full_range = c(0, 255), precision = 10^3,
                                               background_colour = "white", x_axis_title = NULL, do_x_ticks = TRUE, do_side_scale = FALSE, side_scale_title = NULL,
                                               outline_colour = "black", outline_linewidth = 1) {
    ## Validate arguments
    for (argument in list(low_colour, high_colour, low_clamp, high_clamp, full_range, precision, background_colour, do_x_ticks, do_side_scale, outline_colour, outline_linewidth)) {
        if (mean(is.null(argument)) != 0 || mean(is.na(argument)) != 0) {abort(paste("Argument", argument, "must not be null or NA."), class = "argument_value_or_type")}
    }
    for (argument in list(low_colour, high_colour, low_clamp, high_clamp, precision, background_colour, x_axis_title, do_x_ticks, do_side_scale, side_scale_title, outline_colour, outline_linewidth)) {
        if (mean(is.null(argument)) == 0 && length(argument) != 1) {abort(paste("Argument", argument, "must have length 1"), class = "argument_value_or_type")}
    }
    for (argument in list(background_colour, low_colour, high_colour, outline_colour)) {
        if (is.character(argument) == FALSE || length(argument) != 1) {abort(paste("All colours must be single character values.", argument, "is not valid."), class = "argument_value_or_type")}
    }
    for (argument in list(low_clamp, high_clamp, full_range, precision, outline_linewidth)) {
        if (is.numeric(argument) == FALSE) {abort(paste("Argument", argument, "must be numeric."), class = "argument_value_or_type")}
    }
    for (argument in list(do_x_ticks, do_side_scale)) {
        if (is.logical(argument) == FALSE) {abort(paste("Argument", argument, "must be logical/boolean"), class = "argument_value_or_type")}
    }
    for (argument in list(x_axis_title, side_scale_title)) {
        if (mean(is.null(argument)) == 0 && mean(is.na(argument)) == 0) {
            if (is.character(argument) == FALSE) {abort(paste("Argument", argument, "must be a character value, or NA/NULL."), class = "argument_value_or_type")}
        }
    }
    if (length(full_range) != 2) {abort("Must provide two numeric values e.g. c(0, 255) as the full probability range", class = "argument_value_or_type")}
    if (mean(full_range == c(0, 255)) != 1 && mean(full_range == c(0, 1)) != 1) {
        warn("It is unusual to set full probabality range to something other than 0-255 or 0-1. Make sure you know what you're doing.", class = "parameter_recommendation")
    }
    ## Check clamping values
    if (low_clamp >= high_clamp) {
        abort("Low clamp value must be strictly less than high clamp value", class = "argument_value_or_type")
    }

    ## Accept NA as meaning NULL for titles
    if (mean(is.null(x_axis_title)) == 0 && mean(is.na(x_axis_title)) != 0) {x_axis_title <- NULL}
    if (mean(is.null(side_scale_title)) == 0 && mean(is.na(side_scale_title)) != 0) {side_scale_title <- NULL}


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
#' This function calls [extract_and_sort_sequences()] on each of these three columns and returns
#' a list of vectors stored in `$locations`, `$probabilities`, and `$lengths`.
#' These can then be used as input for [visualise_methylation()]. \cr\cr
#' Default arguments are set up to work with the included [`example_many_sequences`] data.
#'
#' @param modification_data `dataframe`. A dataframe that must contain columns for methylation locations, methylation probabilities, and sequence length for each read. The former two should be condensed strings as produced by [vector_to_string()] e.g. `"1,2,3,4"`. The latter should be integer.\cr\cr See [`example_many_sequences`] for an example of a compatible dataframe.
#' @param locations_colname `character`. The name of the column within the input dataframe that contains methylation/modification location information. Defaults to `"methylation_locations"`.\cr\cr Values within this column must be a comma-separated string representing a condensed numerical vector (e.g. `"3,6,9,12"`, produced via [vector_to_string()]) of the indices along the read at which modification was assessed. Indexing starts at 1.
#' @param probabilities_colname `character`. The name of the column within the input dataframe that contains methylation/modification probability information. Defaults to `"methylation_probabilities"`.\cr\cr Values within this column must be a comma-separated string representing a condensed numerical vector (e.g. `"2,212,128,64"`, produced via [vector_to_string()]) of the probability of modification as an 8-bit (0-255) integer for each base where modification was assessed.
#' @param lengths_colname `character`. The name of the column within the input dataframe that contains the length of each sequence. Defaults to `"sequence_length"`.\cr\cr Values within this column must be non-negative integers.
#' @param grouping_levels `named character vector`. What variables should be used to define the groups/chunks, and how large a gap should be left between groups at that level. Set to `NA` to turn off grouping.\cr\cr Defaults to `c("family" = 8, "individual" = 2)`, meaning the highest-level groups are defined by the `family` column, and there is a gap of 8 between each family. Likewise the second-level groups (within each family) are defined by the `individual` column, and there is a gap of 2 between each individual.\cr\cr Any number of grouping variables and gaps can be given, as long as each grouping variable is a column within the dataframe. It is recommended that lower-level groups are more granular and subdivide higher-level groups (e.g. first divide into families, then into individuals within families). \cr\cr To change the order of groups within a level, make that column a factor with the order specified e.g. `example_many_sequences$family <- factor(example_many_sequences$family, levels = c("Family 2", "Family 3", "Family 1"))` to change the order to Family 2, Family 3, Family 1.
#' @param sort_by `character`. The name of the column within the dataframe that should be used to sort/order the rows within each lowest-level group. Set to `NA` to turn off sorting within groups.\cr\cr Recommended to be the length of the sequence information, as is the case for the default `"sequence_length"` which was generated via `example_many_sequences$sequence_legnth <- nchar(example_many_sequences$sequence)`.
#' @param desc_sort `logical`. Boolean specifying whether rows within groups should be sorted by the `sort_by` variable descending (`TRUE`, default) or ascending (`FALSE`).
#'
#' @return `list`, containing `$locations` (`character vector`), `$probabilities` (`character vector`), and `$lengths` (`numeric vector`).
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
extract_methylation_from_dataframe <- function(modification_data,
                                               locations_colname = "methylation_locations",
                                               probabilities_colname = "methylation_probabilities",
                                               lengths_colname = "sequence_length",
                                               grouping_levels = c("family" = 8, "individual" = 2),
                                               sort_by = "sequence_length", desc_sort = TRUE) {
    ## Doesn't need specific argument validation as extract_and_sort_sequences() handles that.

    locations <- extract_and_sort_sequences(modification_data, sequence_variable = locations_colname,
                                            grouping_levels = grouping_levels, sort_by = sort_by, desc_sort = desc_sort)
    probabilities <- extract_and_sort_sequences(modification_data, sequence_variable = probabilities_colname,
                                                grouping_levels = grouping_levels, sort_by = sort_by, desc_sort = desc_sort)
    lengths <- extract_and_sort_sequences(modification_data, sequence_variable = lengths_colname,
                                          grouping_levels = grouping_levels, sort_by = sort_by, desc_sort = desc_sort) %>%
        as.numeric() %>% replace_na(0)

    output <- list(locations = locations, probabilities = probabilities, lengths = lengths)
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
convert_modification_to_number_vector <- function(modification_locations_str, modification_probabilities_str, max_length, sequence_length) {
    ## Validate arguments
    for (argument in list(modification_locations_str, modification_probabilities_str, max_length, sequence_length)) {
        if (mean(is.null(argument)) != 0 || mean(is.na(argument)) != 0 || length(argument) != 1) {
            abort("Argument", argument, "must be a single value, and not NULL or NA", class = "argument_value_or_type")
        }
    }
    for (argument in list(modification_locations_str, modification_probabilities_str)) {
        if (is.character(argument) == FALSE) {abort("Modification locations and probabilities must both be character vectors.", class = "argument value or type.")}
        if (argument != "" && mean(is.na(string_to_vector(argument))) != 0) {abort("Modification locations and probabilities must both expand to numeric vectors via string_to_vector(). Check that the values within these inputs are comma-separated numbers e.g. '1,2,3,4'.", class = "argument_value_or_type")}
    }
    for (argument in list(max_length, sequence_length)) {
        if (is.numeric(argument) == FALSE || argument %% 1 != 0 || argument < 0) {abort(paste("Argument", argument, "must be a non-negative integer."), class = "argument_value_or_type")}
    }
    for (argument in list(max_length)) {
        if (is.numeric(argument) == FALSE || argument %% 1 != 0 || argument < 1) {abort("Max length must be a positive integer.", class = "argument_value_or_type")}
    }


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
