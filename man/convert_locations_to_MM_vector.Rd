% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_methylation_from_fastq.R
\name{convert_locations_to_MM_vector}
\alias{convert_locations_to_MM_vector}
\title{Convert absolute index locations to MM tag (\code{\link[=write_modified_fastq]{write_modified_fastq()}} helper)}
\usage{
convert_locations_to_MM_vector(sequence, locations, target_base = "C")
}
\arguments{
\item{sequence}{\code{character}. The DNA sequence about which the methylation information is being processed.}

\item{locations}{\verb{integer vector}. All of the base indices at which methylation/modification information was processed. Must all be instances of the target base.}

\item{target_base}{\code{character}. The base type that has been assessed or skipped (defaults to \code{"C"}).}
}
\value{
\verb{integer vector}. A component of a SAM MM tag, representing the number of skipped target bases in between each assessed base.
}
\description{
This function takes a vector of modified base locations as absolute indices
(i.e. a \code{1} would mean the first base in the sequence has been assessed for
modification; a \code{15} would mean the 15th base has), and converts it to a vector
in the format of the SAM/BAM MM tags. The MM tag defines a particular target base (e.g.
\code{C} for methylation), and then stores the number of skipped instances of that base
between sites where modification was assessed. In practice, this often means counting the
number of non-CpG \code{C}s in between CpG \code{C}s. In a \code{GGC} repeat, this should be a bunch of \code{0}s
as every \code{C} is in a CpG, but unique sequence will have many non-CpG \code{C}s.\cr\cr
This function is reversed by \code{\link[=convert_MM_vector_to_locations]{convert_MM_vector_to_locations()}}.
}
