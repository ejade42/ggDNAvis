# ggDNAvis interactive suite instructions
##### 'ggplot2'-based tools for visualising DNA sequences and modifications

The ggDNAvis interactive suite provides a user-friendly interface
for using the ggDNAvis R package. There are three core visualisation
functions, which are accessed via the tabs along the top bar:
 * Visualising a single DNA/RNA sequence
 * Visualising multiple DNA/RNA sequences
 * Visualising modification (e.g. methylation) of multiple DNA sequences

Within each tab, the sequence/modification information to be visualised can be
read from the input text boxes or via file upload. Once it has been read,
a visualisation will be created with all the default parameters. 
Parameters can then be adjusted as desired from the list on the left-hand side.
Note that menus and sub-menus can be opened by clicking the arrows to access the
full array of settings.

Please report any bugs, difficulties, or feature requests to the [issues page][link_bugs].

*These interactive tools provide most of the functionality of the full R package,
and enable a level of reproducibility via the settings import/export options.
However, using the full R package via re-runable scripts improves reproducibility,
as well as enabling advanced usage such as annotating returned ggplot2 objects
(see [example of adding ggplot2 elements to visualisation][link_methylation_offset]).*

This software is freely available under the open MIT licence, but please make sure
to cite the [ggDNAvis paper][link_citation] when using in publications or presentations.
