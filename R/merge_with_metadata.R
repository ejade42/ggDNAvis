#' Reverse sequences if needed ([merge_methylation_with_metadata()] helper)
#'
#' This function takes a vector of DNA/RNA sequences and a vector of directions
#' (which must all be either `"forward"` or `"reverse"`, *not* case-sensitive)
#' and returns a vector of forward DNA/RNA sequences.\cr\cr
#' Sequences in the vector that were forward to begin with are unchanged,
#' while sequences that were reverse are reverse-complemented via [reverse_complement()]
#' to produce the forward sequence.\cr\cr
#' Called by [merge_methylation_with_metadata()] to create a forward dataset, alongside
#' [reverse_locations_if_needed()] and [reverse_probabilities_if_needed()].
#'
#' @param sequence_vector `character vector`. The DNA or RNA sequences to be reversed, e.g. `c("ATCG", "GGCGGC", "AUUAUA")`. Accepts DNA, RNA, or mixed input.
#' @param direction_vector `character vector`. Whether each sequence is forward or reverse. Must contain only `"forward"` and `"reverse"`, but is not case sensitive. Must be the same length as `sequence_vector`.
#' @param output_mode `character`. Whether reverse-complemented sequences should be converted to DNA (i.e. A complements to T) or RNA (i.e. A complements to U). Must be either `"DNA"` or `"RNA"`. *Only affects reverse-complemented sequences. Sequences that were forward to begin with are not altered.*
#'
#' @return `character vector`. A vector of all forward versions of the input sequence vector.
#' @export
reverse_sequence_if_needed <- function(sequence_vector, direction_vector, output_mode = "DNA") {
    ## Validate arguments
    for (argument in list(sequence_vector, direction_vector, output_mode)) {
        if (any(is.null(argument)) == TRUE || any(is.na(argument)) == TRUE) {
            abort(paste("Argument", argument, "must not be NULL or NA"), class = "argument_value_or_type")
        }
    }
    for (argument in list(sequence_vector, direction_vector, output_mode)) {
        if (is.character(argument) == FALSE) {
            abort(paste("Argument", argument, "must be of type character/string"), class = "argument_value_or_type")
        }
    }
    if (length(output_mode) != 1) {
        abort("Output mode must be of length 1 (and be either 'DNA' or 'RNA')", class = "argument_value_or_type")
    }
    if (length(sequence_vector) != length(direction_vector)) {
        abort("Sequence and direction vectors need to be same length.", class = "argument_value_or_type")
    }


    ## Main function
    new_sequence_vector <- rep(NA, length(sequence_vector))
    for (i in 1:length(sequence_vector)) {
        if (tolower(direction_vector[i]) == "forward") {
            new_sequence_vector[i] <- sequence_vector[i]
        } else if (tolower(direction_vector[i]) == "reverse") {
            new_sequence_vector[i] <- reverse_complement(sequence_vector[i], toupper(output_mode))
        } else {
            abort("direction vector must contain only 'forward' and 'reverse' (not case sensistive)", class = "argument_value_or_type")
        }
    }
    return(new_sequence_vector)
}





#' Reverse modification locations if needed ([merge_methylation_with_metadata()] helper)
#'
#' This function takes a vector of condensed modification locations/indices (e.g.
#' `c("3,6,9,12", "1,4,7,10")`), a vector of directions (which must all be either
#' `"forward"` or `"reverse"`, *not* case-sensitive), and a vector of sequence lengths
#' (integers).\cr\cr
#' Returns a vector of condensed locations where reads that were originally forward
#' are unchanged, and reads that were originally reverse are flipped to now be forward.\cr\cr
#' Optionally, a numerical offset can be set. If this is left at `0` (the default value),
#' then a CpG assessed for methylation would be reverse-complemented to a CG with the
#' modification information ascribed to the G (as the G is at the location where the actual
#' modified C was on the other strand). However, setting the offset to `1` would shift all
#' of the modification indices by 1 such that the modification is now ascribed to the C of the
#' reverse-strand CG. This is beneficial for visualising the modifications as it ensures consistency
#' between originally-forward and originally-reverse strands by making the modification score associated
#' with each CpG site always be located at the C, but may be misleading for quantitative analysis.
#' Setting the offset to anything other than `0` or `1` should work but may be biologically misleading,
#' so produces a warning.\cr\cr
#' Called by [merge_methylation_with_metadata()] to create a forward dataset, alongside
#' [reverse_sequence_if_needed()] and [reverse_probabilities_if_needed()].\cr\cr
#' **Example:**\cr\cr
#' Forward sequence, with indices of Cs in CpGs numbered:\cr
#' \preformatted{
#' C C C A G G C G G C G G C G A C C G A
#'             7     10    13      17
#' }
#' (length = 19, locations = `"7,10,13,17"`, CpGs = 7-8, 10-11, 13-14, 17-18)\cr\cr
#' Reverse sequence, with indices of C in CpGs numbered:\cr
#' \preformatted{
#' T C G G T C G C C G C C G C C T G G G
#'   2       6     9     12
#' }
#' (length = 19, locations = `"2,6,9,12"`, CpGs = 2-3, 6-7, 9-10, 12-13)\cr\cr
#' As CG reverse-complements to itself, each CpG site has a 1:1 correspondence with
#' a CpG site in the reverse strand. Many methylation calling models assess C-methylation
#' at the C of each CpG. To map the locations from C to C, we take `19 - <index>` such that
#' `"7,10,13,17"` becomes `"12,9,6,2"` and `"2,6,9,12"` becomes `"17,13,10,7"`.
#' The symmetry of CpGs means mapping from C to C is also symmetric.
#' *This is achieved by setting **`offset = 1`**, as mapping C to C involves shifting position by 1.*\cr\cr
#' Conversely, to map the locations from C to G (i.e. preserving the actual location of each
#' modification, which is required if assessed locations are non-symmetric/don't reverse-complement
#' to themselves like CpGs do), we take `20 - <index>` such that
#' `"7,10,13,17"` becomes `"13,10,7,3"` i.e. the indices of the Gs in CpGs in the reverse
#' sequence. Likewise `"2,6,9,12"` becomes `"18,14,11,8"` i.e. the indices of the Gs in CpGs in
#' the forward sequence.
#' *This is achieved by setting **`offset = 0`**, as mapping C to G preserves the actual original position
#' at which each modification was assessed, but changes the base to its complement.*\cr\cr
#' In general, new locations are calculated as `(<length> + 1 - <offset>) - <index>`.
#' Of course, output locations are reversed before returning so that they all
#' return in ascending order, as is standard for all location vectors/strings.
#'
#' @param locations_vector `character vector`. The locations to be reversed for each sequence/read. Each read should have one character value, representing a comma-separated list of indices at which modification was assessed along the read e.g. `"3,6,9,12"` for all the `Cs` in `GGCGGCGGCGGC`.\cr\cr These comma-separated characters/strings can be produced from numeric vectors via [vector_to_string()] and converted back to vectors via [string_to_vector()].
#' @param direction_vector `character vector`. Whether each sequence is forward or reverse. Must contain only `"forward"` and `"reverse"`, but is not case sensitive. Must be the same length as `locations_vector` and `length_vector`.
#' @param length_vector `integer vector`. The length of each sequence. Needed for reversing locations as locations are stored relative to the start of the read i.e. relative to the end of the reverse read. Must be the same length as `locations_vector` and `direction_vector`.
#' @param offset `integer`. How much locations should be shifted by. Defaults to `0`. This is important because if a CpG is assessed for methylation at the C, then reverse complementing it will give a methylation score at the G on the reverse-complemented strand. This is the most biologically accurate, but for visualising methylation it may be desired to shift the locations by `1` i.e. to correspond with the C in the reverse-complemented CpG rather than the G, which allows for consistent visualisation between forward and reverse strands. Setting (integer) values other than `0` or `1` will work, but may be biologically misleading so it is not recommended.
#'
#' @return `character vector`. A vector of all forward versions of the input locations vector.
#' @export
reverse_locations_if_needed <- function(locations_vector, direction_vector, length_vector, offset = 0) {
    ## Validate arguments
    for (argument in list(locations_vector, direction_vector, length_vector, offset)) {
        if (any(is.null(argument)) == TRUE || any(is.na(argument)) == TRUE) {
            abort(paste("Argument", argument, "must not be NULL or NA"), class = "argument_value_or_type")
        }
    }
    for (argument in list(locations_vector, direction_vector)) {
        if (is.character(argument) == FALSE) {abort("Locations and direction vectors must both be of character/string type", class = "argument_value_or_type")}
    }
    for (argument in list(length_vector)) {
        if (is.numeric(argument) == FALSE || any(argument %% 1 != 0) || any(argument < 0)) {abort("Length vector must contain only non-negative integer values", class = "argument_value_or_type")}
    }
    for (argument in list(offset)) {
        if (length(argument) != 1 || is.numeric(argument) == FALSE || argument %% 1 != 0) {abort("Offset must be a single integer value", class = "argument_value_or_type")}
    }

    if (length(locations_vector) != length(direction_vector) ||
        length(locations_vector) != length(length_vector) ||
        length(length_vector)    != length(direction_vector)) {
        abort("Locations, direction, and length vectors need to be the same length", class = "argument_value_or_type")
    }
    if (!(offset %in% c(0, 1))) {
        warn("Setting location reversal offset to anything other than 0 or 1 is advanced use. Make sure this is intentional.", class = "parameter_recommendation")
    }

    ## Main function
    new_locations_vector <- rep(NA, length(locations_vector))
    for (i in 1:length(locations_vector)) {
        if (tolower(direction_vector[i]) == "forward") {
            new_locations_vector[i] <- locations_vector[i]
        } else if (tolower(direction_vector[i]) == "reverse") {
            length <- length_vector[i]
            reverse_positions <- string_to_vector(locations_vector[i])

            if (any(is.na(reverse_positions))) {
                abort("Invalid value in locations vector", class = "argument_value_or_type")
            }

            ## With offset 0: index 1 needs to correspond to final index,
            ##                index 2 needs to correspond to final index-1
            ## i.e. length+1 - index. Subtract offset to modulate this.
            ## then need to reverse so that reversed vector is in ascending order
            new_positions <- rev((length+1 - offset) - reverse_positions)
            new_locations_vector[i] <- vector_to_string(new_positions)
        } else {
            abort("direction vector must contain only 'forward' and 'reverse' (not case sensistive)", class = "argument_value_or_type")
        }
    }
    return(new_locations_vector)
}






#' Reverse modification probabilities if needed ([merge_methylation_with_metadata()] helper)
#'
#' This function takes a vector of condensed modification probabilities
#' (e.g. `c("128,0,63,255", "3,78,1"`) and a vector of directions (which
#' must all be either `"forward"` or `"reverse"`, *not* case-sensitive),
#' and returns a vector of condensed modification probabilities where those
#' that were originally forward are unchanged, and those that were originally
#' reverse are flipped to now be forward.\cr\cr
#' Called by [merge_methylation_with_metadata()] to create a forward dataset, alongside
#' [reverse_sequence_if_needed()] and [reverse_locations_if_needed()].\cr\cr
#'
#' @param probabilities_vector `character vector`. The probabilities to be reversed for each sequence/read. Each read should have one character value, representing a comma-separated list of the modification probabilities for each assessed base along the read e.g. `"230,7,64,145"`. In most situations these will be 8-bit integers from 0 to 255, but this function will work on any comma-separated values.\cr\cr These comma-separated characters/strings can be produced from numeric vectors via [vector_to_string()] and converted back to vectors via [string_to_vector()].
#' @param direction_vector `character vector`. Whether each sequence is forward or reverse. Must contain only `"forward"` and `"reverse"`, but is not case sensitive. Must be the same length as `probabilities_vector`.
#'
#' @return `character vector`. A vector of all forward versions of the input probabilities vector.
#' @export
reverse_probabilities_if_needed <- function(probabilities_vector, direction_vector) {
    ## Validate arguments
    for (argument in list(probabilities_vector, direction_vector)) {
        if (any(is.null(argument)) == TRUE || any(is.na(argument)) == TRUE) {
            abort(paste("Argument", argument, "must not be NULL or NA"), class = "argument_value_or_type")
        }
    }
    for (argument in list(probabilities_vector, direction_vector)) {
        if (is.character(argument) == FALSE) {abort("Probabilities and direction vectors must be character type", class = "argument_value_or_type")}
    }
    if (length(probabilities_vector) != length(direction_vector)) {
        abort("Probabilities and direction vectors need to be same length", class = "argument_value_or_type")
    }

    ## Main function
    new_probabilities_vector <- rep(NA, length(probabilities_vector))
    for (i in 1:length(probabilities_vector)) {
        if (tolower(direction_vector[i]) == "forward") {
            new_probabilities_vector[i] <- probabilities_vector[i]
        } else if (tolower(direction_vector[i]) == "reverse") {
            probabilities_to_reverse <- string_to_vector(probabilities_vector[i])
            if (any(is.na(probabilities_to_reverse))) {abort("Invalid value in probabilities vector", class = "argument_value_or_type")}
            new_probabilities_vector[i] <- vector_to_string(rev(probabilities_to_reverse))
        } else {
            abort("direction vector must contain only 'forward' and 'reverse' (not case sensistive)", class = "argument_value_or_type")
        }
    }
    return(new_probabilities_vector)
}
