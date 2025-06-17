## MAIN FUCNTION FOR VISUALISING ONE DNA/RNA
## SEQUENCE SPLIT ACROSS MULTIPLE LINES


#' Visualise a single DNA/RNA sequence
#'
#' This function takes a DNA/RNA sequence and returns a ggplot
#' visualising it, with the option to directly export a png image
#' with appropriate dimensions. Colours, line wrapping, index annotation
#' interval, and pixels per square when exported are configurable.
#'
#' @param sequence `character`. A DNA or RNA sequence to visualise e.g. `"AAATGCTGC"`.
#' @param sequence_colours `character vector`, length 4. A vector indicating which colours should be used for each base. In order: `c(A_colour, C_colour, G_colour, TU_colour)`. Defaults to red, green, blue, purple (in the default shades produced by ggplot with 4 colours).
#' @param background_colour `character`. The colour of the background. Defaults to white.
#' @param sequence_text_colour `character`. The colour of the text within the bases (e.g. colour of "A" letter within boxes representing adenosine bases). Defaults to black.
#' @param sequence_text_size `numeric`. The size of the text within the bases (e.g. size of "A" letter within boxes representing adenosine bases). Defaults to `16`. Set to `0` to hide sequence text (show box colours only).
#' @param index_annotation_colour `character`. The colour of the little numbers underneath indicating base index (e.g. colour "15" label under the 15th base). Defaults to dark red.
#' @param index_annotation_size `numeric`. The size of the little number underneath indicating base index (e.g. size of "15" label under the 15th base). Defaults to `12.5`. Set to `0` to turn off annotations (or set `index_annotation_interval = 0`).
#' @param index_annotation_interval `integer`. The frequency at which numbers should be placed underneath indicating base index, starting counting from the leftmost base in each row. Defaults to `15` (every 15 bases along each row). Recommended to make this a factor/divisor of the line wrapping length (meaning the final base in each line is annotated), otherwise the numbering interval resetting at the beginning of each row will result in uneven intervals at each line break. Set to `0` to turn off annotations (or set `index_annotation_size = 0`).
#' @param line_wrapping `integer`. The number of bases that should be on each line before wrapping. Defaults to `75`. Recommended to make this a multiple of the repeat unit size (e.g. 3*n* for a trinucleotide repeat) if visualising a repeat sequence.
#' @param spacing `integer`. The number of blank lines between each line of sequence. Defaults to `1`. Be careful when setting to `0` as this means annotations have no space so might render strangely. Recommended to set one of `index_annotation_<interval/size> = 0` if doing so.
#' @param return `logical`. Boolean specifying whether this function should return the ggplot object, otherwise it will return `NULL`. Defaults to `TRUE`.
#' @param save `logical`. Boolean specifying whether this function should save the plot to a file. Defaults to `FALSE`.
#' @param filename `character`. Filename to which output should be saved, if `save = TRUE`. Recommended to end with .png but might work with other extensions if they are compatible with ggsave(). Defaults to `"image.png"`.
#' @param pixels_per_base `integer`. How large each box should be in pixels, if `save = TRUE`. Corresponds to dpi of the exported image. Large values recommended because text needs to be legible when rendered significantly smaller than a box. Defaults to `100`.
#'
#' @return A ggplot object containing the full visualisation, or `NULL` if `return = FALSE`. It is often more useful to use `save = TRUE` and `filename = "myfilename.png"`, because then the visualisation is exported at the correct aspect ratio.
#' @export
visualise_single_sequence <- function(sequence, sequence_colours = c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF"), background_colour = "white",
                                      sequence_text_colour = "black", sequence_text_size = 16, index_annotation_colour = "darkred", index_annotation_size = 12.5,
                                      index_annotation_interval = 15, line_wrapping = 75, spacing = 1, return = TRUE, save = FALSE, filename = "image.png", pixels_per_base = 100) {
    ## Validate arguments
    if (length(sequence) > 1) {abort("Can only visualise one sequence at once.", class = "argument_length")}
    if (length(sequence_colours) != 4) {abort("Must provide exactly 4 sequence colours, in A C G T order.", class = "argument_length")}
    for (argument in c(sequence_text_size, index_annotation_size, index_annotation_interval, spacing, pixels_per_base)) {
        if (is.numeric(argument) == FALSE || argument < 0) {abort(paste("Argument", argument, "must be numeric and non-negative."), class = "argument_value_or_type")}
    }
    for (argument in c(line_wrapping, spacing, pixels_per_base)) {
        if (argument %% 1 != 0) {abort(paste("Argument", argument, "must be an integer."), class = "argument_value_or_type")}
    }
    for (argument in c(line_wrapping, pixels_per_base)) {
        if (argument < 1) {abort(paste("Argument", argument, "must be at least 1."), class = "argument_value_or_type")}
    }
    for (argument in c(return, save)) {
        if (is.logical(argument) == FALSE) {abort(paste("Argument:", argument, "must be a logical/boolean value."), class = "argument_value_or_type")}
    }
    if (tolower(substr(filename, nchar(filename)-3, nchar(filename))) != ".png") {
        warn("Not recommended to use non-png filetype (but may still work).", class = "filetype_recommendation")
    }
    if (spacing == 0 && !(index_annotation_size == 0 || index_annotation_interval == 0)) {
        warn("Using spacing = 0 without disabling index annotation is not recommended.\nIt is likely to draw the annotations overlapping the sequence.\nRecommended to set one of index_annotation_<interval/size> = 0 to disable index annotations.", class = "parameter_recommendation")
    }


    sequences <- convert_input_seq_to_sequence_list(sequence, line_wrapping, spacing)
    if (max(nchar(sequences)) < line_wrapping) {line_wrapping <- max(nchar(sequences))}
    annotations <- convert_sequences_to_annotations(sequences, line_wrapping, index_annotation_interval)
    image_data <- create_image_data(sequences)

    colours <- c(background_colour, sequence_colours)
    names(colours) <- as.character(0:4)

    result <- plot_single_sequence(image_data, colours) +
        geom_text(data = annotations, aes(x = x_position, y = y_position, label = annotation, col = type, size = type), fontface = "bold", inherit.aes = F) +
        scale_colour_manual(values = c("Number" = index_annotation_colour, "Sequence" = sequence_text_colour)) +
        scale_discrete_manual("size", values = c("Number" = index_annotation_size, "Sequence" = sequence_text_size)) +
        guides(col = "none", size = "none") +
        theme(plot.background = element_rect(fill = background_colour, colour = NA))

    if (save == TRUE) {
        ggsave(filename, plot = result, dpi = pixels_per_base, width = max(nchar(sequences))+1, height = length(sequences)+0.5, limitsize = FALSE)
    }

    if (return == TRUE) {
        return(result)
    }

    return(NULL)
}


## UNIQUE HELPER FUNCTIONS
## "Missing" functions are likely in dna_tools.R as they are common to multiple visualisations


#' Split a single input sequence into a vector of "lines" for visualisation
#'
#' Takes a single input sequence and an integer line length, and splits the input
#' sequence into lines of that length (with the last line potentially being shorter). \cr\cr
#' Optionally inserts empty strings `""` after each line to space them out.
#'
#' @param input_seq `character`. A DNA/RNA sequence (or for the purposes of this function, any string, though only DNA/RNA will work with later functions) to be split up.
#' @param line_length `integer`. How long each line (split-up section) should be.
#' @param spacing `integer`. How many blank lines to leave after each line of sequence. Defaults to `0`.
#'
#' @return `character vector`. The input sequence split into multiple lines, with specified spacing in between.
#' @export
convert_input_seq_to_sequence_list <- function(input_seq, line_length, spacing = 1) {
    if (is.numeric(line_length) == FALSE || line_length %% 1 != 0 || line_length < 1 ||
        is.numeric(spacing) == FALSE     || spacing %% 1 != 0     || spacing < 0) {
        abort("Line length must be a positive integer and spacing must be a non-negative integer", class = "argument_value_or_type")
    }

    sequences <- NULL
    full_rows <- nchar(input_seq) %/% line_length
    if (full_rows > 0) {
        for (i in 1:full_rows) {
            start <- (i-1)*line_length + 1
            stop  <- i*line_length
            line <- substr(input_seq, start, stop)
            sequences <- c(sequences, line, rep("", spacing))
        }
    }
    start <- full_rows*line_length + 1
    stop  <- nchar(input_seq)
    line <- substr(input_seq, start, stop)
    sequences <- c(sequences, line, rep("", spacing))

    return(sequences)
}



#' Convert a vector of sequences to a dataframe for plotting sequence contents and index annotations
#'
#' Takes the sequence list output from `convert_input_seq_to_sequence_list()` and creates a dataframe
#' specifying x and y coordinates and the character to plot at each coordinate. This applies to both
#' the sequence itself (e.g. determining where on the plot to place an `"A"`) and the periodicit
#' annotations of index number (e.g. determining where on the plot to annotate base number `15`).
#'
#' @param sequences `character vector`. Sequence to be plotted, split into lines and optionally including blank spacer lines. Output of `convert_input_seq_to_sequence_list()`.
#' @param line_length `integer`. How long each line should be.
#' @param interval `integer`. How frequently bases should be annotated with their index. Defaults to `15`.
#'
#' @return `dataframe` Dataframe of coordinates and labels (e.g. `"A"` or `"15`), readable by geom_text.
#' @export
convert_sequences_to_annotations <- function(sequences, line_length, interval = 15) {
    if (is.numeric(line_length) == FALSE || line_length %% 1 != 0 || line_length < 1 ||
        is.numeric(interval) == FALSE    || interval %% 1 != 0    || interval < 0) {
        abort("Line length must be a positive integer and annotation interval must be a non-negative integer", class = "argument_value_or_type")
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
                x_position <- x_interval * j - x_interval/2
                y_position <- 1 - (y_interval * i - y_interval/2)
                annotation <- substr(sequences[i], j, j)
                type <- "Sequence"
                annotation_data <- rbind(annotation_data, c(x_position, y_position, annotation, type))

                ## Annotate numbers every <interval> bases
                if (interval != 0 && j %% interval == 0) {
                    x_position <- x_interval * j - x_interval/2
                    y_position <- 1 - (y_interval * (i+1) - y_interval*2/3)
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



## Uses numerical encoding of sequence to produce image data via raster::raster()
## Then plots this in ggplot2, using user-specified colours
## 0 is background, 1 is A, 2 is C, 3 is G, and 4 is T



#' Create intermediate geom_tile plot of a single sequence
#'
#' Takes rasterised image data from `create_image_data()` and a set of colours
#' and returns a ggplot (via geom_tile). However, this is intermediate and is
#' further modified e.g. by adding annotations in `visualise_single_sequence()`, so
#' this function should only be used directly if you require more specific customisation.
#'
#' @param image_data `dataframe` Rasterised dataframe representing sequence information numerically. Output of `create_image_data()`.
#' @param colours `character vector`, length 5. Expects a named vector specifying colour for background, A, C, G, T/U in that order. Easier to customise in `visualise_single_sequence()` as formatting requirements are less strict.
#'
#' @return `ggplot` ggplot via geom_tile, of the single sequence split across multiple lines. Formatting will be better if accessed via `visualise_single_sequence()`, but this function is made available for use cases where greater flexibility is required.
#' @export
plot_single_sequence <- function(image_data, colours = c("0" = "white", "1" = "#F8766D", "2" = "#7CAE00", "3" = "#00BFC4", "4" = "#C77CFF")) {
    plot <- ggplot(image_data, aes(x = x, y = y, fill = as.character(layer))) +
        geom_tile() +
        scale_fill_manual(values = colours) +
        guides(x = "none", y = "none", fill = "none") +
        theme(axis.title = element_blank(), plot.margin = grid::unit(c(0.5, 0.5, 0, 0.5), "inches")) +
        scale_x_continuous(expand = c(0, 0)) +
        scale_y_continuous(expand = c(0, 0))

    return(plot)
}
