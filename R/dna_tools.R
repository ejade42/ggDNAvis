## Not user-facing
## Basic utilities for vector and string conversion
string_to_vector  <- function(string) {as.numeric(unlist(strsplit(string, split = ",")))}
vector_to_string  <- function(vector) {paste(vector, collapse = ",")}


#' Reverse complement a DNA/RNA sequence
#'
#' This function takes a string/character representing a DNA/RNA sequence and returns
#' the reverse complement. Either DNA (`A/C/G/T`) or RNA (`A/C/G/U`) input is accepted. \cr\cr
#' By default, output is DNA (so `A` is reverse-complemented to `T`), but it can be set
#' to output RNA (so `A` is reverse-complemented to `U`).
#'
#' @param sequence `character`. A DNA/RNA sequence (`A/C/G/T/U`) to be reverse-complemented. No other characters allowed. Only one sequence allowed.
#' @param output_mode `character`. Either `"DNA"` (default) or `"RNA"`, to determine whether `A` should be reverse-complemented to `T` or to `U`.
#'
#' @return `character`. The reverse-complement of the input sequence.
#' @export
reverse_complement <- function(sequence, output_mode = "DNA") {
    if (length(sequence) > 1) {
        stop("Can only input one sequence at once. Try sapply(input_vector, reverse_complement) to use on more than one input.")
    }
    sequence_vector     <- strsplit(toupper(sequence), split = "")[[1]]
    reversed_vector     <- rev(sequence_vector)
    new_sequence_vector <- rep(NA, length(reversed_vector))

    for (i in 1:length(reversed_vector)) {
        if (reversed_vector[i] == "A") {
            if (toupper(output_mode) == "DNA") {
                new_sequence_vector[i] <- "T"
            } else if (toupper(output_mode) == "RNA") {
                new_sequence_vector[i] <- "U"
            } else {
                stop("Output mode must be set to either 'DNA' (default) or 'RNA'")
            }
        } else if (reversed_vector[i] == "C") {
            new_sequence_vector[i] <- "G"
        } else if (reversed_vector[i] == "G") {
            new_sequence_vector[i] <- "C"
        } else if (reversed_vector[i] %in% c("T", "U")) {
            new_sequence_vector[i] <- "A"
        } else {
            stop("Cannot reverse sequence for non-A/C/G/T/U")
        }
    }

    new_sequence <- paste(new_sequence_vector, collapse = "")
    return(new_sequence)
}



## These next two functions work together to encode
## sequence numerically for visualisation via `raster::raster()`.
## A = 1, C = 2, G = 3, T/U = 4, blank = 0

#' Map a single base to the corresponding number
#'
#' This function takes a single base and numerically
#' encodes it for visualisation via `raster::raster()`. \cr\cr
#' Encoding: `A = 1`, `C = 2`, `G = 3`, `T/U = 4`.
#'
#' @param base `character`. A single DNA/RNA base to encode numerically (e.g. `"A"`).
#' @return `integer`. The corresponding number.
#' @export
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
        stop("Base must be one of A/C/G/T/U to convert to number")
    }
    return(number)
}

#' Map a sequence to a vector of numbers
#'
#' This function takes a sequence and encodes it as a vector
#' of numbers for visualisation via `raster::raster()`. \cr\cr
#' Encoding: `A = 1`, `C = 2`, `G = 3`, `T/U = 4`.
#'
#' @param sequence `character`. A DNA/RNA sequence (`A/C/G/T/U`) to be encoded numerically. No other characters allowed. Only one sequence allowed.
#' @param length `integer`. How long the output numerical vector should be. If shorter than the sequence, the vector will include the first *n* bases up to this length. If longer than the sequence, the vector will be padded with 0s at the end. If left blank/set to `NA` (default), will output a vector the same length as the input sequence.
#'
#' @return `integer vector`. The numerical encoding of the input sequence, cut/padded to the desired length.
#' @export
convert_sequence_to_numbers <- function(sequence, length = NA) {
    ## Tests to make sure length is something sensible
    if (is.na(length)) {
        length <- nchar(sequence)
    }
    if (is.numeric(length) == FALSE || length %% 1 != 0 || length < 0) {
        stop("Length must be a non-negative integer or NA")
    }

    if (length == 0) {     ## specifically not else if, to return empty num vector if length not specified but sequence length is 0
        return(numeric(0))
    }

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



#' Rasterise a vector of sequences into a numerical dataframe for ggplotting
#'
#' Takes a character vector of sequences (which are allowed to be empty `""` to
#' act as a spacing line) and rasterises it into a dataframe that ggplot can read.
#'
#' @param sequences `character vector`. A vector of sequences for plotting, e.g. `c("ATCG", "", "GGCGGC", "")`. Each sequence will be plotted left-aligned on a new line.
#' @return `dataframe`. Rasterised dataframe representation of the sequences, readable by ggplot.
#' @export
create_image_data <- function(sequences) {
    max_length <- max(nchar(sequences))
    image_matrix <- matrix(NA, nrow = length(sequences), ncol = max_length)
    for (i in 1:length(sequences)) {
        numeric_sequence_representation <- convert_sequence_to_numbers(sequences[i], max_length)
        image_matrix[i, ] <- numeric_sequence_representation
    }

    image_data <- raster::as.data.frame(raster::raster(image_matrix), xy = TRUE)
    return(image_data)
}
