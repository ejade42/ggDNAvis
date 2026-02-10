# Start performance monitoring (generic `ggDNAvis` helper)

This function takes a bool of whether verbose performance monitoring is
on, as well as the name of the calling function, prints a monitoring
initialisation message (if desired), and returns the start time.

Later monitoring steps are performed by
[`monitor()`](https://ejade42.github.io/ggDNAvis/reference/monitor.md)

## Usage

``` r
monitor_start(monitor_performance, function_name)
```

## Arguments

- monitor_performance:

  `logical`. Whether verbose performance monitoring should be enabled.

- function_name:

  `character`. The name of the calling function, printed as part of the
  monitoring initialisation message.

## Value

`POSIXct` the time at which the function was initialised, via
[`Sys.time()`](https://rdrr.io/r/base/Sys.time.html).

## Examples

``` r
## Initialise monitoring
start_time <- monitor_start(TRUE, "my_cool_function")
#> ℹ Verbose monitoring enabled
#> ℹ (2026-02-10 00:45:57) my_cool_function start

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
#> ℹ (0.002 secs elapsed; 0.008 secs total) performing step 3
z <- y / x^2

## Conclude monitoring
monitor_time <- monitor(TRUE, start_time, monitor_time, "done")
#> ℹ (0.002 secs elapsed; 0.011 secs total) done
```
