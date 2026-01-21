# Format a difference between times (generic `ggDNAvis` helper)

This function takes two times (class `"POSIXct"`) and formats the
difference between them nicely, with a certain number of numerical
characters printed.

Note that the if the time difference rounded to the integer number of
seconds (e.g. 1234 seconds) requires more space than the number of
characters allocated (e.g. 3 characters) then it will go beyond the
specified characters. However, this would be an exceptionally
slow-running function. In normal monitoring use for
[`monitor()`](https://ejade42.github.io/ggDNAvis/reference/monitor.md),
\<1 second steps should be nearly universal, and \<0.01 second steps are
very common.

## Usage

``` r
format_time_diff(new_time, old_time, characters_to_print = 4)
```

## Arguments

- new_time:

  `POSIXct`. The more recent (newer) of the two times to calculate a
  difference between.

- old_time:

  `POSIXct`. The less recent (older) of the two times to calculate a
  difference between.

- characters_to_print:

  `integer`. How many numeric digits should be printed.

## Value

`character`. The formatted time difference in seconds.

## Examples

``` r
## POSIXct time is a very large number of seconds
newer <- 1000000001
older <- 1000000000
format_time_diff(newer, older, 4)
#> [1] "1.000"

newer <- 1000000456.45645
older <- 1000000000
format_time_diff(newer, older, 4)
#> [1] "456.5"
format_time_diff(newer, older, 3)
#> [1] "456"
format_time_diff(newer, older, 2)
#> [1] "%.0-1f"

newer <- 1000000000.011
older <- 1000000000
format_time_diff(newer, older, 4)
#> [1] "0.011"
format_time_diff(newer, older, 3)
#> [1] "0.01"
format_time_diff(newer, older, 2)
#> [1] "0.0"
```
