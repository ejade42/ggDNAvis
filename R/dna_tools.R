## Not user-facing
## Basic utilities for vector and string conversion
string_to_vector  <- function(string) {as.numeric(unlist(strsplit(string, split = ",")))}
vector_to_string  <- function(vector) {paste(vector, collapse = ",")}


#' Reverse complement a DNA/RNA sequence
#'
#' This function takes a string/character representing a DNA/RNA sequence and returns
#' the reverse complement. Either DNA (A/C/G/T) or RNA (A/C/G/U) input is accepted.
#' By default, output is DNA (so A is reverse-complemented to T), but it can be set
#' to output RNA (so A is reverse-complemented to U).
#'
#' @param sequence ```character```. A DNA/RNA sequence (A/C/G/T/U) to be reverse-complemented. No other characters allowed. Only one sequence allowed.
#' @param output_mode ```character```. Either ```"DNA"``` (default) or ```"RNA"```, to determine whether A should be reverse-complemented to T or to U.
#' @return ```character```. The reverse-complement of the input sequence.
#'
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
