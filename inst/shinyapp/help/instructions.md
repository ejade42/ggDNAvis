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

Parameters can be exported to and restored from a JSON file from the 
"Restore settings" tab at the bottom of the sidebar. 
Note that this does *not* store uploaded file information,
and will only store text input information if the checkbox to do so is selected.

Final images can be downloaded at full resolution from the "Download image" button
at the bottom of the sidebar.
