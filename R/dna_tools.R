#' Resolve argument value when aliases are used (generic `ggDNAvis` helper)
#'
#' @description
#' See the [aliases] page for a general explanation of how aliases are used in `ggDNAvis`.
#'
#' This function takes the name and value for the 'primary' form of an argument
#' (generally British spellings in `ggDNAvis`), the name and value of an alternative
#' 'alias' form, and the default value of the 'primary' argument.
#'
#' If the alias has not been used (i.e. the 'alias' value is `NULL`) or if the 'primary'
#' value has been changed from the default, then the 'primary' value will be returned.
#' (Note that if the 'alias' value is not `NULL` and the 'primary' value has been changed
#' from the default, then the updated 'primary' value 'wins' and is returned, but with a
#' warning that explains that both values were set and the 'alias' has been discarded).
#'
#' If the alias has been used (i.e. the 'alias' value is not `NULL`) and the 'primary'
#' value is the default, then the 'alias' value will be returned.
#'
#' @param primary_name `character`. The usual name of the argument.
#' @param primary_val `value`. The value of the argument under its usual name.
#' @param alias_name `character`. An alternative alias name for the argument.
#' @param alias_val `value`. The value of the argument under its alias. Expected to be `NULL` if the alias argument is not being used.
#' @param primary_default `value`. The default value of the argument under its usual name, used to determine if the primary argument has been explicitly set.
#'
#' @return `value`. Either `primary_val` or `alias_val`, depending on the logic above.
#' @export
resolve_alias <- function(
    primary_name,
    primary_val,
    alias_name,
    alias_val,
    primary_default
) {
    ## This function doesn't cope is a mandatory argument is missing but its alias is provided.
    ## I don't think that shows up in the package, at least in user-facing functions.

    ## Validate arguments
    ## ---------------------------------------------------------------------
    single_char <- list(primary_name = primary_name, alias_name = alias_name)
    for (argument in names(single_char)) {
        if (!is.character(single_char[[argument]]) || length(single_char[[argument]]) != 1) {bad_arg(argument, single_char, "must be a character value with length 1.")}
    }
    single_char <- NULL
    ## ---------------------------------------------------------------------


    ## If alias has been provided:
    if (!is.null(alias_val)) {
        not_default <- !identical(primary_val, primary_default)

        ## If both are set, warn and return primary value
        if (not_default) {
            warn(paste0("Both '", primary_name, "' and alias '", alias_name, "' were provided.",
                        "\n'", alias_name,   "' will be discarded.\n    Value: ", paste0(alias_val, collapse = ""),
                        "\n'", primary_name, "' will be used.\n    Value: ", paste0(primary_val, collapse = "")),
                 class = "alias_conflict")
            return(primary_val)

        ## If primary is default and alias is set, return alias
        } else {
            return(alias_val)
        }
    ## If alias was not provided, return primary:
    } else {
        return(primary_val)
    }
}

debug_initialise <- function(debug, function_name) {
    if (any(is.na(debug)) || any(is.null(debug)) || !is.logical(debug) || length(debug) != 1) {
        bad_arg("debug", list(debug = debug), "must be a single logical/boolean value.")
    }
    start_time <- Sys.time()
    if (debug) {
        cli_alert_info("Verbose monitoring enabled")
        cli_alert_info(paste(format(start_time, "(%Y-%m-%d %H:%M:%S)"), function_name, "start"))
    }
    return(start_time)
}

debug_monitor <- function(debug, start_time, previous_time, message) {
    if (!debug) {return(invisible(NULL))}

    current_time <- Sys.time()
    time_since_start <- format_time_diff(current_time, start_time, 4)
    time_since_prior <- format_time_diff(current_time, previous_time, 4)

    cli_alert_info(paste0("(", time_since_prior, " secs elapsed; ",
                          time_since_start, " secs total) ",
                          message))
    return(current_time)
}

format_time_diff <- function(new_time, old_time, characters_to_print) {
    diff <- as.numeric(difftime(new_time, old_time, units = "secs"))
    digits_before_decimal <- max(floor(log10(diff)) + 1, 1)
    digits_after_decimal <- characters_to_print - digits_before_decimal
    formatted_diff <- sprintf("%.*f", digits_after_decimal, diff)
    return(formatted_diff)
}

#' Emit an error message for an invalid function argument (generic `ggDNAvis` helper)
#'
#' This function takes an argument name, a named list of arguments
#' (presumably being iterated over for a particular validation check),
#' and a message. Using [rlang::abort()], it prints an error message of the form:
#' \preformatted{Argument '<argument_name>' <message>
#' Current value: <argument_value>
#' Current class: <class(argument_value)>
#' }
#' If the argument value is a named item (i.e. `names(arguments_list[[argument_name]])`
#' is not null), or if `force_names` is `TRUE`, then the form will be:
#' \preformatted{Argument '<argument_name>' <message>
#' Current value: <argument_value>
#' Current names: <argument_names>
#' Current class: <class(argument_value)>
#' }
#'
#' @param argument_name `character`. The name of the argument that caused the error
#' @param arguments_list `list`. A named list where `arguments_list[[argument_name]]` is the value of the offending argument.
#' @param message `character`. The message that should be printed to describe why the argument is invalid.
#' @param class `character`. The class that the error should have. Defaults to `"argument_value_or_type"` for my own use.
#' @param force_names `logical`. Whether the names argument should be printed even if names is `NULL`. Defaults to `FALSE`.
#'
#' @return Nothing, but causes an error exit via [rlang::abort()]
#'
#' @examples
#' ## Obviously this error-message function causes an error,
#' ## so needs to be wrapped in try() for these examples
#'
#' ## Standard use
#' positive_args <- list(number = -1)
#' try(bad_arg("number", positive_args, "must be positive"))
#'
#' ## Automatically detects named item and prints names
#' named <- list(x = c("first item" = 1, "second item" = 7))
#' try(bad_arg("x", named, "is not acceptable"))
#'
#' ## Can force name printing
#' try(bad_arg("number", positive_args, "must be positive", force_names = TRUE))
#'
#' @export
bad_arg <- function(argument_name, arguments_list, message, class = "argument_value_or_type", force_names = FALSE) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    length_1_char <- list(argument_name = argument_name, message = message, class = class)
    for (argument in names(length_1_char)) {
        if (any(is.na(length_1_char[[argument]]))) {
            bad_arg(argument, length_1_char, "must not be NA.")
        }
        if (any(is.null(length_1_char[[argument]]))) {
            bad_arg(argument, length_1_char, "must not be NULL.")
        }
        if (length(length_1_char[[argument]]) != 1) {
            bad_arg(argument, length_1_char, "must have length 1.")
        }
        if (is.character(length_1_char[[argument]]) == FALSE) {
            bad_arg(argument, length_1_char, "must be of type character.")
        }
    }
    if (!is.list(arguments_list)) {
        bad_arg("arguments_list", list(arguments_list = arguments_list), "must be a list.")
    }
    if (!(argument_name %in% names(arguments_list))) {
        abort(paste0("Argument 'argument_name' must be the name of an item in named list 'arguments_list'.\nargument_name: ", argument_name, "\nCurrent names of arguments_list: ", paste(names(arguments_list), collapse = ", ")), class = "argument_value_or_type")
    }
    if (any(is.null(names(arguments_list))) || "" %in% names(arguments_list)) {
        abort("Ev has clearly made a typo in argument validation that meant one of the argument list names is missing. Contact maintainer.", class = "contact_maintainer")
    }
    ## ---------------------------------------------------------------------

    error_message <- paste0("Argument '", argument_name, "' ", message)
    error_message <- paste0(error_message, "\nCurrent class: ", class(arguments_list[[argument_name]]))
    error_message <- paste0(error_message, "\nCurrent value: ", paste(arguments_list[[argument_name]], collapse = ", "))
    if (!is.null(names(arguments_list[[argument_name]])) || force_names) {
        error_message <- paste0(error_message, "\nCurrent names: ", paste(names(arguments_list[[argument_name]]), collapse = ", "))
    }
    abort(error_message, class = class, call = rlang::caller_env())
}


## Basic utilities for vector and string conversion
## ------------------------------------------------------------------------------------------

#' Split a `","`-joined string back to a vector (generic `ggDNAvis` helper)
#'
#' Takes a string (character) produced by [vector_to_string()] and recreates the vector.\cr\cr
#' Note that if a vector of multiple strings is input (e.g. `c("1,2,3", "9,8,7"`)) the output
#' will be a single concatenated vector (e.g. `c(1, 2, 3, 9, 8, 7)`).\cr\cr
#' If the desired output is a list of vectors, try [lapply()] e.g.
#' `lapply(c("1,2,3", "9,8,7"), string_to_vector)` returns `list(c(1, 2, 3), c(9, 8, 7))`.
#'
#' @param string `character`. A comma-separated string (e.g. `"1,2,3"`) to convert back to a vector.
#' @param type `character`. The type of the vector to be returned i.e. `"numeric"` (default), `"character"`, or `"logical"`.
#' @param sep `character`. The character used to separate values in the string. Defaults to `","`. *Do not set to anything that might occur within one of the values*.
#' @return `<type> vector`. The resulting vector (e.g. `c(1, 2, 3)`).
#'
#' @examples
#' ## String to numeric vector (default)
#' string_to_vector("1,2,3,4")
#' string_to_vector("1,2,3,4", type = "numeric")
#' string_to_vector("1;2;3;4", sep = ";")
#'
#' ## String to character vector
#' string_to_vector("A,B,C,D", type = "character")
#'
#' ## String to logical vector
#' string_to_vector("TRUE FALSE TRUE", type = "logical", sep = " ")
#'
#' ## By default, vector inputs are concatenated
#' string_to_vector(c("1,2,3", "4,5,6"))
#'
#' ## To create a list of vector outputs, use lapply()
#' lapply(c("1,2,3", "4,5,6"), string_to_vector)
#'
#' @export
string_to_vector <- function(string, type = "numeric", sep  = ",") {
    if (tolower(type) == "numeric") {
        return(as.numeric(unlist(strsplit(string, split = sep))))
    } else if (tolower(type) == "character") {
        return(as.character(unlist(strsplit(string, split = sep))))
    } else if (tolower(type) == "logical") {
        return(as.logical(unlist(strsplit(string, split = sep))))
    } else {
        abort(paste("Didn't recognise vector type:", type, "\n(currently set up for numeric, character, or logical only)"), class = "argument_value_or_type")
    }
}

#' Join a vector into a comma-separated string (generic `ggDNAvis` helper)
#'
#' Takes a vector and condenses it into a single string by joining items with `","`.
#' Reversed by [string_to_vector()].
#'
#' @param vector `vector`. A vector (e.g. `c(1,2,3)`) to convert to a string.
#' @param sep `character`. The character used to separate values in the string. Defaults to `","`. *Do not set to anything that might occur within one of the values*.
#' @return `character`. The same vector but as a comma-separated string (e.g. `"1,2,3"`).
#'
#' @examples
#' vector_to_string(c(1, 2, 3, 4))
#' vector_to_string(c("These", "are", "some", "words"))
#' vector_to_string(3:5, sep = ";")
#'
#' @export
vector_to_string <- function(vector, sep = ",") {paste(vector, collapse = sep)}


#' Print a numeric vector to console (`ggDNAvis` debug helper)
#'
#' Takes a numeric vector, and prints it to the console separated by `", "`.\cr\cr
#' This allows the output to be copy-pasted into a vector within an R script.
#' Used for taking vector outputs and then writing them as literals within a script. \cr\cr
#' E.g. when given input `1:5`, prints `1, 2, 3, 4, 5`, which can be directly copy-pasted
#' within `c()` to input that vector. Printing normally via `print(1:5)` instead prints
#' `[1] 1 2 3 4 5`, which is not valid vector input so can't be copy-pasted directly.\cr\cr
#' See [debug_join_vector_str()] for the equivalent for character/string vectors.
#'
#' @param vector `numeric vector`. Usually generated by some other function. This function allows copy-pasting the output to directly create a vector with this value.
#' @return None (invisible `NULL`) - uses [cat()] to output directly to console.
#'
#' @examples
#' debug_join_vector_num(1:5)
#'
#' @export
debug_join_vector_num <- function(vector) {cat(paste(vector, collapse = ", "))}


#' Print a character/string vector to console (`ggDNAvis` debug helper)
#'
#' Takes a character/string vector, and prints it to the console separated by `", "`.\cr\cr
#' This allows the output to be copy-pasted into a vector within an R script.
#' Used for taking vector outputs and then writing them as literals within a script. \cr\cr
#' E.g. when given input `strsplit("ABCD", split = "")[[1]]`, prints `"A", "B", "C", "D"`,
#' which can be directly copy-pasted within `c()` to input that vector.
#' Printing normally via `print(strsplit("ABCD", split = "")[[1]])` instead prints
#' `[1] "A" "B" "C" "D"`, which is not valid vector input so can't be copy-pasted directly.\cr\cr
#' See [debug_join_vector_num()] for the equivalent for numeric vectors.
#'
#' @param vector `character vector`. Usually generated by some other function. This function allows copy-pasting the output to directly create a vector with this value.
#' @return None (invisible `NULL`) - uses [cat()] to output directly to console.
#'
#' @examples
#' debug_join_vector_str(c("A", "B", "C", "D"))
#'
#' @export
debug_join_vector_str <- function(vector) {cat('"', paste(vector, collapse = '", "'), '"', sep = "")}

## ------------------------------------------------------------------------------------------




#' Reverse complement a DNA/RNA sequence (generic `ggDNAvis` helper)
#'
#' This function takes a string/character representing a DNA/RNA sequence and returns
#' the reverse complement. Either DNA (`A/C/G/T`) or RNA (`A/C/G/U`) input is accepted. \cr\cr
#' By default, output is DNA (so `A` is reverse-complemented to `T`), but it can be set
#' to output RNA (so `A` is reverse-complemented to `U`).
#'
#' @param sequence `character`. A DNA/RNA sequence (`A/C/G/T/U`) to be reverse-complemented. No other characters allowed. Only one sequence allowed.
#' @param output_mode `character`. Either `"DNA"` (default) or `"RNA"`, to determine whether `A` should be reverse-complemented to `T` or to `U`.
#' @return `character`. The reverse-complement of the input sequence.
#'
#' @examples
#' reverse_complement("ATGCTAG")
#' reverse_complement("UUAUUAGC", output_mode = "RNA")
#' reverse_complement("AcGtU", output_mode = "DNA")
#' reverse_complement("aCgTU", output_mode = "RNA")
#'
#' @export
reverse_complement <- function(sequence, output_mode = "DNA") {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_na_or_null <- list(sequence = sequence, output_mode = output_mode)
    for (argument in names(not_na_or_null)) {
        if (any(is.null(not_na_or_null[[argument]])) || any(is.na(not_na_or_null[[argument]]))) {bad_arg(argument, not_na_or_null, "must not be NULL or NA.")}
    }
    not_na_or_null <- NULL

    if (length(sequence) != 1) {
        bad_arg("sequence", list(sequence = sequence), "must have length 1. Try sapply(input_vector, reverse_complement) to use on more than one sequence.", class = "argument_length")
    }
    if (length(output_mode) != 1) {
        bad_arg("output_mode", list(output_mode = output_mode), "must be a single value (either 'DNA' or 'RNA')", class = "argument_length")
    }

    chars <- list(sequence = sequence, output_mode = output_mode)
    for (argument in names(chars)) {
        if (!is.character(chars[[argument]])) {bad_arg(argument, chars, "must be a character/string value.")}
    }
    ## ---------------------------------------------------------------------


    if (nchar(sequence) == 0) {
        return("")
    }

    sequence_vector     <- strsplit(toupper(sequence), split = "")[[1]]
    reversed_vector     <- rev(sequence_vector)
    new_sequence_vector <- rep(NA, length(reversed_vector))

    for (i in 1:length(reversed_vector)) {
        if (reversed_vector[i] == "A") {
            if (toupper(output_mode) == "DNA") {
                new_sequence_vector[i] <- "T"
            } else if (toupper(output_mode) == "RNA") {
                new_sequence_vector[i] <- "U"
            } else {
                bad_arg("output_mode", list(output_mode = output_mode), "must be either 'DNA' (default) or 'RNA'.")
            }
        } else if (reversed_vector[i] == "C") {
            new_sequence_vector[i] <- "G"
        } else if (reversed_vector[i] == "G") {
            new_sequence_vector[i] <- "C"
        } else if (reversed_vector[i] %in% c("T", "U")) {
            new_sequence_vector[i] <- "A"
        } else {
            abort(paste0("Cannot reverse sequence for non-A/C/G/T/U.\nNon-compliant character: ", reversed_vector[i]), class = "argument_value_or_type")
        }
    }

    new_sequence <- paste(new_sequence_vector, collapse = "")
    return(new_sequence)
}



## These next two functions work together to encode
## sequence numerically for visualisation.
## A = 1, C = 2, G = 3, T/U = 4, blank = 0

#' Map a single base to the corresponding number (generic `ggDNAvis` helper)
#'
#' This function takes a single base and numerically
#' encodes it for visualisation via [rasterise_matrix()]. \cr\cr
#' Encoding: `A = 1`, `C = 2`, `G = 3`, `T/U = 4`.
#'
#' @param base `character`. A single DNA/RNA base to encode numerically (e.g. `"A"`).
#' @return `integer`. The corresponding number.
#'
#' @examples
#' convert_base_to_number("A")
#' convert_base_to_number("c")
#' convert_base_to_number("g")
#' convert_base_to_number("T")
#' convert_base_to_number("u")
#'
#' @export
convert_base_to_number <- function(base) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    if (length(base) != 1) {
        bad_arg("base", list(base = base), "must have length 1.", class = "argument_length")
    }
    ## ---------------------------------------------------------------------

    base <- toupper(base)
    if (base == "A") {
        number <- 1
    } else if (base == "C") {
        number <- 2
    } else if (base == "G") {
        number <- 3
    } else if (base %in% c("T", "U")) {
        number <- 4
    } else {
        bad_arg("base", list(base = base), "must be one of A/C/G/T/U to convert to number.")
    }
    return(number)
}

#' Map a sequence to a vector of numbers (generic `ggDNAvis` helper)
#'
#' This function takes a sequence and encodes it as a vector
#' of numbers for visualisation via [rasterise_matrix()]. \cr\cr
#' Encoding: `A = 1`, `C = 2`, `G = 3`, `T/U = 4`.
#'
#' @param sequence `character`. A DNA/RNA sequence (`A/C/G/T/U`) to be encoded numerically. No other characters allowed. Only one sequence allowed.
#' @param length `integer`. How long the output numerical vector should be. If shorter than the sequence, the vector will include the first *n* bases up to this length. If longer than the sequence, the vector will be padded with 0s at the end. If left blank/set to `NA` (default), will output a vector the same length as the input sequence.
#' @return `integer vector`. The numerical encoding of the input sequence, cut/padded to the desired length.
#'
#' @examples
#' convert_sequence_to_numbers("ATCGATCG")
#' convert_sequence_to_numbers("ATCGATCG", length = NA)
#' convert_sequence_to_numbers("ATCGATCG", length = 4)
#' convert_sequence_to_numbers("ATCGATCG", length = 10)
#'
#' @export
convert_sequence_to_numbers <- function(sequence, length = NA) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    if (length(sequence) != 1) {
        bad_arg("sequence", list(sequence = sequence), "must be a single character/string value.", class = "argument_length")
    }
    if (length(length) != 1) {
        bad_arg("length", list(length = length), "must be a single integer (or NA) value.", class = "argument_length")
    }
    if (is.na(length)) {
        length <- nchar(sequence)
    } else if (!is.numeric(length)|| length %% 1 != 0 || length < 0) {
        bad_arg("length", list(length = length), "must be a non-negative integer or NA.")
    }
    ## ---------------------------------------------------------------------

    if (length == 0) {     ## specifically not else if, to return empty num vector if length not specified but sequence length is 0
        return(numeric(0))
    }

    numerical_vector <- NULL
    for (i in 1:length) {
        if (i <= nchar(sequence)) {
            numerical_vector[i] <- convert_base_to_number(substr(sequence, i, i))
        } else {
            numerical_vector[i] <- 0
        }
    }

    return(numerical_vector)
}



#' Rasterise a vector of sequences into a numerical dataframe for ggplotting (generic `ggDNAvis` helper)
#'
#' Takes a character vector of sequences (which are allowed to be empty `""` to
#' act as a spacing line) and rasterises it into a dataframe that ggplot can read.
#'
#' @param sequences `character vector`. A vector of sequences for plotting, e.g. `c("ATCG", "", "GGCGGC", "")`. Each sequence will be plotted left-aligned on a new line.
#' @return `dataframe`. Rasterised dataframe representation of the sequences, readable by [ggplot2::ggplot()].
#'
#' @examples
#' create_image_data(c("ATCG", "", "GGCGGC", ""))
#'
#' @export
create_image_data <- function(sequences) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    if (is.character(sequences) == FALSE) {
        bad_arg("sequences", list(sequences = sequences), "must be a character vector.")
    }
    ## ---------------------------------------------------------------------


    max_length <- max(nchar(sequences))
    image_matrix <- matrix(NA, nrow = length(sequences), ncol = max_length)
    for (i in 1:length(sequences)) {
        numeric_sequence_representation <- convert_sequence_to_numbers(sequences[i], max_length)
        image_matrix[i, ] <- numeric_sequence_representation
    }

    image_data <- rasterise_matrix(image_matrix)
    return(image_data)
}


#' Rasterise a matrix to an x/y/layer dataframe (generic `ggDNAvis` helper)
#'
#' @aliases rasterize_matrix
#'
#' @description
#' `rasterize_matrix()` is an alias for this function.
#'
#' This function takes a matrix and rasterises it to a dataframe of x and y
#' coordinates, such that the matrix occupies the space from (0, 0) to (1, 1) and each
#' element of the matrix represents a rectangle with width 1/ncol(matrix) and height
#' 1/nrow(matrix). The "layer" column of the dataframe is simply the value of each element
#' of the matrix.
#'
#' @param image_matrix `matrix`. A matrix (or anything that can be coerced to a matrix via [base::as.matrix()]).
#' @return `dataframe`. A dataframe containing x and y coordinates for the centre of a rectangle per element of the matrix, such that the whole matrix occupies the space from (0, 0) to (1, 1). Additionally contains a layer column storing the value of each element of the matrix.
#'
#' @examples
#' ## Create numerical matrix
#' example_matrix <- matrix(1:16, ncol = 4, nrow = 4, byrow = TRUE)
#'
#' ## View
#' example_matrix
#'
#' ## Rasterise
#' rasterise_matrix(example_matrix)
#'
#'
#'
#' ## Create character matrix
#' example_matrix <- matrix(
#'     c("A", "B", "C", "D", "E",
#'       "F", "G", "H", "I", "J"),
#'     nrow = 2, ncol = 5, byrow = TRUE
#' )
#'
#' ## View
#' example_matrix
#'
#' ## Rasterise
#' rasterise_matrix(example_matrix)
#'
#'
#'
#' ## Create realistic DNA matrix
#' dna_matrix <- matrix(
#'     c(0, 0, 0, 0, 0, 0, 0, 0,
#'       3, 3, 2, 3, 3, 2, 4, 4,
#'       0, 0, 0, 0, 0, 0, 0, 0,
#'       4, 1, 4, 1, 0, 0, 0, 0),
#'     nrow = 4, ncol = 8, byrow = TRUE
#' )
#'
#' ## View
#' dna_matrix
#'
#' ## Rasterise
#' rasterise_matrix(dna_matrix)
#'
#' @export
rasterise_matrix <- function(image_matrix) {
    image_matrix <- as.matrix(image_matrix)

    n <- nrow(image_matrix)
    k <- ncol(image_matrix)

    blank <- rep(0, length(image_matrix))
    output_dataframe <- data.frame(x = blank, y = blank, layer = blank)
    count <- 1L
    for (i in 1:n) {
        for (j in 1:k) {
            output_dataframe[count, "x"] <- (j-0.5)/k
            output_dataframe[count, "y"] <- 1 - (i-0.5)/n
            output_dataframe[count, "layer"] <- image_matrix[i,j]
            count <- count + 1L
        }
    }
    return(output_dataframe)
}


## Define alias
#' @rdname rasterise_matrix
#' @usage NULL
#' @export
rasterize_matrix <- rasterise_matrix
