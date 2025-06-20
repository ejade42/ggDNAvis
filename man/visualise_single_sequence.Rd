% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/visualise_single_sequence.R
\name{visualise_single_sequence}
\alias{visualise_single_sequence}
\title{Visualise a single DNA/RNA sequence}
\usage{
visualise_single_sequence(
  sequence,
  sequence_colours = c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF"),
  background_colour = "white",
  sequence_text_colour = "black",
  sequence_text_size = 16,
  index_annotation_colour = "darkred",
  index_annotation_size = 12.5,
  index_annotation_interval = 15,
  line_wrapping = 75,
  spacing = 1,
  annotations_on_top = FALSE,
  return = TRUE,
  filename = NA,
  pixels_per_base = 100
)
}
\arguments{
\item{sequence}{\code{character}. A DNA or RNA sequence to visualise e.g. \code{"AAATGCTGC"}.}

\item{sequence_colours}{\verb{character vector}, length 4. A vector indicating which colours should be used for each base. In order: \code{c(A_colour, C_colour, G_colour, TU_colour)}. Defaults to red, green, blue, purple (in the default shades produced by ggplot with 4 colours).}

\item{background_colour}{\code{character}. The colour of the background. Defaults to white.}

\item{sequence_text_colour}{\code{character}. The colour of the text within the bases (e.g. colour of "A" letter within boxes representing adenosine bases). Defaults to black.}

\item{sequence_text_size}{\code{numeric}. The size of the text within the bases (e.g. size of "A" letter within boxes representing adenosine bases). Defaults to \code{16}. Set to \code{0} to hide sequence text (show box colours only).}

\item{index_annotation_colour}{\code{character}. The colour of the little numbers underneath indicating base index (e.g. colour "15" label under the 15th base). Defaults to dark red.}

\item{index_annotation_size}{\code{numeric}. The size of the little number underneath indicating base index (e.g. size of "15" label under the 15th base). Defaults to \code{12.5}. Can be set to \code{0} to turn off annotations, but it is better to do this via \code{index_annotation_interval = 0}.}

\item{index_annotation_interval}{\code{integer}. The frequency at which numbers should be placed underneath indicating base index, starting counting from the leftmost base in each row. Defaults to \code{15} (every 15 bases along each row). Recommended to make this a factor/divisor of the line wrapping length (meaning the final base in each line is annotated), otherwise the numbering interval resetting at the beginning of each row will result in uneven intervals at each line break. Set to \code{0} to turn off annotations (preferable over using \code{index_annotation_size = 0}).}

\item{line_wrapping}{\code{integer}. The number of bases that should be on each line before wrapping. Defaults to \code{75}. Recommended to make this a multiple of the repeat unit size (e.g. 3\emph{n} for a trinucleotide repeat) if visualising a repeat sequence.}

\item{spacing}{\code{integer}. The number of blank lines between each line of sequence. Defaults to \code{1}. Be careful when setting to \code{0} as this means annotations have no space so might render strangely. Recommended to set \code{index_annotation_interval = 0} if doing so.}

\item{annotations_on_top}{\code{logical}. Whether index annotations should go above (\code{TRUE}) or below (\code{FALSE}, default) each line of sequence.}

\item{return}{\code{logical}. Boolean specifying whether this function should return the ggplot object, otherwise it will return \code{NULL}. Defaults to \code{TRUE}.}

\item{filename}{\code{character}. Filename to which output should be saved. If set to \code{NA} (default), no file will be saved. Recommended to end with \code{".png"} but might work with other extensions if they are compatible with \code{ggsave()}.}

\item{pixels_per_base}{\code{integer}. How large each box should be in pixels, if file output is turned on via setting \code{filename}. Corresponds to dpi of the exported image. Large values recommended because text needs to be legible when rendered significantly smaller than a box. Defaults to \code{100}.}
}
\value{
A ggplot object containing the full visualisation, or \code{NULL} if \code{return = FALSE}. It is often more useful to use \code{save = TRUE} and \code{filename = "myfilename.png"}, because then the visualisation is exported at the correct aspect ratio.
}
\description{
This function takes a DNA/RNA sequence and returns a ggplot
visualising it, with the option to directly export a png image
with appropriate dimensions. Colours, line wrapping, index annotation
interval, and pixels per square when exported are configurable.
}
