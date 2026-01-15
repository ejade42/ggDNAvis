#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @import ggplot2
#' @import dplyr
#' @importFrom utils packageDescription head tail
#' @importFrom stats setNames
#' @importFrom png readPNG
#' @importFrom grid grid.newpage grid.raster
#' @importFrom ggnewscale new_scale_fill
#' @importFrom stringr str_locate_all
#' @importFrom tidyr replace_na drop_na
#' @importFrom rlang abort warn
#' @importFrom cli cli_alert_info
#' @importFrom magick image_read image_compare
## usethis namespace: end
NULL

utils::globalVariables("example_many_sequences")
utils::globalVariables("sequence_colour_palettes")
utils::globalVariables("fastq_quality_scores")

## Helper function for dealing with different systems when comparing images
fetch_acceptable_distortion <- function(verbose = TRUE) {
    if (Sys.info()[["sysname"]] == "Linux") {
        if (verbose) {cli_alert_info("Linux detected. Setting font to 'Liberation Sans' for Arial/Helvetica metric compability.")}
        ggplot2::theme_update(text = element_text(family = "Liberation Sans"))
    }

    if (Sys.info()[["sysname"]] == "Darwin" && Sys.info()[["user"]] == "evelyn") {
        if (verbose) {cli_alert_info("Evelyn's macbook detected, using extremely strict matching")}
        acceptable_distortion <- 0.000001
    } else if (Sys.getenv("NOT_CRAN") == "false" || Sys.getenv("GITHUB_ACTIONS") == "true") {
        if (verbose) {cli_alert_info("GitHub actions/CRAN environment detected. Allowing lenience in plot matching.")}

        if (Sys.info()[["sysname"]] == "Linux") {
            acceptable_distortion <- 0.05
        }  else if (Sys.info()[["sysname"]] == "Windows") {
            if (verbose) {cli_alert_info("Windows detected. Not taking any special action.")}
            acceptable_distortion <- 0.05
        } else if (Sys.info()[["sysname"]] == "Darwin") {
            if (verbose) {cli_alert_info("MacOS (Darwin) detected. Giving a little less lenience in plot matching as Helvetica is available.")}
            acceptable_distortion <- 0.025
        } else {
            abort("Operating system not Linux/Windows/Darwin. Don't know what to do. Evelyn should take a look at this.", class = "unrecognised_OS")
        }

    } else {
        if (verbose) {cli_alert_info("Unknown local system detected, using lenient matching")}
        acceptable_distortion <- 0.05
    }
    if (verbose) {cli_alert_info(paste("Current acceptable distortion:", acceptable_distortion))}

    return(acceptable_distortion)
}

#' `ggDNAvis` aliases
#'
#' @name ggDNAvis_aliases
#' @aliases aliases
#'
#' @description
#' As of v1.0.0, `ggDNAvis` supports function and argument aliases.
#' The code is entirely written with British spellings (e.g. [visualise_methylation_colour_scale()]),
#' but should also accept American spellings (e.g. [visualize_methylation_color_scale()]).
#' If any American spellings don't work, I most likely overlooked them and can easily fix,
#' so please submit a bug report by creating a github issue
#'  (<`r packageDescription("ggDNAvis")$BugReports`>).
#'
#' All four major `visualise_` functions have aliases to also accept `visualize_`:
#'
#' - [visualise_many_sequences()] ([visualize_many_sequences()])
#' - [visualise_methylation()] ([visualize_methylation()])
#' - [visualise_methylation_colour_scale()] ([visualize_methylation_color_scale()])
#' - [visualise_single_sequence()] ([visualize_single_sequence()])
#'
#' As of v1.0.0, `extract_methylation_from_dataframe()` has been renamed `extract_and_sort_methylation()`
#' for consistency with `extract_and_sort_sequences()`. To preserve compatibility and ensure consistency,
#' both functions now accept either name formulation:
#'
#' - [extract_and_sort_sequences()] ([extract_sequences_from_dataframe()])
#' - [extract_and_sort_methylation()] ([extract_methylation_from_dataframe()])
#'
#' The builtin dataset [`sequence_colour_palettes`], like all `colour` arguments, also accepts
#' `color` or `col`:
#'
#' - [`sequence_colour_palettes`] ([`sequence_color_palettes`] & [`sequence_col_palettes`])
#'
#' The interactive shinyapp can be called via [ggDNAvis_shinyapp()] or [ggDNAvis_shiny()].
#'
#' Additionally, the three `rasterise_` helper functions also accept `rasterize_`:
#'
#' - [rasterise_matrix()] ([rasterize_matrix()])
#' - [rasterise_index_annotations()] ([rasterize_index_annotations()])
#' - [rasterise_probabilities()] ([rasterize_probabilities()])
#'
#' All arguments should have aliases configured. In particular, any `_colour` arguments
#' should also accept `_color` or `_col`.
#'
#' When more than one equivalent argument is provided, the 'canonical' (British) argument
#' takes precedence, and will produce a warning message explaining this. For colours, `_colour`
#' takes precedence over `_color`, which itself takes precedence over `_col`.
#'
#' I have also tried to provide aliases for common argument misspellings. In particular,
#' `index_annotation_full_line` also accepts any of `index_annotations_full_lines`,
#' `index_annotation_full_lines`, or `index_annotations_full_line`.
#' Likewise, `index_annotations_above` also accepts `index_annotation_above`.
#'
#' @examples
#' d <- extract_methylation_from_dataframe(example_many_sequences)
#' ## The resulting low colour will be green
#' visualise_methylation(
#'     d$locations,
#'     d$probabilities,
#'     d$sequences,
#'     index_annotation_lines = NA,
#'     outline_linewidth = 0,
#'     high_colour = "white",
#'     low_colour = "green",
#'     low_color = "orange",
#'     low_col = "purple"
#' )
#'
#' ## The resulting low colour will be orange
#' visualise_methylation(
#'     d$locations,
#'     d$probabilities,
#'     d$sequences,
#'     index_annotation_lines = NA,
#'     outline_linewidth = 0,
#'     high_colour = "white",
#'     low_color = "orange",
#'     low_col = "purple"
#' )
#'
#' ## The resulting low colour will be purple
#' visualise_methylation(
#'     d$locations,
#'     d$probabilities,
#'     d$sequences,
#'     index_annotation_lines = NA,
#'     outline_linewidth = 0,
#'     high_colour = "white",
#'     low_col = "purple"
#' )
#'
NULL

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
#'
#' @examples
#' example_many_sequences
"example_many_sequences"



#' Colour palettes for sequence visualisations
#'
#' @aliases sequence_color_palettes sequence_col_palettes
#'
#' @description
#' `sequence_color_palettes` and `sequence_col_palettes`
#' are aliases for `sequence_colour_palettes` - see [aliases].
#'
#' A collection of colour palettes for use with [visualise_single_sequence()]
#' and [visualise_many_sequences()]. Each is a character vector of 4 colours,
#' corresponding to A, C, G, and T/U in that order.
#'
#' To use inside the visualisation functions, set
#' `sequence_colours = sequence_colour_palettes$<palette_name>`
#'
#' Generation code is available at `data-raw/sequence_colour_palettes.R`
#'
#' @docType data
#'
#' @format ## `sequence_colour_palettes`
#' A list of 6 length-4 character vectors
#' \describe{
#'  \item{ggplot_style}{The shades of red, green, blue, and purple that [ggplot2::ggplot()] uses by default for a 4-way discrete colour scheme.\cr\cr Values: `c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF")`}
#'  \item{bright_pale}{Bright yellow, green, blue, and red in lighter pastel-like tones.\cr\cr Values: `c("#FFDD00", "#40C000", "#00A0FF", "#FF4E4E")`}
#'  \item{bright_pale2}{Bright yellow, green, blue, and red in lighter pastel-like tones. The green (for C) is slightly lighter than bright_pale.\cr\cr Values: `c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E")`}
#'  \item{bright_deep}{Bright orange, green, blue, and red in darker, richer tones.\cr\cr Values: `c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E")`}
#'  \item{sanger}{Green, blue, black, and red similar to a traditional Sanger sequencing readout.\cr\cr Values: `c("#00B200", "#0000FF", "#000000", "#FF0000")`}
#'  \item{accessible}{Light green, dark green, dark blue, and light blue as suggested by https://colorbrewer2.org/ for a 4-qualitative-category colourblind-safe palette.\cr\cr Values: `c("#B2DF8A", "#33A02C", "#1F78B4", "#A6CEE3")`}
#' }
#'
#' @examples
#' ## ggplot_style:
#' visualise_single_sequence(
#'     "ACGT",
#'     sequence_colours = sequence_colour_palettes$ggplot_style,
#'     index_annotation_interval = 0
#' )
#'
#' ## bright_pale:
#' visualise_single_sequence(
#'     "ACGT",
#'     sequence_colours = sequence_colour_palettes$bright_pale,
#'     index_annotation_interval = 0
#' )
#'
#' ## bright_pale2:
#' visualise_single_sequence(
#'     "ACGT",
#'     sequence_colours = sequence_colour_palettes$bright_pale2,
#'     index_annotation_interval = 0
#' )
#'
#' ## bright_deep:
#' visualise_single_sequence(
#'     "ACGT",
#'     sequence_colours = sequence_colour_palettes$bright_deep,
#'     sequence_text_colour = "white",
#'     index_annotation_interval = 0
#' )
#'
#' ## sanger:
#' visualise_single_sequence(
#'     "ACGT",
#'     sequence_colours = sequence_colour_palettes$sanger,
#'     sequence_text_colour = "white",
#'     index_annotation_interval = 0
#' )
#'
#' ## accessible:
#' visualise_single_sequence(
#'     "ACGT",
#'     sequence_colours = sequence_colour_palettes$accessible,
#'     sequence_text_colour = "black",
#'     index_annotation_interval = 0
#' )
#'
#'
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
#'
#' @examples
#' fastq_quality_scores
"fastq_quality_scores"




#' Run the interactive `ggDNAvis` shinyapp
#'
#' @aliases ggDNAvis_shiny
#'
#' @description
#' `ggDNAvis_shiny()` is an alias for `ggDNAvis_shinyapp()` - see [aliases].
#'
#' The `ggDNAvis` shinyapp is an interactive frontend for the `ggDNAvis` functions.
#' Arguments can be configured via text/numerical/colour/checkbox entry rather than
#' on the command line. In the future it will be hosted online, but is
#' currently accessible only by running the shinyapp locally.
#'
#' This function checks 'suggests' packages are present
#' (not needed for main package, but needed for the shinyapp)
#' and then runs the shinyapp in the `inst/shinyapp` directory.
#'
#' @param themer `logical`. Whether the theme picker should be shown. Makes the app harder to use, not recommended except for dev purposes.
#' @param return `logical`. Whether to return the shiny app object instead of running it. Intended for hosting the shinyapp.
#' @return Nothing, or the shiny app object
#' @export
#' @examples
#' \dontrun{
#' ## Run normally
#' ggDNAvis_shinyapp()
#' ggDNAvis_shinyapp(themer = FALSE, return = FALSE)
#'
#' ## Run with theme picker (dev)
#' ggDNAvis_shinyapp(themer = TRUE)
#'
#' ## Run, returning object (dev)
#' ggDNAvis_shinyapp(return = TRUE)
#' }
ggDNAvis_shinyapp <- function(themer = FALSE, return = FALSE) {
    bools <- list(themer = themer, return = return)
    for (arg in names(bools)) {
        if (length(bools[[arg]]) != 1 || is.na(bools[[arg]]) || !is.logical(bools[[arg]])) {
            bad_arg(arg, bools, "must be a single logical/boolean value")
        }
    }


    ## Check additional packages required for shinyapp but not main package are installed
    rlang::check_installed(c("bslib","colourpicker", "jsonlite", "markdown", "shiny"), reason = "for ggDNAvis interactive shinyapp.")

    ## Identify app directory
    app_dir <- system.file("shinyapp", package = "ggDNAvis")
    if (app_dir == "") {
        abort(paste("ggDNAvis shinyapp installation not found. Please file a bug report at", packageDescription("ggDNAvis")$BugReports), class = "shinyapp_dir_missing")
    }

    ## Run with themer if specified
    if (return) {
        return(shiny::shinyAppDir(app_dir))
    }

    if (themer) {
        bslib::run_with_themer(app_dir)
    } else {
        shiny::runApp(app_dir)
    }
}

#' @rdname ggDNAvis_shinyapp
#' @usage NULL
#' @export
ggDNAvis_shiny <- ggDNAvis_shinyapp
