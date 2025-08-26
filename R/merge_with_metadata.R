#' Merge FASTQ data with metadata
#'
#' Merge a dataframe of sequence and quality data (as produced by
#' [read_fastq()] from an unmodified FASTQ file) with a dataframe of
#' metadata, reverse-complementing sequences if required such that all
#' reads are now in the forward direction.
#' [merge_methylation_with_metadata()] is the equivalent function for
#' working with FASTQs that contain DNA modification information.\cr\cr
#' FASTQ dataframe must contain columns of `"read"` (unique read ID),
#' `"sequence"` (DNA sequence), and `"quality"` (FASTQ quality score).
#' Other columns are allowed but not required, and will be preserved unaltered
#' in the merged data.\cr\cr
#' Metadata dataframe must contain `"read"` (unique read ID) and `"direction"`
#' (read direction, either `"forward"` or `"reverse"` for each read) columns,
#' and can contain any other columns with arbitrary information for each read.
#' Columns that might be useful include participant ID and family designations
#' so that each read can be associated with its participant and family.\cr\cr
#' **Important:** A key feature of this function is that it uses the direction
#' column from the metadata to identify which rows are reverse reads. These reverse
#' reads will then be reversed-complemented and have quality scores reversed
#' such that all reads are in the forward direction, ideal for consistent analysis or
#' visualisation. The output columns are `"forward_sequence"` and `"forward_quality"`.
#' Calls [reverse_sequence_if_needed()] and [reverse_quality_if_needed()]
#' to implement the reversing - see documentation for these functions for more details.
#'
#' @param fastq_data `dataframe`. A dataframe contaning sequence and quality data, as produced by [read_fastq()].\cr\cr Must contain a read id column (must be called `"read"`), a sequence column (`"sequence"`), and a quality column (`"quality"`). Additional columns are fine and will simply be included unaltered in the merged dataframe.
#' @param metadata `dataframe`. A dataframe containing metadata for each read in `fastq_data`.\cr\cr Must contain a `"read"` column identical to the column of the same name in `fastq_data`, containing unique read IDs (this is used to merge the dataframes). Must also contain a `"direction"` column of `"forward"` and `"reverse"` (e.g. `c("forward", "forward", "reverse")`) indicating the direction of each read.\cr\cr **Important:** Reverse reads will have their sequence and quality scores reversed such that every output read is now forward. These will be stored in columns called `"forward_sequence"` and `"forward_quality"`.\cr\cr See [reverse_sequence_if_needed()] and [reverse_quality_if_needed()] documentation for details of how the reversing is implemented.
#' @param reverse_complement_mode `character`. Whether reverse-complemented sequences should be converted to DNA (i.e. A complements to T) or RNA (i.e. A complements to U). Must be either `"DNA"` or `"RNA"`. *Only affects reverse-complemented sequences. Sequences that were forward to begin with are not altered.*\cr\cr Uses [reverse_complement()] via [reverse_sequence_if_needed()].
#'
#' @return `dataframe`. A merged dataframe containing all columns from the input dataframes, as well as forward versions of sequences and qualities.
#'
#' @examples
#' ## Locate files
#' fastq_file <- system.file("extdata",
#'                           "example_many_sequences_raw.fastq",
#'                           package = "ggDNAvis")
#' metadata_file <- system.file("extdata",
#'                              "example_many_sequences_metadata.csv",
#'                              package = "ggDNAvis")
#'
#' ## Read files
#' fastq_data <- read_fastq(fastq_file)
#' metadata   <- read.csv(metadata_file)
#'
#' ## Merge data (including reversing if needed)
#' merge_fastq_with_metadata(fastq_data, metadata)
#'
#' @export
merge_fastq_with_metadata <- function(fastq_data, metadata, reverse_complement_mode = "DNA") {
    ## Validate arguments
    if (length(reverse_complement_mode) != 1 || is.na(reverse_complement_mode) || !is.character(reverse_complement_mode) || !(reverse_complement_mode %in% c("DNA", "RNA"))) {
        abort("Reverse complement mode must be a single character value, either 'DNA' or 'RNA'", class = "argument_value_or_type")
    }
    if (nrow(metadata) != nrow(fastq_data)) {
        abort("FASTQ and metadata dataframes must have the same number of rows, one row per read.", class = "argument_value_or_type")
    }
    for (column in c("read", "sequence", "quality")) {
        if (!(column %in% colnames(fastq_data))) {
            abort(paste0("FASTQ dataframe must contain a '", column, "' column. This error should not occur if data was read via read_modified_fastq(), please contact the package maintainers."), class = "argument_value_or_type")
        }
    }
    if (!("read" %in% colnames(metadata))) {
        abort(paste0("Metadata must contain a 'read' column. Please make sure there is a column of unique read IDs in the metadata and that it is called 'read'."), class = "argument_value_or_type")
    }
    if (!("direction" %in% colnames(metadata))) {
        abort(paste0("Metadata must contain a 'direction' column. Please make sure there is a column of forward/reverse read directions in the metadata and that it is called 'direction'."), class = "argument_value_or_type")
    }


    ## Main function
    merged_data <- merge(metadata, fastq_data, by = "read")
    merged_data$forward_sequence <- reverse_sequence_if_needed(merged_data$sequence, merged_data$direction, reverse_complement_mode)
    merged_data$forward_quality  <- reverse_quality_if_needed(merged_data$quality, merged_data$direction)

    return(merged_data)
}





#' Merge methylation with metadata
#'
#' Merge a dataframe of methylation/modification data (as produced by
#' [read_modified_fastq()]) with a dataframe of metadata, reversing
#' sequence and modification information if required such that all information
#' is now in the forward direction.
#' [merge_fastq_with_metadata()] is the equivalent function for working with
#' unmodified FASTQs (sequence and quality only).\cr\cr
#' Methylation/modification dataframe must contain columns of `"read"` (unique read ID),
#' `"sequence"` (DNA sequence), `"quality"` (FASTQ quality score), `"sequence_length"`
#' (read length), `"modification_types"` (a comma-separated string of SAMtools modification
#' headers produced via [vector_to_string()] e.g. `"C+h?,C+m?"`), and,
#' for each modification type, a column of comma-separated strings of modification
#' locations (e.g. `"3,6,9,12"`) and a column of comma-separated strings of
#' modification probabilities (e.g. `"255,0,64,128"`). See [read_modified_fastq()]
#' for more information on how this dataframe is formatted and produced.
#' Other columns are allowed but not required, and will be preserved unaltered
#' in the merged data.\cr\cr
#' Metadata dataframe must contain `"read"` (unique read ID) and `"direction"`
#' (read direction, either `"forward"` or `"reverse"` for each read) columns,
#' and can contain any other columns with arbitrary information for each read.
#' Columns that might be useful include participant ID and family designations
#' so that each read can be associated with its participant and family.\cr\cr
#' **Important:** A key feature of this function is that it uses the direction
#' column from the metadata to identify which rows are reverse reads. These reverse
#' reads will then be reversed-complemented and have modification information reversed
#' such that all reads are in the forward direction, ideal for consistent analysis or
#' visualisation. The output columns are `"forward_sequence"`, `"forward_quality"`,
#' `"forward_<modification_type>_locations"`, and `"forward_<modification_type>_probabilities"`.\cr\cr
#' Calls [reverse_sequence_if_needed()], [reverse_quality_if_needed()],
#' [reverse_locations_if_needed()], and [reverse_probabilities_if_needed()]
#' to implement the reversing - see documentation for these functions for more details.
#' If wanting to write reversed sequences to FASTQ via `write_modified_fastq()`, locations
#' must be symmetric (e.g. CpG) and offset must be set to 1. Asymmetric locations are impossible
#' to write to modified FASTQ once reversed because then e.g. cytosine methylation will be assessed
#' at guanines, which SAMtools can't account for. Symmetrically reversing CpGs via
#' `reversed_location_offset = 1` is the only way to fix this.
#'
#' @param methylation_data `dataframe`. A dataframe contaning methylation/modification data, as produced by [read_modified_fastq()].\cr\cr Must contain a read id column (must be called `"read"`), a sequence column (`"sequence"`), a quality column (`"quality"`), a sequence length column (`"sequence_length"`), a modification types column (`"modification_types"`), and, for each modification type listed in `modification_types`, a column of locations (`"<modification_type>_locations"`) and a column of probabilities (`"<modification_type>_probabilities"`). Additional columns are fine and will simply be included unaltered in the merged dataframe. \cr\cr See [read_modified_fastq()] documentation for more details about the expected dataframe format.
#' @param metadata `dataframe`. A dataframe containing metadata for each read in `methylation_data`.\cr\cr Must contain a `"read"` column identical to the column of the same name in `methylation_data`, containing unique read IDs (this is used to merge the dataframes). Must also contain a `"direction"` column of `"forward"` and `"reverse"` (e.g. `c("forward", "forward", "reverse")`) indicating the direction of each read.\cr\cr **Important:** Reverse reads will have their sequence, quality scores, modification locations, and modification probabilities reversed such that every output read is now forward. These will be stored in columns called `"forward_sequence"`, `"forward_quality"`, `"forward_<modification_type>_locations"`, and `"forward_<modification_type>_probabilities"`. If multiple modification types are present, multiple locations and probabilities columns will be created.\cr\cr See [reverse_sequence_if_needed()], [reverse_quality_if_needed()], [reverse_locations_if_needed()], and [reverse_probabilities_if_needed()] documentation for details of how the reversing is implemented.
#' @param reversed_location_offset `integer`. How much modification locations should be shifted by. Defaults to `0`. This is important because if a CpG is assessed for methylation at the C, then reverse complementing it will give a methylation score at the G on the reverse-complemented strand. This is the most biologically accurate, but for visualising methylation it may be desired to shift the locations by 1 i.e. to correspond with the C in the reverse-complemented CpG rather than the G, which allows for consistent visualisation between forward and reverse strands. Setting (integer) values other than 0 or 1 will work, but may be biologically misleading so it is not recommended.\cr\cr **Highly recommended:** if considering using this option, read the [reverse_locations_if_needed()] documentation to fully understand how it works.
#' @param reverse_complement_mode `character`. Whether reverse-complemented sequences should be converted to DNA (i.e. A complements to T) or RNA (i.e. A complements to U). Must be either `"DNA"` or `"RNA"`. *Only affects reverse-complemented sequences. Sequences that were forward to begin with are not altered.*\cr\cr Uses [reverse_complement()] via [reverse_sequence_if_needed()].
#'
#' @return `dataframe`. A merged dataframe containing all columns from the input dataframes, as well as forward versions of sequences, qualities, modification locations, and modification probabilities (with separate locations and probabilities columns created for each modification type in the modification data).
#'
#' @examples
#' ## Locate files
#' modified_fastq_file <- system.file("extdata",
#'                                    "example_many_sequences_raw_modified.fastq",
#'                                    package = "ggDNAvis")
#' metadata_file <- system.file("extdata",
#'                              "example_many_sequences_metadata.csv",
#'                              package = "ggDNAvis")
#'
#' ## Read files
#' methylation_data <- read_modified_fastq(modified_fastq_file)
#' metadata <- read.csv(metadata_file)
#'
#' ## Merge data (including reversing if needed)
#' merge_methylation_with_metadata(methylation_data, metadata, reversed_location_offset = 0)
#'
#' ## Merge data with offset = 1
#' merge_methylation_with_metadata(methylation_data, metadata, reversed_location_offset = 1)
#'
#' @export
merge_methylation_with_metadata <- function(methylation_data, metadata, reversed_location_offset = 0, reverse_complement_mode = "DNA") {
    ## Validate arguments
    if (length(reversed_location_offset) != 1 || is.na(reversed_location_offset) || !is.numeric(reversed_location_offset) || reversed_location_offset %% 1 != 0) {
        abort("Reverse location offset must be a single integer value", class = "argument_value_or_type")
    }
    if (length(reverse_complement_mode) != 1 || is.na(reverse_complement_mode) || !is.character(reverse_complement_mode) || !(reverse_complement_mode %in% c("DNA", "RNA"))) {
        abort("Reverse complement mode must be a single character value, either 'DNA' or 'RNA'", class = "argument_value_or_type")
    }
    if (nrow(metadata) != nrow(methylation_data)) {
        abort("Methylation and metadata dataframes must have the same number of rows, one row per read.", class = "argument_value_or_type")
    }
    for (column in c("read", "sequence", "quality", "sequence_length", "modification_types")) {
        if (!(column %in% colnames(methylation_data))) {
            abort(paste0("Methylation dataframe must contain a '", column, "' column. This error should not occur if data was read via read_modified_fastq(), please contact the package maintainers."), class = "argument_value_or_type")
        }
    }
    if (!("read" %in% colnames(metadata))) {
        abort(paste0("Metadata must contain a 'read' column. Please make sure there is a column of unique read IDs in the metadata and that it is called 'read'."), class = "argument_value_or_type")
    }
    if (!("direction" %in% colnames(metadata))) {
        abort(paste0("Metadata must contain a 'direction' column. Please make sure there is a column of forward/reverse read directions in the metadata and that it is called 'direction'."), class = "argument_value_or_type")
    }

    ## Main function
    merged_data <- merge(metadata, methylation_data, by = "read")
    merged_data$forward_sequence <- reverse_sequence_if_needed(merged_data$sequence, merged_data$direction, reverse_complement_mode)
    merged_data$forward_quality  <- reverse_quality_if_needed(merged_data$quality, merged_data$direction)

    for (modification_type in unique(string_to_vector(merged_data$modification_types, "character"))) {
        if (!(paste0(modification_type, "_locations")) %in% colnames(merged_data)) {
            abort(paste0("Modification type '", modification_type, "' is present in modification_types but there is no '", modification_type, "_locations' column."), class = "argument_value_or_type")
        }
        if (!(paste0(modification_type, "_probabilities")) %in% colnames(merged_data)) {
            abort(paste0("Modification type '", modification_type, "' is present in modification_types but there is no '", modification_type, "_probabilities' column."), class = "argument_value_or_type")
        }

        merged_data[, paste0("forward_", modification_type, "_locations")] <- reverse_locations_if_needed(pull(merged_data, paste0(modification_type, "_locations")), merged_data$direction, merged_data$sequence_length, offset = reversed_location_offset)
        merged_data[, paste0("forward_", modification_type, "_probabilities")] <- reverse_probabilities_if_needed(pull(merged_data, paste0(modification_type, "_probabilities")), merged_data$direction)
    }

    return(merged_data)
}



## REVERSING HELPER FUNCTIONS
## ----------------------------------------------------------------------------------------

#' Reverse sequences if needed ([merge_methylation_with_metadata()] helper)
#'
#' This function takes a vector of DNA/RNA sequences and a vector of directions
#' (which must all be either `"forward"` or `"reverse"`, *not* case-sensitive)
#' and returns a vector of forward DNA/RNA sequences.\cr\cr
#' Sequences in the vector that were forward to begin with are unchanged,
#' while sequences that were reverse are reverse-complemented via [reverse_complement()]
#' to produce the forward sequence.\cr\cr
#' Called by [merge_methylation_with_metadata()] to create a forward dataset, alongside
#' [reverse_quality_if_needed()], [reverse_locations_if_needed()] and [reverse_probabilities_if_needed()].
#'
#' @param sequence_vector `character vector`. The DNA or RNA sequences to be reversed, e.g. `c("ATCG", "GGCGGC", "AUUAUA")`. Accepts DNA, RNA, or mixed input.
#' @param direction_vector `character vector`. Whether each sequence is forward or reverse. Must contain only `"forward"` and `"reverse"`, but is not case sensitive. Must be the same length as `sequence_vector`.
#' @param output_mode `character`. Whether reverse-complemented sequences should be converted to DNA (i.e. A complements to T) or RNA (i.e. A complements to U). Must be either `"DNA"` or `"RNA"`. *Only affects reverse-complemented sequences. Sequences that were forward to begin with are not altered.*
#'
#' @return `character vector`. A vector of all forward versions of the input sequence vector.
#'
#' @examples
#' reverse_sequence_if_needed(
#'     sequence_vector = c("TAAGGC", "TAAGGC"),
#'     direction_vector = c("reverse", "forward")
#' )
#'
#' reverse_sequence_if_needed(
#'     sequence_vector = c("UAAGGC", "UAAGGC"),
#'     direction_vector = c("reverse", "forward"),
#'     output_mode = "RNA"
#' )
#'
#' @export
reverse_sequence_if_needed <- function(sequence_vector, direction_vector, output_mode = "DNA") {
    ## Validate arguments
    for (argument in list(direction_vector, output_mode)) {
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
            abort("direction vector must contain only 'forward' and 'reverse' (not case sensitive)", class = "argument_value_or_type")
        }
    }
    return(new_sequence_vector)
}




#' Reverse qualities if needed ([merge_methylation_with_metadata()] helper)
#'
#' This function takes a vector of FASTQ qualities and a vector of directions
#' (which must all be either `"forward"` or `"reverse"`, *not* case-sensitive)
#' and returns a vector of forward qualities.\cr\cr
#' Qualities of reads that were forward to begin with are unchanged,
#' while qualities of reads that were reverse are now flipped
#' to give the corresponding forward quality scores.\cr\cr
#' Called by [merge_methylation_with_metadata()] to create a forward dataset,
#' alongside [reverse_sequence_if_needed()], [reverse_locations_if_needed()],
#' and [reverse_probabilities_if_needed()].
#'
#' @param quality_vector `character vector`. The qualities to be reversed. See [`fastq_quality_scores`] for an explanation of quality scores.
#' @param direction_vector `character vector`. Whether each sequence is forward or reverse. Must contain only `"forward"` and `"reverse"`, but is not case sensitive. Must be the same length as `sequence_vector`.
#'
#' @return `character vector`. A vector of all forward versions of the input quality vector.
#'
#' @examples
#' reverse_quality_if_needed(
#'     quality_vector = c("#^$&$*", "#^$&$*"),
#'     direction_vector = c("reverse", "forward")
#' )
#'
#' @export
reverse_quality_if_needed <- function(quality_vector, direction_vector) {
    ## Validate arguments
    for (argument in list(direction_vector)) {
        if (any(is.null(argument)) == TRUE || any(is.na(argument)) == TRUE) {
            abort(paste("Argument", argument, "must not be NULL or NA"), class = "argument_value_or_type")
        }
    }
    for (argument in list(quality_vector, direction_vector)) {
        if (is.character(argument) == FALSE) {
            abort(paste("Argument", argument, "must be of type character/string"), class = "argument_value_or_type")
        }
    }
    if (length(quality_vector) != length(direction_vector)) {
        abort("Quality and direction vectors need to be same length.", class = "argument_value_or_type")
    }


    ## Main function
    new_quality_vector <- rep(NA, length(quality_vector))
    for (i in 1:length(quality_vector)) {
        if (tolower(direction_vector[i]) == "forward") {
            new_quality_vector[i] <- quality_vector[i]
        } else if (tolower(direction_vector[i]) == "reverse") {
            new_quality_vector[i] <- paste(rev(strsplit(quality_vector[i], "")[[1]]), collapse = "")
        } else {
            abort("direction vector must contain only 'forward' and 'reverse' (not case sensitive)", class = "argument_value_or_type")
        }
    }
    return(new_quality_vector)
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
#' [reverse_sequence_if_needed()], [reverse_quality_if_needed()], and [reverse_probabilities_if_needed()].\cr\cr
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
#' return in ascending order, as is standard for all location vectors/strings.\cr\cr
#' If wanting to write reversed sequences to FASTQ via `write_modified_fastq()`, locations
#' must be symmetric (e.g. CpG) and offset must be set to 1. Asymmetric locations are impossible
#' to write to modified FASTQ once reversed because then e.g. cytosine methylation will be assessed
#' at guanines, which SAMtools can't account for. Symmetrically reversing CpGs via `offset = 1` is
#' the only way to fix this.
#'
#' @param locations_vector `character vector`. The locations to be reversed for each sequence/read. Each read should have one character value, representing a comma-separated list of indices at which modification was assessed along the read e.g. `"3,6,9,12"` for all the `Cs` in `GGCGGCGGCGGC`.\cr\cr These comma-separated characters/strings can be produced from numeric vectors via [vector_to_string()] and converted back to vectors via [string_to_vector()].
#' @param direction_vector `character vector`. Whether each sequence is forward or reverse. Must contain only `"forward"` and `"reverse"`, but is not case sensitive. Must be the same length as `locations_vector` and `length_vector`.
#' @param length_vector `integer vector`. The length of each sequence. Needed for reversing locations as locations are stored relative to the start of the read i.e. relative to the end of the reverse read. Must be the same length as `locations_vector` and `direction_vector`.
#' @param offset `integer`. How much locations should be shifted by. Defaults to `0`. This is important because if a CpG is assessed for methylation at the C, then reverse complementing it will give a methylation score at the G on the reverse-complemented strand. This is the most biologically accurate, but for visualising methylation it may be desired to shift the locations by `1` i.e. to correspond with the C in the reverse-complemented CpG rather than the G, which allows for consistent visualisation between forward and reverse strands. Setting (integer) values other than `0` or `1` will work, but may be biologically misleading so it is not recommended.
#'
#' @return `character vector`. A vector of all forward versions of the input locations vector.
#'
#' @examples
#' reverse_locations_if_needed(
#'     locations_vector = c("7,10,13,17", "2,6,9,12"),
#'     direction_vector = c("forward", "reverse"),
#'     length_vector = c(19, 19),
#'     offset = 0
#' )
#'
#' reverse_locations_if_needed(
#'     locations_vector = c("7,10,13,17", "2,6,9,12"),
#'     direction_vector = c("forward", "reverse"),
#'     length_vector = c(19, 19),
#'     offset = 1
#' )
#'
#' @export
reverse_locations_if_needed <- function(locations_vector, direction_vector, length_vector, offset = 0) {
    ## Validate arguments
    for (argument in list(direction_vector, length_vector, offset)) {
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
            ## Allow NA values, in which case we just keep the NA. If not NA, reverse locations
            if (!is.na(locations_vector[i])) {
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
                new_locations_vector[i] <- NA
            }
        } else {
            abort("direction vector must contain only 'forward' and 'reverse' (not case sensitive)", class = "argument_value_or_type")
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
#' [reverse_sequence_if_needed()], [reverse_quality_if_needed()], and [reverse_locations_if_needed()].\cr\cr
#'
#' @param probabilities_vector `character vector`. The probabilities to be reversed for each sequence/read. Each read should have one character value, representing a comma-separated list of the modification probabilities for each assessed base along the read e.g. `"230,7,64,145"`. In most situations these will be 8-bit integers from 0 to 255, but this function will work on any comma-separated values.\cr\cr These comma-separated characters/strings can be produced from numeric vectors via [vector_to_string()] and converted back to vectors via [string_to_vector()].
#' @param direction_vector `character vector`. Whether each sequence is forward or reverse. Must contain only `"forward"` and `"reverse"`, but is not case sensitive. Must be the same length as `probabilities_vector`.
#'
#' @return `character vector`. A vector of all forward versions of the input probabilities vector.
#'
#' @examples
#' reverse_probabilities_if_needed(
#'     probabilities_vector = c("100,200,50", "100,200,50"),
#'     direction_vector = c("forward", "reverse")
#' )
#'
#' @export
reverse_probabilities_if_needed <- function(probabilities_vector, direction_vector) {
    ## Validate arguments
    for (argument in list(direction_vector)) {
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
            ## If probabilites vector is NA leave it unchanged, otherwise reverse it
            if (!is.na(probabilities_vector[i])) {
                probabilities_to_reverse <- string_to_vector(probabilities_vector[i])
                if (any(is.na(probabilities_to_reverse))) {abort("Invalid value in probabilities vector", class = "argument_value_or_type")}
                new_probabilities_vector[i] <- vector_to_string(rev(probabilities_to_reverse))
            } else {
                new_probabilities_vector[i] <- NA
            }
        } else {
            abort("direction vector must contain only 'forward' and 'reverse' (not case sensitive)", class = "argument_value_or_type")
        }
    }
    return(new_probabilities_vector)
}

## ----------------------------------------------------------------------------------------
