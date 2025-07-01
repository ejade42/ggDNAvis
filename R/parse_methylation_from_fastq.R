
## WRITING TO FASTQ
## -------------------------------------------------------------------------------------

#' Write modification information stored in dataframe back to modified FASTQ
#'
#' This function takes a dataframe containing DNA modification information
#' (e.g. produced by [insert_function_here()]) and writes it back to modified
#' FASTQ, equivalent to what would be produced via `samtools fastq -T MM,ML`.\cr\cr
#' Arguments give the names of columns within the dataframe from which to read.\cr\cr
#' If multiple types of modification have been assessed (e.g. both methylation
#' and hydroxymethylation), then multiple colnames must be provided for locations
#' and probabilites, and multiple prefixes (e.g. `"C+h?"`) must be provided.\cr\cr
#' If quality isn't known (e.g. there was a FASTA step at some point in the pipeline),
#' the `quality` argument can be set to `NA` to fill in quality scores with `"B"`. This
#' is the same behaviour as `SAMtools` v1.21 when converting FASTA to SAM/BAM then FASTQ.
#' I don't really know why `SAMtools` decided the default quality should be "B" but there
#' was probably a reason so I have stuck with that.
#'
#' @param dataframe `dataframe`. Dataframe containing modification information to write back to modified
#' UNFINISHED!!!!!
write_modified_fastq <- function(dataframe, filename = NA, read_id_colname = "read", sequence_colname = "sequence", quality_colname = NA, locations_colnames = c("methylation_locations"), probabilities_colnames = c("methylation_probabilities"), modification_prefixes = c("C+m?"), return = TRUE) {

    ## This function would be difficult to use, and I can't imagine many use
    ## cases for it, outside of the main function. So it is defined within
    ## it and not exported.
    construct_header <- function(read_id, sequence, locations_list, probabilities_list, modification_prefixes) {
        MM <- "MM:Z:"
        ML <- "ML:B:C,"
        for (i in 1:length(modification_prefixes)) {
            modification_type <- modification_prefixes[i]
            locations         <- string_to_vector(locations_list[[i]])
            target_base       <- substr(modification_type, 1, 1)

            this_MM <- paste0(modification_type, ",", vector_to_string(construct_MM_vector(sequence, locations, target_base)), ";")
            MM <- paste0(MM, this_MM)

            this_ML <- vector_to_string(probabilities_list[[i]])
            ML <- paste0(ML, this_ML)
        }

        header <- paste(read_id, MM, ML, sep = "\t")
        return(header)
    }

    ## Main function body
    output <- character()
    for (i in 1:nrow(dataframe)) {

        read_id  <- dataframe[i, read_id_colname]
        sequence <- dataframe[i, sequence_colname]
        header   <- construct_header(read_id, sequence, dataframe[i, locations_colnames], dataframe[i, probabilities_colnames], modification_prefixes)
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




    ## Check if filename is set and warn if not fastq, then export image
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
#' as every `C` is in a CpG, but unique sequence will have many non-CpG `C`s.
#'
#' @param sequence `character`. The DNA sequence about which the methylation information is being processed.
#' @param locations `integer vector`. All of the base indices at which methylation/modification information was processed. Must all be instances of the target base.
#' @param target_base `character`. The base type that has been assessed or skipped (defaults to `"C"`).
#'
#' @return `integer vector`. A component of a SAM MM tag, representing the number of skipped target bases in between each assessed base.
#' @export
convert_locations_to_MM_vector <- function(sequence, locations, target_base = "C") {
    ## Validate arguments
    for (argument in list(sequence, locations, target_base)) {
        if (mean(is.null(argument)) != 0 || (length(argument) > 0 && mean(is.na(argument)) != 0)) {abort(paste("Argument", argument, "must not be NULL or NA."), class = "argument_value_or_type")}
    }
    for (argument in list(sequence, target_base)) {
        if (is.character(argument) == FALSE || length(argument) != 1) {abort(paste("Argument", argument, "must be a single character/string value."), class = "argument_value_or_type")}
    }
    if (is.numeric(locations) == FALSE || (length(locations) > 0 && (mean(locations > 0) != 1 || mean(locations %% 1 == 0) != 1))) {
        abort("Locations vector must be contain only positive integers", class = "argument_value_or_type")
    }


    all_possible_locations <- str_locate_all(sequence, target_base)[[1]][,1]
    if (length(locations) > 0 && mean(locations %in% all_possible_locations) != 1) {
        abort("All locations provided must be indices where the target base occurs in the sequence\n(e.g. must all correspond to 'C' in the sequence if target_base is 'C').", class = "argument_value_or_type")
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

