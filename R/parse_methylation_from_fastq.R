## READING FROM FASTQ
## -------------------------------------------------------------------------------------

#' Read sequence and quality information from FASTQ
#'
#' This function simply reads a FASTQ file into a dataframe containing
#' columns for read ID, sequence, and quality scores.
#' Optionally also contains a column of sequence lengths.\cr\cr
#' See [`fastq_quality_scores`] for an explanation of quality.\cr\cr
#' Resulting dataframe can be written back to FASTQ via [write_fastq()].
#' To read/write a modified FASTQ containing modification information
#' (SAM/BAM MM and ML tags) in the header lines, use
#' [read_modified_fastq()] and [write_modified_fastq()].
#'
#' @param filename `character`. The file to be read. Defaults to [file.choose()] to select a file interactively.
#' @param calculate_length `logical`. Whether or not `sequence_length` column should be calculated and included.
#'
#' @return `dataframe`. A dataframe with `read`, `sequence`, `quality`, and optionally `sequence_length` columns.
#'
#' @examples
#' ## Locate file
#' fastq_file <- system.file("extdata",
#'                           "example_many_sequences_raw.fastq",
#'                           package = "ggDNAvis")
#'
#' ## View file
#' for (i in 1:16) {
#'     cat(readLines(fastq_file)[i], "\n")
#' }
#'
#' ## Read file to dataframe
#' read_fastq(fastq_file, calculate_length = FALSE)
#' read_fastq(fastq_file, calculate_length = TRUE)
#'
#' @export
read_fastq <- function(filename = file.choose(), calculate_length = TRUE) {
    ## Validate arguments
    for (argument in list(filename, calculate_length)) {
        if (length(argument) != 1 || mean(is.na(argument)) != 0 || mean(is.null(argument)) != 0) {
            abort(paste("Argument", argument, "must be a single value and not NA or NULL."), class = "argument_value_or_type")
        }
    }
    if (is.character(filename) == FALSE) {
        abort("Filename must be a character/string value.", class = "argument_value_or_type")
    }
    if (is.logical(calculate_length) == FALSE) {
        abort("calculate_length must be a logical/boolean value.", class = "argument_value_or_type")
    }

    ## Read and parse FASTQ
    input_fastq <- readLines(filename)

    headers   <- input_fastq[1:length(input_fastq) %% 4 == 1]
    sequences <- input_fastq[1:length(input_fastq) %% 4 == 2]
    qualities <- input_fastq[1:length(input_fastq) %% 4 == 0]

    ## Create dataframe
    output_data <- data.frame(read = headers, sequence = sequences, quality = qualities)
    if (calculate_length) {
        output_data$sequence_length <- nchar(output_data$sequence)
    }

    return(output_data)
}


#' Read modification information from modified FASTQ
#'
#' This function reads a modified FASTQ file (e.g. created by `samtools fastq -T MM,ML`
#' from a BAM basecalled with a modification-capable model in Dorado or Guppy) to a dataframe.\cr\cr
#' By default, the dataframe contains columns for unique read id (`read`), sequence (`sequence`),
#' sequence length (`sequence_length`), quality (`quality`), comma-separated (via [vector_to_string()])
#' modification types present in each read (`modification_types`), and for each modification type,
#' a column of comma-separated modification locations (`<type>_locations`) and
#' a column of comma-separated modification probabilities (`<type>_probabilities`).\cr\cr
#' Modification locations are the indices along the read at which modification was assessed
#' e.g. a 3 indicates that the third base in the read was assessed for modifications of the given type.
#' Modification probabilities are the probability that the given modification is present, given as
#' an integer from 0-255 where integer \eqn{N} represents the probability space from \eqn{\frac{N}{256}}
#' to \eqn{\frac{N+1}{256}}.\cr\cr
#' To extract the numbers from these columns as numeric vectors to analyse, use [`string_to_vector()`] e.g.
#' ``list_of_locations <- lapply(test_01$`C+h?_locations`, string_to_vector)``. Be aware that the SAM
#' modification types often contain special characters, meaning the colname may need to be enclosed in
#' backticks as in this example. Alternatively, use [extract_methylation_from_dataframe()] to
#' create a list of locations, probabilities, and lengths ready for visualisation in
#' [visualise_methylation()]. This works with any modification type extracted in this function,
#' just provide the relevant colname when calling [extract_methylation_from_dataframe()].\cr\cr
#' Optionally (by specifying `debug = TRUE`), the dataframe will also contain columns of
#' the raw MM and ML tags (`<MM/ML>_raw`) and of the same tags with the initial label
#' trimmed out (`<MM/ML>_tags`). This is not recommended in most situations but may help
#' with debugging unexpected issues as it contains the raw data exactly from the FASTQ.\cr\cr
#' Dataframes produced by this function can be written back to modified FASTQ via [write_modified_fastq()].
#'
#' @param filename `character`. The file to be read. Defaults to [file.choose()] to select a file interactively.
#' @param debug `logical`. Boolean value for whether the extra `<MM/ML>_tags` and `<MM/ML>_raw` columns should be added to the dataframe. Defaults to `FALSE` as I can't imagine this is often helpful, but the option is provided to assist with debugging.
#'
#' @return `dataframe`. Dataframe of modification information, as described above.\cr\cr Sequences can be visualised with [visualise_many_sequences()] and modification information can be visualised with [visualise_methylation()] (despite the name, any type of information can be visualised as long as it has locations and probabilities columns).\cr\cr Can be written back to FASTQ via [write_modified_fastq()].
#'
#' @examples
#' ## Locate file
#' modified_fastq_file <- system.file("extdata",
#'                                    "example_many_sequences_raw_modified.fastq",
#'                                    package = "ggDNAvis")
#'
#' ## View file
#' for (i in 1:16) {
#'     cat(readLines(modified_fastq_file)[i], "\n")
#' }
#'
#' ## Read file to dataframe
#' read_modified_fastq(modified_fastq_file, debug = FALSE)
#' read_modified_fastq(modified_fastq_file, debug = TRUE)
#'
#' @export
read_modified_fastq <- function(filename = file.choose(), debug = FALSE) {
    ## Validate arguments
    for (argument in list(filename, debug)) {
        if (length(argument) != 1 || mean(is.na(argument)) != 0 || mean(is.null(argument)) != 0) {
            abort(paste("Argument", argument, "must be a single value and not NA or NULL."), class = "argument_value_or_type")
        }
    }
    if (is.character(filename) == FALSE) {
        abort("Filename must be a character/string value.", class = "argument_value_or_type")
    }
    if (is.logical(debug) == FALSE) {
        abort("debug must be a logical/boolean value.", class = "argument_value_or_type")
    }


    ## Parse FASTQ header - would be difficult to use alone as it requires
    ## specifically formatted headers. So defined within scope of master function.
    parse_fastq_header <- function(headers, sequences, debug = FALSE) {
        split_headers <- strsplit(headers, split = "\t")
        if (mean(sapply(split_headers, length) == 3) != 1) {
            abort("FASTQ parsing assumes headers contain the read ID, the MM tag, and the ML tag, all separated by tabs (as generated by samtools fastq -T MM,ML). This means the header should give a vector of length 3 when split on tab ('\\t'). The current lengths are not all 3, meaning at least one header has an incorrect number of tags.", class = "argument_value_or_type")
        }

        read_ids <- sapply(split_headers, function(x) x[1])
        MM_raw   <- sapply(split_headers, function(x) x[2])
        ML_raw   <- sapply(split_headers, function(x) x[3])

        MM_tags <- substr(MM_raw, 6, nchar(MM_raw))  ## Remove "MM:Z:"
        ML_tags <- substr(ML_raw, 8, nchar(ML_raw))  ## Remove "ML:B:C,"

        ## WORKING ON MM:
        ## Extract MM tag into vectors of skipped bases numbers
        modification_skips_raw <- strsplit(MM_tags, split = ";")

        # this old version assumed the modification types were always 4 characters long
        #modification_types <- lapply(modification_skips_raw, function(x) substr(x, 1, 4))  ## Extract 4-digit modification types
        #modification_skips <- lapply(modification_skips_raw, function(x) substr(x, 6, nchar(x))) ## Extract numerical modification locations

        # this new version should work regardless of length
        modification_types <- lapply(modification_skips_raw, function(x) sapply(strsplit(x, ","), function(y) y[1]))
        modification_skips <- lapply(modification_skips_raw, function(x) sapply(strsplit(x, ","), function(y) {
            if (length(y) > 1) {
                return(vector_to_string(y[2:length(y)]))
            } else {
                return("")
            }
        }))


        ## Convert MM tags into absolute vectors of
        modification_locations <- list()
        for (i in 1:length(read_ids)) {
            read_locations <- character()
            for (j in 1:length(modification_skips[[i]])) {
                this_type       <- modification_types[[i]][j]
                this_type_skips <- modification_skips[[i]][j]
                target_base <- substr(this_type, 1, 1)

                this_type_locations <- convert_MM_vector_to_locations(sequences[i], string_to_vector(this_type_skips), target_base)
                read_locations <- c(read_locations, vector_to_string(this_type_locations))
            }
            modification_locations[[i]] <- read_locations
        }

        ## WORKING ON ML:
        ## Calculate how many CpGs (or other bases) were assessed for each type of modification along each read
        modification_lengths <- lapply(modification_skips, function(x) {
            sapply(x, function(y) length(string_to_vector(y)))
        })

        ## Go along the ML tag and extract the relevant indices of probabilities
        modification_probabilities <- list()
        for (i in 1:length(read_ids)) {
            read_probabilities <- character()

            start <- 1
            end <- 0
            for (length in modification_lengths[[i]]) {
                end <- end + length

                if (length != 0) {
                    this_type_probabilities <- string_to_vector(ML_tags[i])[start:end]
                } else {
                    this_type_probabilities <- ""
                }

                read_probabilities <- c(read_probabilities, vector_to_string(this_type_probabilities))
                start <- start + length
            }

            modification_probabilities[[i]] <- read_probabilities
        }

        ## Return important values in list
        if (debug == TRUE) {
            return(list(
                read_ids = read_ids,
                modification_types = modification_types,
                modification_locations = modification_locations,
                modification_probabilities = modification_probabilities,
                MM_tags = MM_tags,
                ML_tags = ML_tags,
                MM_raw  = MM_raw,
                ML_raw  = ML_raw
            ))
        } else if (debug == FALSE) {
            return(list(
                read_ids = read_ids,
                modification_types = modification_types,
                modification_locations = modification_locations,
                modification_probabilities = modification_probabilities
            ))
        } else {
            abort("debug needs to be a logical/boolean value", class = "argument_value_or_type")
        }

    }




    ## Read and parse FASTQ
    input_fastq <- readLines(filename)

    headers   <- input_fastq[1:length(input_fastq) %% 4 == 1]
    sequences <- input_fastq[1:length(input_fastq) %% 4 == 2]
    qualities <- input_fastq[1:length(input_fastq) %% 4 == 0]

    header_info <- parse_fastq_header(headers, sequences, debug)
    modification_data <- data.frame(read = header_info$read_id,
                                    sequence = sequences,
                                    sequence_length = nchar(sequences),
                                    quality = qualities,
                                    modification_types = sapply(header_info$modification_types, vector_to_string))


    ## Add MM and ML tags to dataframe to assist debugging
    if (debug == TRUE) {
        modification_data$MM_tags <- header_info$MM_tags
        modification_data$ML_tags <- header_info$ML_tags
        modification_data$MM_raw  <- header_info$MM_raw
        modification_data$ML_raw  <- header_info$ML_raw
    }


    ## Dynamically create columns for all modification types present
    all_modification_types <- unique(unlist(header_info$modification_types))
    for (modification_type in all_modification_types) {
        for (i in 1:nrow(modification_data)) {
            if (modification_type %in% header_info$modification_types[[i]]) {
                index = which(header_info$modification_types[[i]] == modification_type)[1]
                modification_data[i, paste0(modification_type, "_locations")]     <- header_info$modification_locations[[i]][index]
                modification_data[i, paste0(modification_type, "_probabilities")] <- header_info$modification_probabilities[[i]][index]
            }
        }
    }

    ## Return result
    return(modification_data)
}



#' Convert MM tag to absolute index locations ([read_modified_fastq()] helper)
#'
#' This function takes a sequence, a SAM-style vector of number of potential
#' target bases to skip in between each target base that was actually assessed,
#' and a target base type (defaults to `"C"` as 5-methylcytosine is most common).\cr\cr
#' It identifies the indices/locations of all instances of the target base within the
#' sequence, and then goes along the vector of these indices, skipping them if requested
#' by `skips`.\cr\cr
#' For example, the sequence `"GGCGGCGGCGGC"` with target `"C"` and skips `c(0, 0, 1)`
#' would identify that the indices where `"C"` occurs are `c(3, 6, 9, 12)`. It would then
#' take the first index, the second index, skip one, and take the fourth index i.e.
#' return `c(3, 6, 12)`. If instead the skips were given as `c(0, 2)` it would take the
#' first index, skip two, and take the fourth index i.e. return `c(3, 12)`. If the skips
#' were given as `c(1, 1)` it would skip one, take the second index, skip one, and take
#' the fourth index i.e. return `c(6, 12)`. \cr\cr
#' The length of `skips` corresponds to the number of indices/locations that will be returned
#' (i.e. the length of the returned locations vector).\cr\cr
#' Ideally the length of `skips` plus the sum of `skips` (i.e. the number returned plus the
#' total number skipped) is the same or less than the number of possible locations. If it is
#' the same, then the last possible location will be taken; if it is less then some number of
#' possible locations at the end will be skipped.\cr\cr
#' **Important:** if the length of `skips` plus the sum of `skips` is greater than the number
#' of possible locations (instances of the target base within the sequence), then the total
#' number of taken or skipped locations will be greater than the number of available locations.
#' In this case, the returned vector will contain NA after the available locations have run out.
#' In the example above, `skips = c(0, 0, 0, 0, 0)` would return `c(3, 6, 9, 12, NA)`, and
#' `skips = c(0, 2, 0)` would return `c(3, 12, NA)`.\cr\cr
#' Therefore, if the target base is totally absent from the sequence (e.g. target `"A"` in
#' `"GGCGGCGGCGGC"`), then any non-zero length of `skips` will return the same length of `NA`s e.g.
#' `skips = c(0)` would return `NA`, and `skips = c(0, 1, 0)` would return `c(NA, NA, NA)`.\cr\cr
#' If `skips` has length zero, it will return `numeric(0)`.\cr\cr
#' This function is reversed by [convert_locations_to_MM_vector()].
#'
#' @param sequence `character`. The DNA sequence about which the methylation information is being processed.
#' @param skips `integer vector`. A component of a SAM MM tag, representing the number of skipped target bases in between each assessed base.
#' @param target_base `character`. The base type that has been assessed or skipped (defaults to `"C"`).
#'
#' @return `integer vector`. All of the base indices at which methylation/modification information was processed. Will all be instances of the target base.
#'
#' @examples
#' convert_MM_vector_to_locations(
#'     "GGCGGCGGCGGC",
#'     skips = c(0, 0, 0, 0),
#'     target_base = "C"
#' )
#'
#' convert_MM_vector_to_locations(
#'     "GGCGGCGGCGGC",
#'     skips = c(1, 1, 1, 1),
#'     target_base = "G"
#' )
#'
#' convert_MM_vector_to_locations(
#'     "GGCGGCGGCGGC",
#'     skips = c(0, 0, 2, 1, 0),
#'     target_base = "G"
#' )
#'
#' @export
convert_MM_vector_to_locations <- function(sequence, skips, target_base = "C") {
    ## Validate arguments
    for (argument in list(sequence, target_base)) {
        if (mean(is.null(argument)) != 0 || (length(argument) > 0 && mean(is.na(argument)) != 0)) {abort(paste("Argument", argument, "must not be NULL or NA."), class = "argument_value_or_type")}
    }
    for (argument in list(sequence, target_base)) {
        if (is.character(argument) == FALSE || length(argument) != 1) {abort(paste("Argument", argument, "must be a single character/string value."), class = "argument_value_or_type")}
    }
    if (length(skips) == 0 || mean(is.na(skips)) != 0 || mean(is.null(skips)) != 0) {
        return(numeric())
    }
    if (is.numeric(skips) == FALSE || mean(skips >= 0) != 1 || mean(skips %% 1 == 0) != 1) {
        abort("Skips vector must be contain only non-negative integers", class = "argument_value_or_type")
    }


    ## This took a bit to wrap my head around.
    ## As an example, imagine "GGCGGCGGCGGC" where we are interested in "C".
    ## All possible locations would be c(3, 6, 9, 12).
    ## If we decided to target the first, second, and fourth "C", the output
    ## locations vector would need to be c(3, 6, 12).
    ## Thinking about the indices within the all possible locations vector, we would
    ## need to take the location numbers at indexes 1, 2, and 4.
    ## The input skips vector would be c(0, 0, 1) to indicate
    ## that we take the first two Cs, then skip one and take the fourth.
    ## (this comes directly from the SAM specifications)
    ## If we add 1 to that to get c(1, 1, 2), we can then apply a triangle
    ## numbers approach where we add up all previous values along the
    ## vector and end up with c(1, 2, 4), implemented via cumsum().
    ## This is the indices we want within the all possible locations vector.

    all_possible_locations <- unname(str_locate_all(sequence, target_base)[[1]][,1])
    if (length(skips) + sum(skips) > length(all_possible_locations)) {
        warn("The provided 'skips' vector takes/skips more locations than the number of times the targeted base occurs in the sequence. Therefore, some or all of the returned locations will be NA.", class = "will_produce_NA")
    }

    selected_locations <- all_possible_locations[cumsum(skips+1)]
    return(selected_locations)
}
## -------------------------------------------------------------------------------------







## WRITING TO FASTQ
## -------------------------------------------------------------------------------------

#' Write sequence and quality information to FASTQ
#'
#' This function simply writes a FASTQ file from a dataframe containing
#' columns for read ID, sequence, and quality scores.\cr\cr
#' See [`fastq_quality_scores`] for an explanation of quality.\cr\cr
#' Said dataframe can be produced from FASTQ via [read_fastq()].
#' To read/write a modified FASTQ containing modification information
#' (SAM/BAM MM and ML tags) in the header lines, use
#' [read_modified_fastq()] and [write_modified_fastq()].
#'
#' @param dataframe `dataframe`. Dataframe containing modification information to write back to modified FASTQ. Must have columns for unique read ID and DNA sequence. Should also have a column for quality, unless wanting to fill in qualities with `"B"`.
#' @param filename `character`. File to write the FASTQ to. Recommended to end with `.fastq` (warns but works if not). If set to `NA` (default), no file will be output, which may be useful for testing/debugging.
#' @param read_id_colname `character`. The name of the column within the dataframe that contains the unique ID for each read. Defaults to `"read"`.
#' @param sequence_colname `character`. The name of the column within the dataframe that contains the DNA sequence for each read. Defaults to `"sequence"`.\cr\cr The values within this column must be DNA sequences e.g. `"GGCGGC"`.
#' @param quality_colname `character`. The name of the column within the dataframe that contains the FASTQ quality scores for each read. Defaults to `"quality"`. If scores are not known, can be set to `NA` to fill in quality with `"B"`.\cr\cr If not `NA`, must correspond to a column where the values are the FASTQ quality scores e.g. `"$12\">/2C;4:9F8:816E,6C3*,"` - see [`fastq_quality_scores`].
#' @param return `logical`. Boolean specifying whether this function should return the FASTQ (as a character vector of each line in the FASTQ), otherwise it will return `invisible(NULL)`. Defaults to `FALSE`.
#'
#' @return `character vector`. The resulting FASTQ file as a character vector of its constituent lines (or `invisible(NULL)` if `return` is `FALSE`). This is probably mostly useful for debugging, as setting `filename` within this function directly writes to FASTQ via [writeLines()]. Therefore, defaults to returning `invisible(NULL)`.
#'
#' @examples
#' ## Write to FASTQ (using filename = NA, return = FALSE
#' ## to view as char vector rather than writing to file)
#' write_fastq(
#'     example_many_sequences,
#'     filename = NA,
#'     read_id_colname = "read",
#'     sequence_colname = "sequence",
#'     quality_colname = "quality",
#'     return = TRUE
#' )
#'
#' ## quality_colname = NA fills in quality with "B"
#' write_fastq(
#'     example_many_sequences,
#'     filename = NA,
#'     read_id_colname = "read",
#'     sequence_colname = "sequence",
#'     quality_colname = NA,
#'     return = TRUE
#' )
#'
#' @export
write_fastq <- function(dataframe, filename = NA, read_id_colname = "read", sequence_colname = "sequence", quality_colname = "quality", return = FALSE) {
    ## Validate arguments
    for (argument in list(dataframe, filename, read_id_colname, sequence_colname, quality_colname, return)) {
        if (mean(is.null(argument)) != 0) {abort(paste("Argument", argument, "must not be NULL."), class = "argument_value_or_type")}
    }
    for (argument in list(filename, read_id_colname, sequence_colname, quality_colname, return)) {
        if (length(argument) != 1) {abort(paste("Argument", argument, "must have length 1."), class = "argument_value_or_type")}
    }
    for (argument in list(read_id_colname, sequence_colname, return)) {
        if (mean(is.na(argument)) != 0) {abort(paste("Argument", argument, "must not be NA."), class = "argument_value_or_type")}
    }
    for (argument in list(return)) {
        if (is.logical(argument) == FALSE) {abort("return must be a logical/boolean value.", class = "argument_value_or_type")}
    }
    for (argument in list(filename, read_id_colname, sequence_colname, quality_colname)) {
        if (mean(is.na(argument)) == 0 && is.character(argument) == FALSE) {abort(paste("Argument", argument, "must be of type character."), class = "argument_value_or_type")}
    }
    for (colname in c(read_id_colname, sequence_colname, quality_colname)) {
        if (is.na(colname) == FALSE && colname %in% colnames(dataframe) == FALSE) {abort(paste0("There is no column called '", colname, "' in the dataframe."), class = "argument_value_or_type")}
    }


    ## Main function body
    output <- character()
    for (i in 1:nrow(dataframe)) {

        read_id  <- dataframe[i, read_id_colname]
        sequence <- dataframe[i, sequence_colname]
        spacer   <- "+"
        if (is.na(quality_colname)) {
            ## This matches the behaviour of SAMtools v1.21 when given FASTA input
            ## then converted to FASTQ via SAM/BAM. Quality gets filled in as "B".
            quality <- paste(rep("B", nchar(sequence)), collapse = "")
        } else {
            quality <- dataframe[i, quality_colname]
        }

        output <- c(output, read_id, sequence, spacer, quality)
    }

    ## Check if filename is set and warn if not fastq, then export file
    if (is.na(filename) == FALSE) {
        if (is.character(filename) == FALSE) {
            abort("Filename must be a character/string (or NA if no file export wanted)", class = "argument_value_or_type")
        }
        if (tolower(substr(filename, nchar(filename)-5, nchar(filename))) != ".fastq") {
            warn("Output will be formatted as FASTQ even if file extension is different.", class = "filetype_recommendation")
        }
        writeLines(output, filename)
    }

    ## Return either the plot object or NULL
    if (return == TRUE) {
        return(output)
    }
    return(invisible(NULL))
}



#' Write modification information stored in dataframe back to modified FASTQ
#'
#' This function takes a dataframe containing DNA modification information
#' (e.g. produced by [read_modified_fastq()]) and writes it back to modified
#' FASTQ, equivalent to what would be produced via `samtools fastq -T MM,ML`.\cr\cr
#' Arguments give the names of columns within the dataframe from which to read.\cr\cr
#' If multiple types of modification have been assessed (e.g. both methylation
#' and hydroxymethylation), then multiple colnames must be provided for locations
#' and probabilites, and multiple prefixes (e.g. `"C+h?"`) must be provided.
#' **IMPORTANT:** These three vectors must all be the same length, and the modification
#' types must be in a consistent order (e.g. if writing hydroxymethylation and methylation
#' in that order, must do H then M in all three vectors and never vice versa).\cr\cr
#' If quality isn't known (e.g. there was a FASTA step at some point in the pipeline),
#' the `quality` argument can be set to `NA` to fill in quality scores with `"B"`. This
#' is the same behaviour as SAMtools v1.21 when converting FASTA to SAM/BAM then FASTQ.
#' I don't really know why SAMtools decided the default quality should be "B" but there
#' was probably a reason so I have stuck with that.\cr\cr
#' Default arguments are set up to work with the included [`example_many_sequences`] data.
#'
#' @param dataframe `dataframe`. Dataframe containing modification information to write back to modified FASTQ. Must have columns for unique read ID, DNA sequence, and at least one set of locations and probabilities for a particular modification type (e.g. 5C methylation).
#' @param filename `character`. File to write the modified FASTQ to. Recommended to end with `.fastq` (warns but works if not). If set to `NA` (default), no file will be output, which may be useful for testing/debugging.
#' @param read_id_colname `character`. The name of the column within the dataframe that contains the unique ID for each read. Defaults to `"read"`.
#' @param sequence_colname `character`. The name of the column within the dataframe that contains the DNA sequence for each read. Defaults to `"sequence"`.\cr\cr The values within this column must be DNA sequences e.g. `"GGCGGC"`.
#' @param quality_colname `character`. The name of the column within the dataframe that contains the FASTQ quality scores for each read. Defaults to `"quality"`. If scores are not known, can be set to `NA` to fill in quality with `"B"`.\cr\cr If not `NA`, must correspond to a column where the values are the FASTQ quality scores e.g. `"$12\">/2C;4:9F8:816E,6C3*,"` - see [`fastq_quality_scores`].
#' @param locations_colnames `character vector`. Vector of the names of all columns within the dataframe that contain modification locations. Defaults to `c("hydroxymethylation_locations", "methylation_locations")`.\cr\cr The values within these columns must be comma-separated strings of indices at which modification was assessed, as produced by [vector_to_string()], e.g. `"3,6,9,12"`.\cr\cr Will fail if these locations are not instances of the target base (e.g. `"C"` for `"C+m?"`), as the SAMtools tag system does not work otherwise. One consequence of this is that if sequences have been reversed via [merge_methylation_with_metadata()] or helpers, they cannot be written to FASTQ *unless* modification locations are symmetric e.g. CpG *and* offset was set to `1` when reversing (see [reverse_locations_if_needed()]).
#' @param probabilities_colnames `character vector`. Vector of the names of all columns within the dataframe that contain modification probabilities. Defaults to `c("hydroxymethylation_probabilities", "methylation_probabilities")`.\cr\cr The values within the columns must be comma-separated strings of modification probabilities, as produced by [vector_to_string()], e.g. `"0,255,128,78"`.
#' @param modification_prefixes `character vector`. Vector of the prefixes to be used for the MM tags specifying modification type. These are usually generated by Dorado/Guppy based on the original modified basecalling settings, and more details can be found in the SAM optional tag specifications. Defaults to `c("C+h?", "C+m?")`.\cr\cr `locations_colnames`, `probabilities_colnames`, and `modification_prefixes` must all have the same length e.g. 2 if there were 2 modification types assessed.
#' @param include_blank_tags `logical`. Boolean specifying what to do if a particular read has no assessed locations for a given modification type from `modification_prefixes`.\cr\cr If `TRUE` (default), blank tags will be written e.g. `"C+h?;"` (whereas a normal, non-blank tag looks like `"C+h?,0,0,0,0;"`). If `FALSE`, tags with no assessed locations in that read will not be written at all.
#' @param return `logical`. Boolean specifying whether this function should return the FASTQ (as a character vector of each line in the FASTQ), otherwise it will return `invisible(NULL)`. Defaults to `FALSE`.
#'
#' @return `character vector`. The resulting modified FASTQ file as a character vector of its constituent lines (or `invisible(NULL)` if `return` is `FALSE`). This is probably mostly useful for debugging, as setting `filename` within this function directly writes to FASTQ via [writeLines()]. Therefore, defaults to returning `invisible(NULL)`.
#'
#' @examples
#' ## Write to FASTQ (using filename = NA, return = FALSE
#' ## to view as char vector rather than writing to file)
#' write_modified_fastq(
#'     example_many_sequences,
#'     filename = NA,
#'     read_id_colname = "read",
#'     sequence_colname = "sequence",
#'     quality_colname = "quality",
#'     locations_colnames = c("hydroxymethylation_locations",
#'                            "methylation_locations"),
#'     probabilities_colnames = c("hydroxymethylation_probabilities",
#'                                "methylation_probabilities"),
#'     modification_prefixes = c("C+h?", "C+m?"),
#'     return = TRUE
#' )
#'
#' ## Write methylation only, and fill in qualities with "B"
#' write_modified_fastq(
#'     example_many_sequences,
#'     filename = NA,
#'     read_id_colname = "read",
#'     sequence_colname = "sequence",
#'     quality_colname = NA,
#'     locations_colnames = c("methylation_locations"),
#'     probabilities_colnames = c("methylation_probabilities"),
#'     modification_prefixes = c("C+m?"),
#'     return = TRUE
#' )
#'
#' @export
write_modified_fastq <- function(dataframe, filename = NA, read_id_colname = "read", sequence_colname = "sequence", quality_colname = "quality", locations_colnames = c("hydroxymethylation_locations", "methylation_locations"), probabilities_colnames = c("hydroxymethylation_probabilities", "methylation_probabilities"), modification_prefixes = c("C+h?", "C+m?"), include_blank_tags = TRUE, return = FALSE) {
    ## Validate arguments
    for (argument in list(dataframe, filename, read_id_colname, sequence_colname, quality_colname, locations_colnames, probabilities_colnames, modification_prefixes, include_blank_tags, return)) {
        if (mean(is.null(argument)) != 0) {abort(paste("Argument", argument, "must not be NULL."), class = "argument_value_or_type")}
    }
    for (argument in list(filename, read_id_colname, sequence_colname, quality_colname, include_blank_tags, return)) {
        if (length(argument) != 1) {abort(paste("Argument", argument, "must have length 1."), class = "argument_value_or_type")}
    }
    for (argument in list(locations_colnames, probabilities_colnames, modification_prefixes)) {
        if (length(argument) < 1) {abort(paste("Argument", argument, "must have length of at least 1."), class = "argument_value_or_type")}
    }
    for (argument in list(read_id_colname, sequence_colname, locations_colnames, probabilities_colnames, modification_prefixes, include_blank_tags, return)) {
        if (mean(is.na(argument)) != 0) {abort(paste("Argument", argument, "must not be NA."), class = "argument_value_or_type")}
    }
    for (argument in list(include_blank_tags, return)) {
        if (is.logical(argument) == FALSE) {abort("return must be a logical/boolean value.", class = "argument_value_or_type")}
    }
    for (argument in list(filename, read_id_colname, sequence_colname, quality_colname, locations_colnames, probabilities_colnames, modification_prefixes)) {
        if (mean(is.na(argument)) == 0 && is.character(argument) == FALSE) {abort(paste("Argument", argument, "must be of type character."), class = "argument_value_or_type")}
    }
    for (colname in c(read_id_colname, sequence_colname, quality_colname, locations_colnames, probabilities_colnames)) {
        if (is.na(colname) == FALSE && colname %in% colnames(dataframe) == FALSE) {abort(paste0("There is no column called '", colname, "' in the dataframe."), class = "argument_value_or_type")}
    }
    if (length(locations_colnames) != length(probabilities_colnames) ||
        length(locations_colnames) != length(modification_prefixes) ||
        length(probabilities_colnames) != length(modification_prefixes)) {
        abort("The vectors of location column names, probability column names, and modification prefixes must all be the same length e.g. 2 if there are 2 types of modification in the data.", class = "argument_value_or_type")
    }


    ## This function would be difficult to use, and I can't imagine many use
    ## cases for it outside of the main function. So it is defined within
    ## it and not exported.
    construct_header <- function(read_id, sequence, locations_list, probabilities_list, modification_prefixes, include_blank_tags) {
        MM <- "MM:Z:"
        ML <- "ML:B:C"
        for (i in 1:length(modification_prefixes)) {
            modification_type <- modification_prefixes[i]
            locations         <- string_to_vector(locations_list[[i]])
            target_base       <- substr(modification_type, 1, 1)

            ## Empty tags are allowed but must not have the intervening comma
            this_MM_vector <- convert_locations_to_MM_vector(sequence, locations, target_base)
            if (length(this_MM_vector) == 0) {
                if (include_blank_tags == TRUE) {
                    this_MM <- paste0(modification_type, ";")
                } else {
                    this_MM <- NULL
                }
            } else {
                this_MM <- paste0(modification_type, ",", vector_to_string(this_MM_vector), ";")
            }
            MM <- paste0(MM, this_MM)


            ## If probabilities list is missing, skip ML
            if (!is.na(probabilities_list[[i]]) && probabilities_list[[i]] != "") {
                #this_ML <- vector_to_string(probabilities_list[[i]])
                this_ML <- probabilities_list[[i]]
                ML <- paste0(ML, ",", this_ML)
            }
        }

        header <- paste(read_id, MM, ML, sep = "\t")
        return(header)
    }


    ## Main function body
    output <- character()
    for (i in 1:nrow(dataframe)) {

        read_id  <- dataframe[i, read_id_colname]
        sequence <- dataframe[i, sequence_colname]
        header   <- construct_header(read_id, sequence, dataframe[i, locations_colnames], dataframe[i, probabilities_colnames], modification_prefixes, include_blank_tags)
        spacer   <- "+"
        if (is.na(quality_colname)) {
            ## This matches the behaviour of SAMtools v1.21 when given FASTA input
            ## then converted to FASTQ via SAM/BAM. Quality gets filled in as "B".
            quality <- paste(rep("B", nchar(sequence)), collapse = "")
        } else {
            quality <- dataframe[i, quality_colname]
        }

        output <- c(output, header, sequence, spacer, quality)
    }


    ## Check if filename is set and warn if not fastq, then export file
    if (is.na(filename) == FALSE) {
        if (is.character(filename) == FALSE) {
            abort("Filename must be a character/string (or NA if no file export wanted)", class = "argument_value_or_type")
        }
        if (tolower(substr(filename, nchar(filename)-5, nchar(filename))) != ".fastq") {
            warn("Output will be formatted as FASTQ even if file extension is different.", class = "filetype_recommendation")
        }
        writeLines(output, filename)
    }

    ## Return either the plot object or NULL
    if (return == TRUE) {
        return(output)
    }
    return(invisible(NULL))
}




#' Convert absolute index locations to MM tag ([write_modified_fastq()] helper)
#'
#' This function takes a vector of modified base locations as absolute indices
#' (i.e. a `1` would mean the first base in the sequence has been assessed for
#' modification; a `15` would mean the 15th base has), and converts it to a vector
#' in the format of the SAM/BAM MM tags. The MM tag defines a particular target base (e.g.
#' `C` for methylation), and then stores the number of skipped instances of that base
#' between sites where modification was assessed. In practice, this often means counting the
#' number of non-CpG `C`s in between CpG `C`s. In a `GGC` repeat, this should be a bunch of `0`s
#' as every `C` is in a CpG, but unique sequence will have many non-CpG `C`s.\cr\cr
#' This function is reversed by [convert_MM_vector_to_locations()].
#'
#' @param sequence `character`. The DNA sequence about which the methylation information is being processed.
#' @param locations `integer vector`. All of the base indices at which methylation/modification information was processed. Must all be instances of the target base.
#' @param target_base `character`. The base type that has been assessed or skipped (defaults to `"C"`).
#'
#' @return `integer vector`. A component of a SAM MM tag, representing the number of skipped target bases in between each assessed base.
#'
#' @examples
#' convert_locations_to_MM_vector(
#'     "GGCGGCGGCGGC",
#'     locations = c(3, 6, 9, 12),
#'     target_base = "C"
#' )
#'
#' convert_locations_to_MM_vector(
#'     "GGCGGCGGCGGC",
#'     locations = c(1, 4, 7, 10),
#'     target_base = "G"
#' )
#'
#' convert_locations_to_MM_vector(
#'     "GGCGGCGGCGGC",
#'     locations = c(1, 2, 4, 5, 7, 8, 10, 11),
#'     target_base = "G"
#' )
#'
#' @export
convert_locations_to_MM_vector <- function(sequence, locations, target_base = "C") {
    ## Validate arguments
    for (argument in list(sequence, target_base)) {
        if (mean(is.null(argument)) != 0 || (length(argument) > 0 && mean(is.na(argument)) != 0)) {abort(paste("Argument", argument, "must not be NULL or NA."), class = "argument_value_or_type")}
    }
    for (argument in list(sequence, target_base)) {
        if (is.character(argument) == FALSE || length(argument) != 1) {abort(paste("Argument", argument, "must be a single character/string value."), class = "argument_value_or_type")}
    }
    if (length(locations) == 0 || mean(is.na(locations)) != 0 || mean(is.null(locations)) != 0) {
        return(numeric())
    }
    if (is.numeric(locations) == 0 || mean(locations > 0) != 1 || mean(locations %% 1 == 0) != 1) {
        abort("Locations vector must be contain only positive integers", class = "argument_value_or_type")
    }

    all_possible_locations <- unname(str_locate_all(sequence, target_base)[[1]][,1])
    if (mean(locations %in% all_possible_locations) != 1) {
        abort("All locations provided must be indices where the target base occurs in the sequence\n(e.g. must all correspond to 'C' in the sequence if target_base is 'C')\nIf sequences were reversed, this will fail unless assessed locations are symmetric (e.g. CpG) and offset is set to 1 in reversing function.", class = "argument_value_or_type")
    }

    output_MM <- numeric()
    skipped_possible_bases <- 0
    for (possible_location in all_possible_locations) {
        if (possible_location %in% locations) {
            output_MM <- c(output_MM, skipped_possible_bases)
            skipped_possible_bases <- 0
        } else {
            skipped_possible_bases <- skipped_possible_bases + 1
        }
    }

    return(output_MM)
}
## -------------------------------------------------------------------------------------

