# Process an alias map list (generic `ggDNAvis` helper)

See the
[aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md)
page for a general explanation of how aliases are used in `ggDNAvis`.

This function takes an alias map and the environment constructed from
non-formal arguments (...) to the calling function, and optionally an
environment to function inside, and works through the aliases provided
in the map via
[`resolve_alias()`](https://ejade42.github.io/ggDNAvis/reference/resolve_alias.md).

If any arguments were given that aren't in the alias map an error is
raised.

## Usage

``` r
resolve_alias_map(alias_map, dots_env, target_env = parent.frame())
```

## Arguments

- alias_map:

  `list`. A list where each entry takes the name of a formal argument in
  the calling function, and each value is a list containing `"default"`
  (the default value of the formal argument) and `"aliases"` (a
  character vector of all allowed aliases for the formal argument).
  Aliases are processed in the order given in the character vector, with
  earlier aliases taking precedence.

- dots_env:

  `environment`. The environment created from the dots list. *WILL BE
  MODIFIED* by this function - alias is removed if it exists, to allow
  searching this environment for any unused arguments.

- target_env:

  `environment`. The environment in which variables should be modified.
  Generally [`parent.frame()`](https://rdrr.io/r/base/sys.parent.html)
  i.e. the calling function.

## Value

Nothing (variables are modified within the `target_env`).

## Examples

``` r
## Alias map (from within function code)
alias_map <- list(
   low_colour = list(default = "blue", aliases = c("low_color", "low_col")),
   high_colour = list(default = "red", aliases = c("high_color", "high_col"))
)

## Default values (would come from formal arguments)
low_colour = "blue" ## default
high_colour = "green" ## changed from default

## Extra arguments provided by name
dots_env <- list2env(list("low_col" = "black", "low_color" = "white", "high_color" = "orange"))

## Process
resolve_alias_map(alias_map, dots_env)
#> Warning: Both 'low_colour' and alias 'low_col' were provided.
#> 'low_col' will be discarded.
#>     Value: black
#> 'low_colour' will be used.
#>     Value: white
#> Warning: Both 'high_colour' and alias 'high_color' were provided.
#> 'high_color' will be discarded.
#>     Value: orange
#> 'high_colour' will be used.
#>     Value: green

## See values
print(low_colour)
#> [1] "white"
print(high_colour)
#> [1] "green"
```
