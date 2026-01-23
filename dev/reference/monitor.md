# Continue performance monitoring (generic `ggDNAvis` helper)

This function is meant to be called frequently throughout a main
function, and if verbose performance monitoring is enabled then it will
print the elapsed time since (a) initialisation via
[`monitor_start()`](https://ejade42.github.io/ggDNAvis/reference/monitor_start.md)
and (b) since the last step was recorded via this function.

## Usage

``` r
monitor(monitor_performance, start_time, previous_time, message)
```

## Arguments

- monitor_performance:

  `logical`. Whether verbose performance monitoring should be enabled.

- start_time:

  `POSIXct`. The time at which the overarching function was initialised
  (generally via
  [`monitor_start()`](https://ejade42.github.io/ggDNAvis/reference/monitor_start.md)).

- previous_time:

  `POSIXct`. The time at which the previous step was recorded (via a
  prior call to `monitor()`).

- message:

  `character`. The message to be printed, generally indicating what this
  step is doing

## Value

`POSIXct` the time at which the function was called, via
[`Sys.time()`](https://rdrr.io/r/base/Sys.time.html).

## Examples

``` r
## Initialise monitoring
start_time <- monitor_start(TRUE, "my_cool_function")
#> ℹ Verbose monitoring enabled
#> ℹ (2026-01-23 00:11:07) my_cool_function start

## Step 1
monitor_time <- monitor(TRUE, start_time, start_time, "performing step 1")
#> ℹ (0.004 secs elapsed; 0.004 secs total) performing step 1
x <- 2 + 2

## Step 2
monitor_time <- monitor(TRUE, start_time, monitor_time, "performing step 2")
#> ℹ (0.002 secs elapsed; 0.006 secs total) performing step 2
y <- 10.5^6 %% 345789

## Step 3
monitor_time <- monitor(TRUE, start_time, monitor_time, "performing step 3")
#> ℹ (0.002 secs elapsed; 0.009 secs total) performing step 3
z <- y / x^2

## Conclude monitoring
monitor_time <- monitor(TRUE, start_time, monitor_time, "done")
#> ℹ (0.002 secs elapsed; 0.011 secs total) done
```
