# Resolve argument value when aliases are used

See the
[aliases](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md)
page for a general explanation of how aliases are used in `ggDNAvis`.

This function takes the name and value for the 'primary' form of an
argument (generally British spellings in `ggDNAvis`), the name and value
of an alternative 'alias' form, and the default value of the 'primary'
argument.

If the alias has not been used (i.e. the 'alias' value is `NULL`) or if
the 'primary' value has been changed from the default, then the
'primary' value will be returned. (Note that if the 'alias' value is not
`NULL` and the 'primary' value has been changed from the default, then
the updated 'primary' value 'wins' and is returned, but with a warning
that explains that both values were set and the 'alias' has been
discarded).

If the alias has been used (i.e. the 'alias' value is not `NULL`) and
the 'primary' value is the default, then the 'alias' value will be
returned.

## Usage

``` r
resolve_alias(
  primary_name,
  primary_val,
  alias_name,
  alias_val,
  primary_default
)
```

## Arguments

- primary_name:

  `character`. The usual name of the argument.

- primary_val:

  `value`. The value of the argument under its usual name.

- alias_name:

  `character`. An alternative alias name for the argument.

- alias_val:

  `value`. The value of the argument under its alias. Expected to be
  `NULL` if the alias argument is not being used.

- primary_default:

  `value`. The default value of the argument under its usual name, used
  to determine if the primary argument has been explicitly set.

## Value

`value`. Either `primary_val` or `alias_val`, depending on the logic
above.
