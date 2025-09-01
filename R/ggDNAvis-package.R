#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import ggplot2
#' @import dplyr
#' @importFrom stringr str_locate_all
#' @importFrom tidyr replace_na
#' @importFrom rlang abort warn
#' @importFrom magick image_read image_compare
## usethis namespace: end
NULL

utils::globalVariables("example_many_sequences")
utils::globalVariables("sequence_colour_palettes")
utils::globalVariables("fastq_quality_scores")


## Helper function for dealing with different systems when comparing images
fetch_acceptable_distortion <- function(verbose = TRUE) {
    if (Sys.getenv("NOT_CRAN") == "false" || Sys.getenv("GITHUB_ACTIONS") == "true") {
        if (verbose) {print("GitHub actions/CRAN environment detected. Allowing lenience in plot matching.", quote = F)}

        if (Sys.info()[["sysname"]] == "Linux") {
            if (verbose) {print("Linux detected. Setting font to 'Liberation Sans' for Arial/Helvetica metric compability.", quote = F)}
            ggplot2::theme_update(text = element_text(family = "Liberation Sans"))
            acceptable_distortion <- 0.05
        }  else if (Sys.info()[["sysname"]] == "Windows") {
            if (verbose) {print("Windows detected. Not taking any special action.", quote = F)}
            acceptable_distortion <- 0.05
        } else if (Sys.info()[["sysname"]] == "Darwin") {
            if (verbose) {print("MacOS (Darwin) detected. Giving a little less lenience in plot matching as Helvetica is available.", quote = F)}
            acceptable_distortion <- 0.01
        } else {
            abort("Operating system not Linux/Windows/Darwin. Don't know what to do. Evelyn should take a look at this.", class = "unrecognised_OS")
        }

    } else if (Sys.info()[["sysname"]] == "Darwin") {
        if (verbose) {print("Running locally (MacOS assumed for Evelyn's development), use strict plot matching", quote = F)}
        acceptable_distortion <- 0.0001
    } else {
        if (verbose) {print("Unknown local system detected, using lenient matching", quote = F)}
        acceptable_distortion <- 0.05
    }
    if (verbose) {print(paste("Current acceptable distortion:", acceptable_distortion), quote = F)}

    return(acceptable_distortion)
}


#' Example multiple sequences data
#'
#' A collection of made-up sequences in the style of long reads over a repeat region
#' (e.g. *NOTCH2NLC*), with meta-data describing the participant each read is from and
#' the family each participant is from. Can be used in [visualise_many_sequences()],
#' [visualise_methylation()], and helper functions to visualise these sequences.\cr\cr
#' Generation code is available at `data-raw/example_many_sequences.R`
#'
#' @docType data
#'
#' @format ## `example_many_sequences`
#' A dataframe with 23 rows and 10 columns:
#' \describe{
#'  \item{family}{Participant family}
#'  \item{individual}{Participant ID}
#'  \item{read}{Unique read ID}
#'  \item{sequence}{DNA sequence of the read}
#'  \item{sequence_length}{Length (nucleotides) of the read}
#'  \item{quality}{FASTQ quality scores for the read. Each character represents a score from 0 to 40 - see [`fastq_quality_scores`].\cr\cr These values are made up via `pmin(pmax(round(rnorm(n, mean = 20, sd = 10)), 0), 40)` i.e. sampled from a normal distribution with mean 20 and standard deviation 10, then rounded to integers between 0 and 40 (inclusive) - see `example_many_sequences.R`}
#'  \item{methylation_locations}{Indices along the read (starting at 1) at which methylation probability was assessed i.e. CpG sites. Stored as a single character value per read, condensed from a numeric vector via [vector_to_string()].}
#'  \item{methylation_probabilities}{Probability of methylation (8-bit integer i.e. 0-255) for each assessed base. Stored as a single character value per read, condensed from a numeric vector via [vector_to_string()].\cr\cr These values are made up via `round(runif(n, min = 0, max = 255))` - see `example_many_sequences.R`}
#'  \item{hydroxymethylation_locations}{Indices along the read (starting at 1) at which hydroxymethylation probability was assessed i.e. CpG sites. Stored as a single character value per read, condensed from a numeric vector via [vector_to_string()].}
#'  \item{hydroxymethylation_probabilities}{Probability of hydroxymethylation (8-bit integer i.e. 0-255) for each assessed base. Stored as a single character value per read, condensed from a numeric vector via [vector_to_string()].\cr\cr These values are made up via `round(runif(n, min = 0, max = 255 - this_base_methylation_probability))` such that the summed methylation and hydroxymethylation probability never exceeds 255 (100%) - see `example_many_sequences.R`}
#
#' }
"example_many_sequences"



#' Colour palettes for sequence visualisations
#'
#' A collection of colour palettes for use with [visualise_single_sequence()]
#' and [visualise_many_sequences()].\cr\cr Each is a character vector of 4 colours,
#' corresponding to A, C, G, and T/U in that order.\cr\cr To use inside the visualisation
#' functions, set `sequence_colours = sequence_colour_palettes$<palette_name>`\cr\cr
#' Generation code is available at `data-raw/sequence_colour_palettes.R`
#'
#' @docType data
#'
#' @format ## `sequence_colour_palettes`
#' A list of 5 length-4 character vectors
#' \describe{
#'  \item{ggplot_style}{The shades of red, green, blue, and purple that [ggplot2::ggplot()] uses by default for a 4-way discrete colour scheme.\cr\cr Values: `c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF")`}
#'  \item{bright_pale}{Bright yellow, green, blue, and red in lighter pastel-like tones.\cr\cr Values: `c("#FFDD00", "#40C000", "#00A0FF", "#FF4E4E")`}
#'  \item{bright_pale2}{Bright yellow, green, blue, and red in lighter pastel-like tones. The green (for C) is slightly ligther than bright_pale.\cr\cr Values: `c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E")`}
#'  \item{bright_deep}{Bright orange, green, blue, and red in darker, richer tones.\cr\cr Values: `c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E")`}
#'  \item{sanger}{Green, blue, black, and red similar to a traditional Sanger sequencing readout.\cr\cr Values: `c("#00B200", "#0000FF", "#000000", "#FF0000")`}
#' }
"sequence_colour_palettes"


#' Vector of the quality scores used by the FASTQ format
#'
#' A vector of the characters used to indicate quality scores from 0 to 40
#' in the FASTQ format. These scores are related to the error probability \eqn{p}
#' via \eqn{Q = -10 \text{ log}_{10}(p)}, so a Q-score of 10 (represented by `"+"`) means
#' the error probability is 0.1, a Q-score of 20 (`"5"`) means the error probability
#' is 0.01, and a Q-score of 30 (`"?"`) means the error probability is 0.001.\cr\cr
#' The character representations store Q-scores in one byte each by using ASCII encodings,
#' where the Q-score for a character is its ASCII code minus 33 (e.g. `A` has an ASCII
#' code of 65 and represents a Q-score of 32).\cr\cr
#' This vector contains the characters in order but starting with a score of 0, meaning
#' the character at index \eqn{n} represents a Q-score of \eqn{n-1} e.g. the first
#' character (`"!"`) represents a score of 0; the eleventh character (`"+"`)
#' represents a score of 10.\cr\cr
#' The full set of possible score representations, in order and presented as a single
#' string, is `!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI`.\cr\cr
#' Generation code is available at `data-raw/fastq_quality_scores.R`
#'
#' @docType data
#'
#' @format ## `fastq_quality_scores`
#' A character vector of length 41
#' \describe{
#'  \item{fastq_quality_scores}{The vector `c("!", '"', "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I")`}
#' }
"fastq_quality_scores"
