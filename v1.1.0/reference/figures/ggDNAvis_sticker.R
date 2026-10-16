library(ggDNAvis)
library(ggplot2)

sequences <- c(
    "ACGTGAG",
    "GGC",
    "",
    "ATACA"
)
#fill_colour = "#F9690E"
#fill_colour = "#FF7A00"
fill_colour = "#FF8500"
#fill_colour = "#FF911C"
sequence_colours  <- sequence_colour_palettes$bright_deep
sequence_colours[1] <- "#EE0"
visualise_many_sequences(
    sequences,
    sequence_colours = sequence_colours,
    sequence_text_colour = "white",
    background_colour = fill_colour,
    index_annotation_lines = NA,
    pixels_per_base = 300,
    outline_linewidth = 1,
    margin = 0.1,
    filename = "many_sequences_for_sticker_detailed.png",
    return = FALSE
)

visualise_many_sequences(
    sequences,
    sequence_colours = sequence_colours,
    sequence_text_colour = "white",
    background_colour = fill_colour,
    index_annotation_lines = NA,
    pixels_per_base = 300,
    outline_linewidth = 0,
    margin = 0.1,
    filename = "many_sequences_for_sticker_medium.png",
    return = FALSE
)

visualise_many_sequences(
    sequences,
    sequence_colours = sequence_colours,
    sequence_text_size = 0,
    sequence_text_colour = "white",
    background_colour = fill_colour,
    index_annotation_lines = NA,
    pixels_per_base = 300,
    outline_linewidth = 0,
    margin = 0.1,
    filename = "many_sequences_for_sticker_simple.png",
    return = FALSE
)




library(sysfonts)
library(showtext)
font_add_google("Merriweather")
hex_margin <- 1
plot_names <- c("detailed", "medium", "simple")
s <- sapply(plot_names, function(x) {
    s <- hexSticker::sticker(
        paste0("many_sequences_for_sticker_", x, ".png"),
        filename = "ggDNAvis.png",
        package = "ggDNAvis",
        p_size = 75, p_y = 1.5, p_family = "Merriweather",
        s_width = 0.7, s_x = 1, s_y = 0.875,
        h_fill = fill_colour, h_color = sequence_colours[3],
        dpi = 10) +
    theme(plot.margin = margin(hex_margin, hex_margin, hex_margin, hex_margin))
    ggsave(plot = s, paste0("ggDNAvis_", x, ".png"), dpi = 1200, width = 2, height = 2)
})

file.copy("ggDNAvis_detailed.png", "logo.png", overwrite = TRUE)
