# Sanitise a sequence vector (generic `ggDNAvis` helper)

`sanitize_sequences_vector()` is an alias for
`sanitise_sequences_vector()` - see
[aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md).

Takes a character vector of sequences, and removes any non-`ACGTU`
characters (case insensitive).

## Usage

``` r
sanitise_sequences_vector(sequences, warn_on_removal = TRUE)
```

## Arguments

- sequences:

  `character vector`. A character vector, e.g.
  `c("ACGTA 5%h", "uXuG", "UcA67UcT")`, from which any non-`ACGTU`
  characters will be removed.

- warn_on_removal:

  `logical`. Whether a warning should be shown when characters are
  removed. Default: `TRUE`.

## Examples

``` r
sanitise_sequences_vector(c("ACGTA 5%h", "uXuG", "UcA67UcT"))
#> Warning: Invalid sequence characters removed: ' 5%hX67'
#> [1] "ACGTA"  "uuG"    "UcAUcT"
sanitise_sequences_vector(c("ACGTA 5%h", "uXuG", "UcA67UcT"), warn_on_removal = FALSE)
#> [1] "ACGTA"  "uuG"    "UcAUcT"
```
