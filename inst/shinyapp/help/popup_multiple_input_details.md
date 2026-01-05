Multiple sequence visualisation operates on a character vector of sequences, 
where each element of the vector is drawn on a new line.

For interactive text input, the entered text is split into a vector via
`strsplit(input_text, split = " ")[[1]]`
i.e. every space delineates a new line, and multiple spaces in 
a row allow insertion of blank lines for spacing.

Valid characters in the input text are A/C/G/T/U 
(uppercase or lowercase) and spaces for separation. 
Any other characters will trigger an error.
