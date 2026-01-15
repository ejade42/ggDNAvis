sequence_colour_palettes <- list(
    ggplot_style = c("#F8766D", "#7CAE00", "#00BFC4", "#C77CFF"),
    bright_pale  = c("#FFDD00", "#40C000", "#00A0FF", "#FF4E4E"),
    bright_pale2 = c("#FFDD00", "#30EC00", "#00A0FF", "#FF4E4E"),
    bright_deep  = c("#FFAA00", "#00BC00", "#0000DC", "#FF1E1E"),
    sanger       = c("#00B200", "#0000FF", "#000000", "#FF0000"),
    accessible   = c("#B2DF8A", "#33A02C", "#1F78B4", "#A6CEE3")
)

usethis::use_data(sequence_colour_palettes, overwrite = TRUE)


## Define aliases
sequence_color_palettes <- sequence_colour_palettes
sequence_col_palettes <- sequence_colour_palettes
usethis::use_data(sequence_color_palettes, overwrite = TRUE)
usethis::use_data(sequence_col_palettes, overwrite = TRUE)
