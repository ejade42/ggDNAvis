# Interactive App

Toggle navigation

![](https://raw.githubusercontent.com/ejade42/ggDNAvis/main/pkgdown/favicon/favicon-96x96.png)
ggDNAvis interactive suite

- [Instructions](_w_fb24da88bc13452cb8e866a688170f09/#tab-1495-1)
- [Single sequence](_w_fb24da88bc13452cb8e866a688170f09/#tab-1495-2)
- [Multiple sequences](_w_fb24da88bc13452cb8e866a688170f09/#tab-1495-3)
- [Methylation/modification](_w_fb24da88bc13452cb8e866a688170f09/#tab-1495-4)
- [ Citation](https://ejade42.github.io/ggDNAvis/authors.html#citation)
- [ Source](https://github.com/ejade42/ggDNAvis)
- [ Documentation](https://ejade42.github.io/ggDNAvis/)
- [ Bugs](https://github.com/ejade42/ggDNAvis/issues)
- 

# ggDNAvis interactive suite instructions

##### ‘ggplot2’-based tools for visualising DNA sequences and modifications

The ggDNAvis interactive suite provides a user-friendly interface for
using the ggDNAvis R package. There are three core visualisation
functions, which are accessed via the tabs along the top bar:

- Visualising a single DNA/RNA sequence
- Visualising multiple DNA/RNA sequences
- Visualising modification (e.g. methylation) of multiple DNA sequences

Within each tab, the sequence/modification information to be visualised
can be read from the input text boxes or via file upload. Once it has
been read, a visualisation will be created with all the default
parameters. Parameters can then be adjusted as desired from the list on
the left-hand side. Note that menus and sub-menus can be opened by
clicking the arrows to access the full array of settings.

Parameters can be exported to and restored from a JSON file from the
“Restore settings” tab at the bottom of the sidebar. Note that this does
*not* store uploaded file information, and will only store text input
information if the checkbox to do so is selected.

Final images can be downloaded at full resolution from the “Download
image” button at the bottom of the sidebar.

[![](https://raw.githubusercontent.com/ejade42/ggDNAvis/main/man/figures/logo.png)](https://ejade42.github.io/ggDNAvis/)

v1.0.0

[![](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/ejade42/ggDNAvis/badges/views_monthly.json)](https://ejade42.github.io/ggDNAvis/)
[![](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/ejade42/ggDNAvis/badges/views_total.json)](https://ejade42.github.io/ggDNAvis/)
[![](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/ejade42/ggDNAvis/badges/users_monthly.json)](https://ejade42.github.io/ggDNAvis/)
[![](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/ejade42/ggDNAvis/badges/users_total.json)](https://ejade42.github.io/ggDNAvis/)

This software is freely available under the open MIT licence, but please
make sure to cite the [ggDNAvis
paper](https://ejade42.github.io/ggDNAvis/authors.html#citation) when
using in publications or presentations.

Please report any bugs, difficulties, or feature requests to the [issues
page](https://github.com/ejade42/ggDNAvis/issues).

These interactive tools provide most of the functionality of the [full R
package](https://CRAN.R-project.org/package=ggDNAvis), and enable a
level of reproducibility via the settings import/export options.
However, using the full R package via re-runable scripts improves
reproducibility, as well as enabling advanced usage such as annotating
returned ggplot2 objects (see [example of adding ggplot2 elements to
visualisation](https://ejade42.github.io/ggDNAvis/dev/#id_68-think-about-the-offset)).
To get started with the code-based R package, read the
[documentation](https://ejade42.github.io/ggDNAvis/).

From an R session with ggDNAvis installed, a local version of this Shiny
application can be launched via `ggDNAvis_shinyapp()`.

Settings

Input

- [Text input](_w_fb24da88bc13452cb8e866a688170f09/#tab-9945-1)
- [Upload](_w_fb24da88bc13452cb8e866a688170f09/#tab-9945-2)

Sequence to visualise:

Upload FASTA/text:

Browse...

[ View file requirements](_w_fb24da88bc13452cb8e866a688170f09/#)

Layout

Bases per line:

Line spacing:

Margin:

Pixels per base:

Colours

Sequence colour palette:

bright_pale bright_pale2 bright_deep ggplot_style sanger accessible
custom

A

C

G

T/U

Background colour:

Sequence text colour:

Index annotation colour:

Outline colour:

Sizes and positions

Sequence text

Sequence text size:

Index annotations

Index annotation size:

Index annotation interval:

Index annotation height:

Index annotations above boxes

Always annotate first base

Always annotate last base

Outlines

Outline thickness:

Outline corner style:

mitre round bevel

Restore settings

Import settings

Browse...

[ Export settings](_w_fb24da88bc13452cb8e866a688170f09/)

Export sequence text input value (will override current value when
imported)

[ Download image](_w_fb24da88bc13452cb8e866a688170f09/)

![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxNiAxNiIgY2xhc3M9ImJpIGJpLWNoZXZyb24tbGVmdCBjb2xsYXBzZS1pY29uIiBzdHlsZT0iZmlsbDpjdXJyZW50Q29sb3I7IiBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIj48cGF0aCBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik0xMS4zNTQgMS42NDZhLjUuNSAwIDAgMSAwIC43MDhMNS43MDcgOGw1LjY0NyA1LjY0NmEuNS41IDAgMCAxLS43MDguNzA4bC02LTZhLjUuNSAwIDAgMSAwLS43MDhsNi02YS41LjUgMCAwIDEgLjcwOCAweiIgLz48L3N2Zz4=)

Settings

Input

- [Text input](_w_fb24da88bc13452cb8e866a688170f09/#tab-8694-1)
- [Upload](_w_fb24da88bc13452cb8e866a688170f09/#tab-8694-2)

Space-separated sequences to visualise:

[ View input requirements](_w_fb24da88bc13452cb8e866a688170f09/#)

Upload FASTQ:

Browse...

Upload metadata CSV:

Browse...

[ View file requirements](_w_fb24da88bc13452cb8e866a688170f09/#)

Layout

Margin:

Pixels per base:

Colours

Sequence colour palette:

bright_pale bright_pale2 bright_deep ggplot_style sanger accessible
custom

A

C

G

T/U

Background colour:

Sequence text colour:

Index annotation colour:

Outline colour:

Sizes and positions

Sequence text

Sequence text size:

Index annotations

Lines to annotate with indices (space-separated integers):

Index annotation size:

Index annotation interval:

Index annotation height:

Index annotations above boxes

Index annotations always go to the end of the line

Always annotate first base

Always annotate last base

Outlines

Outline thickness:

Outline corner style:

mitre round bevel

Restore settings

Note: if reading from a FASTQ+CSV, make sure you upload the files first
*then* import the settings, otherwise grouping settings will not import
properly.

Import settings

Browse...

[ Export settings](_w_fb24da88bc13452cb8e866a688170f09/)

Export sequence text input value (will override current value when
imported)

[ Download image](_w_fb24da88bc13452cb8e866a688170f09/)

![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxNiAxNiIgY2xhc3M9ImJpIGJpLWNoZXZyb24tbGVmdCBjb2xsYXBzZS1pY29uIiBzdHlsZT0iZmlsbDpjdXJyZW50Q29sb3I7IiBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIj48cGF0aCBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik0xMS4zNTQgMS42NDZhLjUuNSAwIDAgMSAwIC43MDhMNS43MDcgOGw1LjY0NyA1LjY0NmEuNS41IDAgMCAxLS43MDguNzA4bC02LTZhLjUuNSAwIDAgMSAwLS43MDhsNi02YS41LjUgMCAwIDEgLjcwOCAweiIgLz48L3N2Zz4=)

Settings

Input

- [Text input](_w_fb24da88bc13452cb8e866a688170f09/#tab-2397-1)
- [Upload](_w_fb24da88bc13452cb8e866a688170f09/#tab-2397-2)

Space-separated sequences to visualise:

Space-separated lists of modification locations:

Space-separated lists of modification probabilities

[ View input requirements](_w_fb24da88bc13452cb8e866a688170f09/#)

Upload modified FASTQ:

Browse...

Upload metadata CSV:

Browse...

[ View file requirements](_w_fb24da88bc13452cb8e866a688170f09/#)

Layout

Low probability clamping value:

High probability clamping value:

[ View probability clamping
explanation](_w_fb24da88bc13452cb8e866a688170f09/#)

Margin:

Pixels per base:

Colours

Colour for minimum modification probability:

Colour for maximum modification probability:

Colour for non-assessed bases:

Background colour:

Sequence text colour:

Index annotation colour:

- [Unified outline
  colour](_w_fb24da88bc13452cb8e866a688170f09/#tab-6581-1)
- [Split outline
  colours](_w_fb24da88bc13452cb8e866a688170f09/#tab-6581-2)

Outline colour:

Outline colour for modification-assessed bases:

Outline colour for non-assessed bases:

Sizes and positions

Sequence text

Sequence text type:

Sequence Probability None

Sequence text size:

Sequence text size:

Sequence text size:

Sequence text size:

Probability scaling:

Integers Probabilities Custom

Decimal places to display:

Decimal places to display:

Minimum value for scaling probabilities:

Maximum value for scaling probabilities:

[ View probability scaling
explanation](_w_fb24da88bc13452cb8e866a688170f09/#)

Index annotations

Lines to annotate with indices (space-separated integers):

Index annotation size:

Index annotation interval:

Index annotation height:

Index annotations above boxes

Index annotations always go to the end of the line

Always annotate first base

Always annotate last base

Outlines

- [Unified outline
  style](_w_fb24da88bc13452cb8e866a688170f09/#tab-5147-1)
- [Split outline
  styles](_w_fb24da88bc13452cb8e866a688170f09/#tab-5147-2)

Outline thickness:

Outline corner style:

mitre round bevel

Outline thickness for modification-assessed bases:

Outline thickness for non-assessed bases:

Outline corner style for modification-assessed bases:

mitre round bevel

Outline corner style for non-assessed bases:

mitre round bevel

Scalebar

Gradient precision:

Background colour:

Outline colour:

Outline thickness

Axis location:

top bottom left right

Axis title:

Display ticks on axis

Scalebar width:

Scalebar height:

Scalebar dpi:

Restore settings

Note: if reading from a FASTQ+CSV, make sure you upload the files first
*then* import the settings, otherwise grouping settings will not import
properly.

Import settings

Browse...

[ Export settings](_w_fb24da88bc13452cb8e866a688170f09/)

Export sequence / locations / probabilities text input value (will
override current value when imported)

[ Download main image](_w_fb24da88bc13452cb8e866a688170f09/) [ Download
scalebar](_w_fb24da88bc13452cb8e866a688170f09/)

![](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdib3g9IjAgMCAxNiAxNiIgY2xhc3M9ImJpIGJpLWNoZXZyb24tbGVmdCBjb2xsYXBzZS1pY29uIiBzdHlsZT0iZmlsbDpjdXJyZW50Q29sb3I7IiBhcmlhLWhpZGRlbj0idHJ1ZSIgcm9sZT0iaW1nIj48cGF0aCBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik0xMS4zNTQgMS42NDZhLjUuNSAwIDAgMSAwIC43MDhMNS43MDcgOGw1LjY0NyA1LjY0NmEuNS41IDAgMCAxLS43MDguNzA4bC02LTZhLjUuNSAwIDAgMSAwLS43MDhsNi02YS41LjUgMCAwIDEgLjcwOCAweiIgLz48L3N2Zz4=)
