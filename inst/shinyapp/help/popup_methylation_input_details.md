Methylation visualisation operates on three character vectors
of read sequences, locations, and probabilities. 
Each element of the vectors represents one line.

For interactive text input, the entered text is split into a vector via
`strsplit(input_text, split = " ")[[1]]`
i.e. every space delineates a new line, 
and multiple spaces in a row allow insertion of blank lines for spacing.

##### Sequences
The sequence input must consist entirely of A/C/G/T/U (uppercase or lowercase), 
plus spaces to separate the vector elements. 

##### Locations
The locations input must give the indices (starting at 1) along each read at which
modification probabilities were assessed, separated by commas but no spaces for each element
e.g. `"3,6,9,15"` would indicate that the third, sixth, ninth, and fifteenth bases along
that read were assessed for modification probability. These comma-separated items are themselves
space-separated for different reads e.g. `"3,6,9,15 2,4"`.

##### Probabilities
The probabilities input is similarly a comma-separated list of numbers per read, with reads separated
by spaces. In this case, the numbers are generally 8-bit integers (0-255) representing the probability
of modification at each modification-assessed base in order, where integer $p$ represents the probability
space from $\frac{p}{256}$ to $\frac{p+1}{256}$. An example would be `"255,0,24,189 56,127"`. 

This is in accordance with the SAM/BAM specification for the MM and ML tags, which are how modification
information is stored in SAM/BAM files (which can also be written into the header of FASTQ files).

*Note: it is technically possible to use alternative probability spaces, such as by inputting 
`"0.11,0.32,0.45,0.90"` etc. In this case, the clamping values in the 'Layout' settings *must*
be set to the lower and upper limits of the probability space e.g. 0 and 1 respectively. However,
various features will not work correctly, including clamping not being available and the scalebar 
displaying incorrectly. It is recommended to just convert to the nearest 8-bit integer for full compatibility, 
e.g. via `round((256 * probability) - 0.5)`.*
