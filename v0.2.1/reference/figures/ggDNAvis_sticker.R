library(hexSticker)
library(ggDNAvis)
library(showtext)
showtext_auto()

font_add_google("Roboto Slab")
font_add_google("Merriweather")
font_add_google("Scope One")



sequences <- extract_and_sort_sequences(
    example_many_sequences,
    grouping_levels = c(family = 6, individual = 2)
)
#fill_colour = "#F9690E"
#fill_colour = "#FF7A00"
fill_colour = "#FF8500"
#fill_colour = "#FF911C"
sequence_colours  <- sequence_colour_palettes$bright_deep
sequence_colours[1] <- "yellow"
visualise_many_sequences(
    sequences,
    sequence_colours = sequence_colours,
    sequence_text_size = 0,
    background_colour = fill_colour,
    pixels_per_base = 100,
    outline_linewidth = 0,
    margin = 0,
    filename = "many_sequences_for_sticker.svg",
    render_device = NULL,
    return = FALSE
)


s <- sticker("many_sequences_for_sticker.svg", filename = "ggDNAvis.png",
             package = "ggDNAvis", p_size = 80, p_y = 1.5, p_family = "Merriweather",
             s_width = 0.8, s_x = 1, s_y = 0.9,
             h_fill = fill_colour, h_color = sequence_colours[3],
             dpi = 1200)
plot(s)

