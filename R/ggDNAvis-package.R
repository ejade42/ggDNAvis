#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import ggplot2
#' @import dplyr
#' @import ggnewscale
#' @importFrom stringr str_locate_all
#' @importFrom tidyr replace_na
#' @importFrom rlang abort warn
#' @importFrom magick image_read image_compare
## usethis namespace: end
NULL


#' Example multiple sequences data
#'
#' A collection of made-up sequences in the style of long reads over a repeat region
#' (e.g. *NOTCH2NLC*), with meta-data describing the participant each read is from and
#' the family each participant is from. Can be used in [visualise_many_sequences()],
#' [visualise_methylation()], and helper functions to visualise these sequences.\cr\cr
#' Generation code is available at `data-raw/example_many_sequences.R`
#'
#' @format ## `example_many_sequences`
#' A dataframe with 23 rows and 9 columns:
#' \describe{
#'  \item{family}{Participant family}
#'  \item{individual}{Participant ID}
#'  \item{read}{Unique read ID}
#'  \item{sequence}{DNA sequence of the read}
#'  \item{sequence_length}{Length (nucleotides) of the read}
#'  \item{methylation_locations}{Indices along the read (starting at 1) at which methylation probability was assessed i.e. CpG sites. Stored as a single character value per read, condensed from a numeric vector via [vector_to_string()].}
#'  \item{methylation_probabilities}{Probability of methylation (8-bit integer i.e. 0-255) for each assessed base. Stored as a single character value per read, condensed from a numeric vector via [vector_to_string()]. These values are made up via `round(runif(n, min = 0, max = 255))` - see `example_many_sequences.R`}
#'  \item{hydroxymethylation_locations}{Indices along the read (starting at 1) at which hydroxymethylation probability was assessed i.e. CpG sites. Stored as a single character value per read, condensed from a numeric vector via [vector_to_string()].}
#'  \item{hydroxymethylation_probabilities}{Probability of hydroxymethylation (8-bit integer i.e. 0-255) for each assessed base. Stored as a single character value per read, condensed from a numeric vector via [vector_to_string()]. These values are made up via `round(runif(n, min = 0, max = 255))` - see `example_many_sequences.R`}
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
#' @format ## `sequence_colour_palettes`
#' A list of 3 length-4 character vectors
#' \describe{
#'  \item{ggplot_style}{The shades of red, green, blue, and purple that `ggplot` uses by default for a 4-way discrete colour scheme}
#'  \item{bright_pale}{Bright yellow, green, blue, and red in lighter pastel-like tones}
#'  \item{bright_deep}{Bright orange, green, blue, and red in darker, richer tones}
#' }
"sequence_colour_palettes"

