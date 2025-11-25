# Emit an error message for an invalid function argument (generic `ggDNAvis` helper)

This function takes an argument name, a named list of arguments
(presumably being iterated over for a particular validation check), and
a message. Using
[`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html), it
prints an error message of the form:

    Argument '<argument_name>' <message>
    Current value: <argument_value>
    Current class: <class(argument_value)>

If the argument value is a named item (i.e.
`names(arguments_list[[argument_name]])` is not null), or if
`force_names` is `TRUE`, then the form will be:

    Argument '<argument_name>' <message>
    Current value: <argument_value>
    Current names: <argument_names>
    Current class: <class(argument_value)>

## Usage

``` r
bad_arg(
  argument_name,
  arguments_list,
  message,
  class = "argument_value_or_type",
  force_names = FALSE
)
```

## Arguments

- argument_name:

  `character`. The name of the argument that caused the error

- arguments_list:

  `list`. A named list where `arguments_list[[argument_name]]` is the
  value of the offending argument.

- message:

  `character`. The message that should be printed to describe why the
  argument is invalid.

- class:

  `character`. The class that the error should have. Defaults to
  `"argument_value_or_type"` for my own use.

- force_names:

  `logical`. Whether the names argument should be printed even if names
  is `NULL`. Defaults to `FALSE`.

## Value

Nothing, but causes an error exit via
[`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html)

## Examples

``` r
## Obviously this error-message function causes an error,
## so needs to be wrapped in try() for these examples

## Standard use
positive_args <- list(number = -1)
try(bad_arg("number", positive_args, "must be positive"))
#> Error in eval(expr, envir) : Argument 'number' must be positive
#> Current class: numeric
#> Current value: -1

## Automatically detects named item and prints names
named <- list(x = c("first item" = 1, "second item" = 7))
try(bad_arg("x", named, "is not acceptable"))
#> Error in eval(expr, envir) : Argument 'x' is not acceptable
#> Current class: numeric
#> Current value: 1, 7
#> Current names: first item, second item

## Can force name printing
try(bad_arg("number", positive_args, "must be positive", force_names = TRUE))
#> Error in eval(expr, envir) : Argument 'number' must be positive
#> Current class: numeric
#> Current value: -1
#> Current names: 
```
