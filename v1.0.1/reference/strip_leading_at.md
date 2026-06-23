# Strip leading `@` from character vector

This function removes a single leading `@` character from each element
of a character vector when present. This is intended to deal with
SAMtools \> FASTQ translation often prefixing read IDs with an "`@`",
which can result in read ID mismatches and metadata merging fails.

## Usage

``` r
strip_leading_at(string)
```

## Arguments

- string:

  `character vector`. A vector (e.g. read IDs) to strip of a single
  leading "`@`" each wherever one is present.

## Value

`character vector`. The same string but with one "`@`" removed from each
element that started with one.

## Examples

``` r
strip_leading_at(c("read_1", "@read_2", "@@read_3", "", NA, NULL))
#> [1] "read_1"  "read_2"  "@read_3" ""        NA       
```
