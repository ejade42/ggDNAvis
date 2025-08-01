% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ggDNAvis-package.R
\docType{data}
\name{sequence_colour_palettes}
\alias{sequence_colour_palettes}
\title{Colour palettes for sequence visualisations}
\format{
\subsection{\code{sequence_colour_palettes}}{

A list of 3 length-4 character vectors
\describe{
\item{ggplot_style}{The shades of red, green, blue, and purple that \code{\link[ggplot2:ggplot]{ggplot2::ggplot()}} uses by default for a 4-way discrete colour scheme.\cr\cr Values: \code{c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF")}}
\item{bright_pale}{Bright yellow, green, blue, and red in lighter pastel-like tones.\cr\cr Values: \code{c("#FFDD00", "#40C000", "#00A0FF", "#FF4E4E")}}
\item{bright_deep}{Bright orange, green, blue, and red in darker, richer tones.\cr\cr Values: \code{c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E")}}
}
}
}
\usage{
sequence_colour_palettes
}
\description{
A collection of colour palettes for use with \code{\link[=visualise_single_sequence]{visualise_single_sequence()}}
and \code{\link[=visualise_many_sequences]{visualise_many_sequences()}}.\cr\cr Each is a character vector of 4 colours,
corresponding to A, C, G, and T/U in that order.\cr\cr To use inside the visualisation
functions, set \verb{sequence_colours = sequence_colour_palettes$<palette_name>}\cr\cr
Generation code is available at \code{data-raw/sequence_colour_palettes.R}
}
\keyword{datasets}
