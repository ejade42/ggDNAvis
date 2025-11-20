# Create dataframe of locations and rendered probabilities ([`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md) helper)

This function takes the locations/probabilities/sequences input to
[`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md),
as well as the scaling and rounding to apply to the probability text,
and produces a dataframe of the x and y coordinates to draw each
probability at (i.e. inside the coloured box for each assessed base) and
the probability text to draw inside each box.

## Usage

``` r
convert_probabilities_to_annotations(
  modification_locations,
  modification_probabilities,
  sequences,
  sequence_text_scaling = c(-0.5, 256),
  sequence_text_rounding = 2
)
```

## Arguments

- modification_locations:

  `character vector`. One character value for each sequence, storing a
  condensed string (e.g. `"3,6,9,12"`, produced via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
  of the indices along the read at which modification was assessed.
  Indexing starts at 1.

- modification_probabilities:

  `character vector`. One character value for each sequence, storing a
  condensed string (e.g. `"0,128,255,15"`, produced via
  [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md))
  of the probability of methylation/modification at each assessed
  base.  
    
  Assumed to be Nanopore \> SAM style modification stored as an 8-bit
  integer from 0 to 255, but changing other arguments could make this
  work on other scales.

- sequences:

  `character vector`. One character value for each sequence, storing the
  actual DNA sequence.

- sequence_text_scaling:

  `numeric vector, length 2`. The min and max possible probability
  values, used to facilitate scaling of the text in each to 0-1. Scaling
  is implemented as \\\frac{p - min}{max}\\, so custom scalings (e.g.
  scaled to 0-9 space) can be implemented by setting this values as
  required.  
    
  Set to `c(0, 1)` to not scale at all i.e. print the raw integer
  probability values. It is recommended to also set
  `sequence_text_rounding = 0` to print integers as the default value of
  `2` will result in e.g. `"128.00"`.  
    
  Set to `c(-0.5, 256)` (default, results in \\\frac{p+0.5}{256}\\) to
  scale to the centre of the probability spaces defined by the SAMtools
  spec, where integer \\p\\ represents the probability space from
  \\\frac{p}{256}\\ to \\\frac{p+1}{256}\\. This is slightly better at
  representing the uncertainty compared to `c(0, 255)` as strictly
  speaking `0` represents the probability space from 0.000 to 0.004 and
  `255` represents the probability space from 0.996 to 1.000, so scaling
  them to 0.002 and 0.998 respectively is a more accurate representation
  of the probability space they each represent. Setting `c(0, 255)`
  would scale such that 0 is exactly 0.000 and 255 is exactly 1.000,
  which is not as accurate so it discouraged.

- sequence_text_rounding:

  `integer`. How many decimal places the text drawn in the boxes should
  be rounded to (defaults to `2`). Ignored if `sequence_text_type` is
  `"sequence"` or `"none"`.

## Value

`dataframe`. Dataframe of `x_position`, `y_position`, `annotation` (i.e.
probability to draw), and `type` (always `"Probability"`).

## Examples

``` r
d <- extract_methylation_from_dataframe(example_many_sequences)
#> Error in extract_methylation_from_dataframe(example_many_sequences): '...' used in an incorrect context

## Unscaled i.e. integers
convert_probabilities_to_annotations(
    d$locations,
    d$probabilities,
    d$sequences,
    sequence_text_scaling = c(0, 1),
    sequence_text_rounding = 0
)
#> Error: object 'd' not found

## Scaled to 0-1, 3 dp
convert_probabilities_to_annotations(
    d$locations,
    d$probabilities,
    d$sequences,
    sequence_text_scaling = c(-0.5, 256),
    sequence_text_rounding = 3
)
#> Error: object 'd' not found

## Default (i.e. scaled to 0-1, 2 dp)
convert_probabilities_to_annotations(
    d$locations,
    d$probabilities,
    d$sequences
)
#> Error: object 'd' not found
```
