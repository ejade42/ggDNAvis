.onLoad <- function(libname, pkgname) {
    pkg_namespace <- parent.env(environment())

    ## Assign 'sequence_color_palettes' and 'sequence_col_palettes' when loaded
    delayedAssign(
        "sequence_color_palettes",
        sequence_colour_palettes,
        assign.env = as.environment(pkg_namespace),
        eval.env = as.environment(pkg_namespace)
    )
    delayedAssign(
        "sequence_col_palettes",
        sequence_colour_palettes,
        assign.env = as.environment(pkg_namespace),
        eval.env = as.environment(pkg_namespace)
    )
}
