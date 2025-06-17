## MAIN USER-FACING FUNCTION

#' Visualise a DNA/RNA sequence
#'
#' This function takes a DNA/RNA sequence and returns a ggplot
#' visualising it, with the option to directly export a png image
#' with appropriate dimensions. Colours, line wrapping, numbering
#' interval, and pixels per square when exported are configurable.
#'
#' @param sequence ```character```. A DNA or RNA sequence to visualise e.g. ```"AAATGCTGC"```.
#' @param sequence_colours ```character vector```, length 4. A vector indicating which colours should be used for each base. In order: ```c(A_colour, C_colour, G_colour, TU_colour)```. Defaults to red, green, blue, purple (in the default shades produced by ggplot with 4 colours).
#' @param background_colour ```character```. The colour of the background. Defaults to white.
#' @param sequence_text_colour ```character```. The colour of the text within the bases (e.g. colour of "A" letter within boxes representing adenosine bases). Defaults to black.
#' @param sequence_text_size ```numeric```. The size of the text within the bases (e.g. size of "A" letter within boxes representing adenosine bases). Defaults to ```16```. Set to ```0``` to hide sequence text (show box colours only).
#' @param number_annotation_colour ```character```. The colour of the little numbers underneath indicating base index (e.g. colour "15" label under the 15th base). Defaults to dark red.
#' @param number_annotation_size ```numeric```. The size of the little number underneath indicating base index (e.g. size of "15" label under the 15th base). Defaults to ```12.5```. Set to ```0``` to turn off annotations (or set ```number_annotation_interval = 0```).
#' @param number_annotation_interval ```integer```. The frequency at which numbers should be placed underneath indicating base index, starting counting from the leftmost base in each row. Defaults to ```15``` (every 15 bases along each row). Recommended to make this a factor/divisor of the line wrapping length (meaning the final base in each line is annotated), otherwise the numbering interval resetting at the beginning of each row will result in uneven intervals at each line break. Set to ```0``` to turn off annotations (or set ```number_annotation_size = 0```).
#' @param line_wrapping ```integer```. The number of bases that should be on each line before wrapping. Defaults to ```75```.
#' @param return ```logical```. Boolean specifying whether this function should return the ggplot object, otherwise it will return ```NULL```. Defaults to ```TRUE```.
#' @param save ```logical```. Boolean specifying whether this function should save the plot to a file. Defaults to ```FALSE```.
#' @param filename ```character```. Filename to which output should be saved, if ```save = TRUE```. Recommended to end with .png but might work with other extensions if they are compatible with ggsave(). Defaults to ```"image.png"```.
#' @param pixels_per_base ```integer```. How large each box should be in pixels, if ```save = TRUE```. Corresponds to dpi of the exported image. Large values recommended because text needs to be legible when rendered significantly smaller than a box. Defaults to ```100```.
#'
#' @return A ggplot object containing the full visualisation, or ```NULL``` if ```return = FALSE```. It is often more useful to use ```save = TRUE``` and ```filename = "myfilename.png"```, because then the visualisation is exported at the correct aspect ratio.
#'
#' @import ggplot2
#' @export
generate_sequence_image <- function(sequence, sequence_colours = c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF"), background_colour = "white",
                                    sequence_text_colour = "black", sequence_text_size = 16, number_annotation_colour = "darkred", number_annotation_size = 12.5,
                                    line_wrapping = 75, number_annotation_interval = 15, return = TRUE, save = FALSE, filename = "image.png", pixels_per_base = 100) {
    if (length(sequence) > 1) {stop("Can only visualise one sequence at once.")}

    sequences <- convert_input_seq_to_sequence_list(sequence, line_wrapping)
    if (max(nchar(sequences)) < line_wrapping) {line_wrapping <- max(nchar(sequences))}
    annotations <- convert_sequences_to_annotations(sequences, line_wrapping, number_annotation_interval)

    colours <- c(background_colour, sequence_colours)
    names(colours) <- as.character(0:4)
    result <- plot_image_tile(sequences, colours) +
        geom_text(data = annotations, aes(x = x_position, y = y_position, label = annotation, col = type, size = type), fontface = "bold", inherit.aes = F) +
        scale_colour_manual(values = c("Number" = number_annotation_colour, "Sequence" = sequence_text_colour)) +
        scale_discrete_manual("size", values = c("Number" = number_annotation_size, "Sequence" = sequence_text_size)) +
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


## HELPER FUNCTIONS

## Takes sequence for visualisation and converts to a vector of sub-sequence lines
## Where each line is wrapped at the specified line length
## And there is an empty string after each line of sequence
convert_input_seq_to_sequence_list <- function(input_seq, line_length) {
    sequences <- NULL
    full_rows <- nchar(input_seq) %/% line_length
    if (full_rows > 0) {
        for (i in 1:full_rows) {
            start <- (i-1)*line_length + 1
            stop  <- i*line_length
            line <- substr(input_seq, start, stop)
            sequences <- c(sequences, line, "")
        }
    }
    start <- full_rows*line_length + 1
    stop  <- nchar(input_seq)
    line <- substr(input_seq, start, stop)
    sequences <- c(sequences, line, "")

    return(sequences)
}



## Takes sequence vector (alternating lines of fixed length split from sequence and blank line)
## from previous function and converts to a dataframe of coordinates for each annotation
## Specifies X and Y coordinates (corresponding to tiles generated by raster::raster())
## for each base, and for each annotation of base index underneath (occurring at a fixed interval)
convert_sequences_to_annotations <- function(sequences, line_length, interval = 5) {
    x_interval <- 1 / line_length
    y_interval <- 1 / length(sequences)

    data <- data.frame(NULL)

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
                data <- rbind(data, c(x_position, y_position, annotation, type))

                ## Annotate numbers every <interval> bases
                if (interval != 0 && j %% interval == 0) {
                    x_position <- x_interval * j - x_interval/2
                    y_position <- 1 - (y_interval * (i+1) - y_interval*2/3)
                    annotation <- as.character((i-1-i_values_to_ignore)*line_length + j)
                    type <- "Number"
                    data <- rbind(data, c(x_position, y_position, annotation, type))
                }
            }
        }
    }
    colnames(data) <- c("x_position", "y_position", "annotation", "type")
    data$x_position <- as.numeric(data$x_position)
    data$y_position <- as.numeric(data$y_position)
    return(data)
}



## These next two functions work together to encode
## sequence numerically for visualisation via raster::raster()
## A = 1, C = 2, G = 3, T/U = 4, blank = 0

## Map a single base to the corresponding number
convert_base_to_number <- function(base) {
    base <- toupper(base)
    if (base == "A") {
        number <- 1
    } else if (base == "C") {
        number <- 2
    } else if (base == "G") {
        number <- 3
    } else if (base %in% c("T", "U")) {
        number <- 4
    } else {
        stop("Base must be A/C/G/T/U to convert to number")
    }
    return(number)
}

## Use previous function to map one whole sequence string to a numerical vector
## Also requires a target length. If sequence is shorter than this, pad end with 0s.
convert_sequence_to_numbers <- function(sequence, length) {
    numerical_vector <- NULL
    for (i in 1:length) {
        if (i <= nchar(sequence)) {
            numerical_vector[i] <- convert_base_to_number(substr(sequence, i, i))
        } else {
            numerical_vector[i] <- 0
        }
    }
    return(numerical_vector)
}



## Uses numerical encoding of sequence to produce image data via raster::raster()
## Then plots this in ggplot2, using user-specified colours
## 0 is background, 1 is A, 2 is C, 3 is G, and 4 is T
plot_image_tile <- function(sequences, sequence_colours) {
    max_length <- max(nchar(sequences))
    image_matrix <- matrix(NA, nrow = length(sequences), ncol = max_length)
    for (i in 1:length(sequences)) {
        numeric_sequence_representation <- convert_sequence_to_numbers(sequences[i], max_length)
        image_matrix[i, ] <- numeric_sequence_representation
    }

    image_data <- raster::as.data.frame(raster::raster(image_matrix), xy = TRUE)

    plot <- ggplot(image_data, aes(x = x, y = y, fill = as.character(layer))) +
        geom_tile() +
        scale_fill_manual(values = sequence_colours) +
        guides(x = "none", y = "none", fill = "none") +
        theme(axis.title = element_blank(), plot.margin = grid::unit(c(0.5, 0.5, 0, 0.5), "inches")) +
        scale_x_continuous(expand = c(0, 0)) +
        scale_y_continuous(expand = c(0, 0))

    return(plot)
}
