# Resolve argument value when aliases are used (generic `ggDNAvis` helper)

See the
[aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md)
page for a general explanation of how aliases are used in `ggDNAvis`.

This function takes the name and value for the 'primary' form of an
argument (generally British spellings in `ggDNAvis`), the name of an
alternative 'alias' form, the dots (unrecognised argument) environment,
and the default value of the 'primary' argument.

If the alias has not been used (i.e. the alias is not present in the
dots env) or if the 'primary' value has been changed from the default,
then the 'primary' value will be returned. (Note that if the alias is
present in the dots env and the 'primary' value has been changed from
the default, then the updated 'primary' value 'wins' and is returned,
but with a warning that explains that both values were set and the
'alias' has been discarded).

If the alias has been used (i.e. the alias is present in the dots env)
and the 'primary' value is the default, then the 'alias' value will be
returned.

This function is most often used when called by
[`resolve_alias_map()`](https://ejade42.github.io/ggDNAvis/reference/resolve_alias_map.md).

## Usage

``` r
resolve_alias(primary_name, primary_val, primary_default, alias_name, dots_env)
```

## Arguments

- primary_name:

  `character`. The usual name of the argument.

- primary_val:

  `value`. The value of the argument under its usual name.

- primary_default:

  `value`. The default value of the argument under its usual name, used
  to determine if the primary argument has been explicitly set.

- alias_name:

  `character`. An alternative alias name for the argument.

- dots_env:

  `environment`. The environment created from the dots list. *WILL BE
  MODIFIED* by this function - alias is removed if it exists, to allow
  searching this environment for any unused arguments.

## Value

`value`. Either `primary_val` or `alias_val`, depending on the logic
above.

## Examples

``` r
low_colour <- "blue" ## e.g. default value from function call
dots_env <- list2env(list(low_color = "pink")) ## presumes low_color = "pink" was set in function call
low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_color", dots_env)
low_colour ## check to see what value was stored
#> [1] "pink"
```
