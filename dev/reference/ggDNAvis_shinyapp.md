# Run the interactive `ggDNAvis` shinyapp

`ggDNAvis_shiny()` is an alias for `ggDNAvis_shinyapp()` - see
[aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md).

The `ggDNAvis` shinyapp is an interactive frontend for the `ggDNAvis`
functions. Arguments can be configured via
text/numerical/colour/checkbox entry rather than on the command line. In
the future it will be hosted online, but is currently accessible only by
running the shinyapp locally.

This function checks 'suggests' packages are present (not needed for
main package, but needed for the shinyapp) and then runs the shinyapp in
the `inst/shinyapp` directory.

## Usage

``` r
ggDNAvis_shinyapp()
```

## Value

Nothing.

## Examples

``` r
if (FALSE) { # \dontrun{
ggDNAvis_shinyapp()
} # }
```
