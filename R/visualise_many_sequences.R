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
visualise_many_sequences <- function(sequences_vector, sequence_colours = sequence_colour_palettes$ggplot_style, background_colour = "white",
                                     margin = 0.5, sequence_text_colour = "black", sequence_text_size = 16,
                                     outline_colour = "black", outline_linewidth = 3, outline_join = "mitre",
                                     return = TRUE, filename = NA, render_device = ragg::agg_png, pixels_per_base = 100) {
    ## Validate arguments
    for (argument in list(sequences_vector, sequence_colours, background_colour, margin, sequence_text_colour, sequence_text_size, outline_colour, outline_linewidth, outline_join, return, filename, pixels_per_base)) {
        if (mean(is.null(argument)) != 0) {abort(paste("Argument", argument, "must not be null."), class = "argument_value_or_type")}
    }
    for (argument in list(background_colour, margin, sequence_text_colour, sequence_text_size, outline_colour, outline_linewidth, outline_join, return, filename, pixels_per_base)) {
        if (length(argument) != 1) {abort(paste("Argument", argument, "must have length 1"), class = "argument_value_or_type")}
    }
    for (argument in list(sequences_vector, sequence_colours, background_colour, margin, sequence_text_colour, sequence_text_size, outline_colour, outline_linewidth, outline_join, return, pixels_per_base)) {
        if (mean(is.na(argument)) != 0) {abort(paste("Argument", argument, "must not be NA"), class = "argument_value_or_type")}
    }
    if (is.character(sequence_colours) == FALSE || length(sequence_colours) != 4) {
        abort("Must provide exactly 4 sequence colours, in A C G T order, as a length-4 character vector.", class = "argument_value_or_type")
    }
    for (argument in list(sequences_vector, background_colour, sequence_text_colour, outline_colour, outline_join)) {
        if (is.character(argument) == FALSE) {abort(paste("Argument", argument, "must be a character/string."), class = "argument_value_or_type")}
    }
    for (argument in list(margin, sequence_text_size, outline_linewidth)) {
        if (is.numeric(argument) == FALSE || argument < 0) {
            abort(paste("Argument", argument, "must be a non-negative number"), class = "argument_value_or_type")
        }
    }
    for (argument in list(pixels_per_base)) {
        if (is.numeric(argument) == FALSE || argument %% 1 != 0 || argument < 1) {
            abort("pixels_per_base must be a positive integer", class = "argument_value_or_type")
        }
    }
    for (argument in list(return)) {
        if (is.logical(argument) == FALSE) {abort(paste("Argument:", argument, "must be a logical/boolean value."), class = "argument_value_or_type")}
    }
    if (!(tolower(outline_join) %in% c("mitre", "round", "bevel"))) {
        abort("outline_join must be one of 'mitre', 'round', or 'bevel'.", class = "argument_value_or_type")
    }
    ## Warn about outlines getting cut off
    if (margin <= 0.25 && outline_linewidth > 0) {
        warn("If margin is small and outlines are on (outline_linewidth > 0), outlines may be cut off at the edges of the plot. Check if this is happening and consider using a bigger margin.", class = "parameter_recommendation")
    }
    ## Accept NA as NULL for render_device
    if (is.atomic(render_device) && any(is.na(render_device))) {render_device <- NULL}


    ## Generate data for plotting
    image_data <- create_image_data(sequences_vector)
    annotations <- convert_sequences_to_annotations(sequences_vector, line_length = max(nchar(sequences_vector)), interval = 0)

    ## Name the sequence colours vector
    names(sequence_colours) <- as.character(1:4)

    ## Calculate tile dimensions
    tile_width  <- 1/max(nchar(sequences_vector))
    tile_height <- 1/length(sequences_vector)

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
        theme(plot.background = element_rect(fill = background_colour, colour = NA),
              axis.title = element_blank(), plot.margin = grid::unit(c(margin, margin, margin, margin), "inches"))

    ## Add sequence text if desired
    if (sequence_text_size != 0) {
        result <- result +
            geom_text(data = annotations, aes(x = .data$x_position, y = .data$y_position, label = .data$annotation), col = sequence_text_colour, size = sequence_text_size, fontface = "bold", inherit.aes = F) +
            guides(col = "none", size = "none")
    }

    ## Check if filename is set and warn if not png, then export image
    if (is.na(filename) == FALSE) {
        if (is.character(filename) == FALSE) {
            abort("Filename must be a character/string (or NA if no file export wanted)", class = "argument_value_or_type")
        }
        if (tolower(substr(filename, nchar(filename)-3, nchar(filename))) != ".png") {
            warn("Not recommended to use non-png filetype (but may still work).", class = "filetype_recommendation")
        }
        ggsave(filename, plot = result, dpi = pixels_per_base, device = render_device, width = max(nchar(sequences_vector))+(2*margin), height = length(sequences_vector)+(2*margin), limitsize = FALSE)
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
extract_and_sort_sequences <- function(sequence_dataframe, sequence_variable = "sequence",
                                       grouping_levels = c("family" = 8, "individual" = 2),
                                       sort_by = "sequence_length", desc_sort = TRUE) {
    ## Validate arguments
    for (argument in list(sequence_dataframe, sequence_variable, grouping_levels, sort_by, desc_sort)) {
        if (mean(is.null(argument)) != 0) {abort(paste("Argument", argument, "must not be null."), class = "argument_value_or_type")}
    }
    if (mean(is.na(grouping_levels)) == 0 && mean(is.null(names(grouping_levels))) != 0) {
        abort("grouping_levels must be a named vector", class = "argument_value_or_type")
    }
    for (argument in list(sequence_variable, sort_by, desc_sort)) {
        if (length(argument) != 1) {abort(paste("Argument", argument, "must have length 1"), class = "argument_value_or_type")}
    }
    for (argument in list(sequence_variable, desc_sort)) {
        if (mean(is.na(argument)) != 0) {abort(paste("Argument", argument, "must not be NA"), class = "argument_value_or_type")}
    }
    if (mean(is.na(grouping_levels) == 0)) {
        for (level in names(grouping_levels)) {
            if (level %in% colnames(sequence_dataframe) == FALSE  || is.character(level) == FALSE) {
                abort(paste0("grouping_levels must be a named numeric vector where all the names are columns in the input dataframe.\nCurrently '", level, "' is given as a grouping level name but is not a column in sequence_dataframe."), class = "argument_value_or_type")
            }
        }
        if (is.numeric(grouping_levels) == FALSE) {
            abort("grouping_levels must be a named numeric vector. Currently the values are not numeric", class = "argument_value_or_type")
        }
    }
    if (mean(is.na(grouping_levels)) != 0 && length(grouping_levels) > 1) {
        abort("if setting grouping_levels to NA, must provide a single NA rather than a vector of multiple values including NA.")
    }
    for (argument in list(sequence_variable, sort_by)) {
        if (is.na(argument) == FALSE && (argument %in% colnames(sequence_dataframe) == FALSE || is.character(argument) == FALSE)) {
            abort(paste("Argument", argument, "must be a single character value and the name of a column within sequence_dataframe."), class = "argument_value_or_type")
        }
    }
    for (argument in list(desc_sort)) {
        if (is.logical(argument) == FALSE) {
            abort("desc_sort must be a logical/boolean value.", class = "argument_value_or_type")
        }
    }



    ## Initialise
    sequence_dataframe <- as.data.frame(sequence_dataframe)
    sequence_variable  <- sym(sequence_variable)

    ## If grouping is off entirely, return sequences raw/sorted without breaks
    if (mean(is.na(grouping_levels)) != 0) {
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
