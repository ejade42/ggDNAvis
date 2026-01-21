#' Resolve argument value when aliases are used (generic `ggDNAvis` helper)
#'
#' @description
#' See the [aliases] page for a general explanation of how aliases are used in `ggDNAvis`.
#'
#' This function takes the name and value for the 'primary' form of an argument
#' (generally British spellings in `ggDNAvis`), the name of an alternative
#' 'alias' form, the dots (unrecognised argument) environment, and the default value of the 'primary' argument.
#'
#' If the alias has not been used (i.e. the alias is not present in the dots env) or if the 'primary'
#' value has been changed from the default, then the 'primary' value will be returned.
#' (Note that if the alias is present in the dots env and the 'primary' value has been changed
#' from the default, then the updated 'primary' value 'wins' and is returned, but with a
#' warning that explains that both values were set and the 'alias' has been discarded).
#'
#' If the alias has been used (i.e. the alias is present in the dots env) and the 'primary'
#' value is the default, then the 'alias' value will be returned.
#'
#' This function is most often used when called by [resolve_alias_map()].
#'
#' @param primary_name `character`. The usual name of the argument.
#' @param primary_val `value`. The value of the argument under its usual name.
#' @param primary_default `value`. The default value of the argument under its usual name, used to determine if the primary argument has been explicitly set.
#' @param alias_name `character`. An alternative alias name for the argument.
#' @param dots_env `environment`. The environment created from the dots list. *WILL BE MODIFIED* by this function - alias is removed if it exists, to allow searching this environment for any unused arguments.
#'
#' @return `value`. Either `primary_val` or `alias_val`, depending on the logic above.
#' @export
#'
#' @examples
#' low_colour <- "blue" ## e.g. default value from function call
#' dots_env <- list2env(list(low_color = "pink")) ## e.g. low_color = "pink" set in function call
#' low_colour <- resolve_alias("low_colour", low_colour, "blue", "low_color", dots_env)
#' low_colour ## check to see what value was stored
#'
resolve_alias <- function(
    primary_name,
    primary_val,
    primary_default,
    alias_name,
    dots_env
) {
    ## This function doesn't cope if a mandatory argument is missing but its alias is provided.
    ## I don't think that shows up in the package, at least in user-facing functions, because
    ## mandatory arguments don't get aliases.

    ## Validate arguments
    ## ---------------------------------------------------------------------
    single_char <- list(primary_name = primary_name, alias_name = alias_name)
    for (argument in names(single_char)) {
        if (!is.character(single_char[[argument]]) || length(single_char[[argument]]) != 1) {bad_arg(argument, single_char, "must be a character value with length 1.")}
    }
    single_char <- NULL
    ## ---------------------------------------------------------------------


    ## If alias has been provided:
    if (exists(alias_name, envir = dots_env)) {
        ## Get alias value from dots environment
        ## Remove alias from dots environment
        alias_val <- get(alias_name, envir = dots_env)
        rm(list = alias_name, envir = dots_env)

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

#' Process an alias map list (generic `ggDNAvis` helper)
#'
#' @description
#' See the [aliases] page for a general explanation of how aliases are used in `ggDNAvis`.
#'
#' This function takes an alias map and the environment constructed from non-formal
#' arguments (...) to the calling function, and optionally an environment to function inside,
#' and works through the aliases provided in the map via [resolve_alias()].
#'
#' If any arguments were given that aren't in the alias map an error is raised.
#'
#' @param alias_map `list`. A list where each entry takes the name of a formal argument in the calling function, and each value is a list containing `"default"` (the default value of the formal argument) and `"aliases"` (a character vector of all allowed aliases for the formal argument). Aliases are processed in the order given in the character vector, with earlier aliases taking precedence.
#' @param target_env `environment`. The environment in which variables should be modified. Generally [parent.frame()] i.e. the calling function.
#' @inheritParams resolve_alias
#'
#' @return Nothing (variables are modified within the `target_env`).
#' @export
#'
#' @examples
#' ## Alias map (from within function code)
#' alias_map <- list(
#'    low_colour = list(default = "blue", aliases = c("low_color", "low_col")),
#'    high_colour = list(default = "red", aliases = c("high_color", "high_col"))
#' )
#'
#' ## Default values (would come from formal arguments)
#' low_colour = "blue" ## default
#' high_colour = "green" ## changed from default
#'
#' ## Extra arguments provided by name
#' dots_env <- list2env(list("low_col" = "black", "low_color" = "white", "high_color" = "orange"))
#'
#' ## Process
#' resolve_alias_map(alias_map, dots_env)
#'
#' ## See values
#' print(low_colour)
#' print(high_colour)
#'
resolve_alias_map <- function(alias_map, dots_env, target_env = parent.frame()) {
    ## Process aliases
    for (argument in names(alias_map)) {
        argument_map <- alias_map[[argument]]
        current_val  <- get(argument, envir = target_env)

        ## Loop through aliases - precedence depends on order in alias map vector
        for (alias in argument_map[["aliases"]]) {
            current_val <- resolve_alias(
                primary_name = argument,
                primary_val = current_val,
                primary_default = argument_map[["default"]],
                alias_name = alias,
                dots_env = dots_env
            )
        }

        ## Assign argument in parent environment
        assign(argument, current_val, envir = target_env)
    }

    ## Give error if any arguments are unrecognised
    unused_args <- ls(envir = dots_env)
    error_message <- paste("Unrecognised arguments:", paste(unused_args, collapse = ", "))
    if (length(unused_args) > 0) {
        abort(error_message, class = "unrecognised_argument", call = rlang::caller_env())
    }
}


#' Start performance monitoring (generic `ggDNAvis` helper)
#'
#' @description
#' This function takes a bool of whether verbose performance
#' monitoring is on, as well as the name of the calling function,
#' prints a monitoring initialisation message (if desired),
#' and returns the start time.
#'
#' Later monitoring steps are performed by [monitor()]
#'
#' @param monitor_performance `logical`. Whether verbose performance monitoring should be enabled.
#' @param function_name `character`. The name of the calling function, printed as part of the monitoring initialisation message.
#'
#' @return `POSIXct` the time at which the function was initialised, via [Sys.time()].
#' @export
#'
#' @examples
#' ## Initialise monitoring
#' start_time <- monitor_start(TRUE, "my_cool_function")
#'
#' ## Step 1
#' monitor_time <- monitor(TRUE, start_time, start_time, "performing step 1")
#' x <- 2 + 2
#'
#' ## Step 2
#' monitor_time <- monitor(TRUE, start_time, monitor_time, "performing step 2")
#' y <- 10.5^6 %% 345789
#'
#' ## Step 3
#' monitor_time <- monitor(TRUE, start_time, monitor_time, "performing step 3")
#' z <- y / x^2
#'
#' ## Conclude monitoring
#' monitor_time <- monitor(TRUE, start_time, monitor_time, "done")
#'
monitor_start <- function(monitor_performance, function_name) {
    start_time <- Sys.time()

    ## Validate arguments
    if (any(is.na(monitor_performance)) || any(is.null(monitor_performance)) || !is.logical(monitor_performance) || length(monitor_performance) != 1) {
        bad_arg("monitor_performance", list(monitor_performance = monitor_performance), "must be a single logical/boolean value.")
    }

    ## If monitoring is on, start messaging
    if (monitor_performance) {
        cli_alert_info("Verbose monitoring enabled")
        cli_alert_info(paste(format(start_time, "(%Y-%m-%d %H:%M:%S)"), function_name, "start"))
    }

    return(start_time)
}

#' Continue performance monitoring (generic `ggDNAvis` helper)
#'
#' @description
#' This function is meant to be called frequently throughout
#' a main function, and if verbose performance monitoring is enabled
#' then it will print the elapsed time since (a) initialisation via
#' [monitor_start()] and (b) since the last step was recorded via
#' this function.
#'
#' @inheritParams monitor_start
#' @param start_time `POSIXct`. The time at which the overarching function was initialised (generally via [monitor_start()]).
#' @param previous_time `POSIXct`. The time at which the previous step was recorded (via a prior call to [monitor()]).
#' @param message `character`. The message to be printed, generally indicating what this step is doing
#'
#' @return `POSIXct` the time at which the function was called, via [Sys.time()].
#' @export
#'
#' @examples
#' ## Initialise monitoring
#' start_time <- monitor_start(TRUE, "my_cool_function")
#'
#' ## Step 1
#' monitor_time <- monitor(TRUE, start_time, start_time, "performing step 1")
#' x <- 2 + 2
#'
#' ## Step 2
#' monitor_time <- monitor(TRUE, start_time, monitor_time, "performing step 2")
#' y <- 10.5^6 %% 345789
#'
#' ## Step 3
#' monitor_time <- monitor(TRUE, start_time, monitor_time, "performing step 3")
#' z <- y / x^2
#'
#' ## Conclude monitoring
#' monitor_time <- monitor(TRUE, start_time, monitor_time, "done")
#'
monitor <- function(monitor_performance, start_time, previous_time, message) {
    if (!monitor_performance) {return(invisible(NULL))}

    current_time <- Sys.time()
    time_since_start <- format_time_diff(current_time, start_time, 4)
    time_since_prior <- format_time_diff(current_time, previous_time, 4)

    cli_alert_info(paste0("(", time_since_prior, " secs elapsed; ",
                          time_since_start, " secs total) ",
                          message))
    return(current_time)
}


#' Format a difference between times (generic `ggDNAvis` helper)
#'
#' @description
#' This function takes two times (class `"POSIXct"`) and formats
#' the difference between them nicely, with a certain number
#' of numerical characters printed.
#'
#' Note that the if the time difference rounded to the integer
#' number of seconds (e.g. 1234 seconds) requires more space than
#' the number of characters allocated (e.g. 3 characters) then
#' it will go beyond the specified characters.
#' However, this would be an exceptionally slow-running function.
#' In normal monitoring use for [monitor()],
#' <1 second steps should be nearly universal, and <0.01 second
#' steps are very common.
#'
#'
#' @param new_time `POSIXct`. The more recent (newer) of the two times to calculate a difference between.
#' @param old_time `POSIXct`. The less recent (older) of the two times to calculate a difference between.
#' @param characters_to_print `integer`. How many numeric digits should be printed.
#'
#' @return `character`. The formatted time difference in seconds.
#' @export
#'
#' @examples
#' ## POSIXct time is a very large number of seconds
#' newer <- 1000000001
#' older <- 1000000000
#' format_time_diff(newer, older, 4)
#'
#' newer <- 1000000456.45645
#' older <- 1000000000
#' format_time_diff(newer, older, 4)
#' format_time_diff(newer, older, 3)
#' format_time_diff(newer, older, 2)
#'
#' newer <- 1000000000.011
#' older <- 1000000000
#' format_time_diff(newer, older, 4)
#' format_time_diff(newer, older, 3)
#' format_time_diff(newer, older, 2)
#'
format_time_diff <- function(new_time, old_time, characters_to_print = 4) {
    diff <- as.numeric(difftime(new_time, old_time, units = "secs"))
    digits_before_decimal <- max(floor(log10(diff)) + 1, 1)
    digits_after_decimal <- characters_to_print - digits_before_decimal
    formatted_diff <- sprintf("%.*f", max(digits_after_decimal, 0), diff)
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
#' @description
#' This function takes a string/character representing a DNA/RNA sequence and returns
#' the reverse complement. Either DNA (`A/C/G/T`) or RNA (`A/C/G/U`) input is accepted.
#'
#' By default, output is DNA (so `A` is reverse-complemented to `T`), but it can be set
#' to output RNA (so `A` is reverse-complemented to `U`).
#'
#' Alternatively, if `output_mode` is set to `"reverse_only"` then the sequence will be
#' reversed as-is without being complemented. Note that this also skips sequence validation,
#' meaning any string can be reversed even if it contains non-A/C/G/T/U characters.
#'
#' @param sequence `character`. A DNA/RNA sequence (`A/C/G/T/U`) to be reverse-complemented. No other characters allowed. Only one sequence allowed.
#' @param output_mode `character`. `"DNA"` (default) or `"RNA"` to determine whether `A` should be reverse-complemented to `T` or `U` respectively, or `"reverse_only"` to reverse the order of the characters without complementing.
#' @return `character`. The reverse-complement of the input sequence.
#'
#' @examples
#' reverse_complement("ATGCTAG")
#' reverse_complement("ATGCTAG", output_mode = "reverse_only")
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
        bad_arg("output_mode", list(output_mode = output_mode), "must be a single value (either 'DNA', 'RNA', or 'reverse_only')", class = "argument_length")
    }

    chars <- list(sequence = sequence, output_mode = output_mode)
    for (argument in names(chars)) {
        if (!is.character(chars[[argument]])) {bad_arg(argument, chars, "must be a character/string value.")}
    }
    ## ---------------------------------------------------------------------


    if (nchar(sequence) == 0) {
        return("")
    }

    sequence_vector <- strsplit(toupper(sequence), split = "")[[1]]
    reversed_vector <- rev(sequence_vector)

    ## Reverse vector without complementing if so desired
    if (tolower(output_mode) == "reverse_only") {
        return(paste(reversed_vector, collapse = ""))
    }

    ## Otherwise complement the reversed vector
    reversed_vector <- sapply(reversed_vector, function(base) {
        switch(
            base,
            "A" = {
                switch(
                    toupper(output_mode),
                    "DNA" = "T",
                    "RNA" = "U",
                    bad_arg("output_mode", list(output_mode = output_mode), "must be 'DNA' (default), 'RNA', or 'reverse_only'.")
                )
            },
            "C" = "G",
            "G" = "C",
            "T" = "A",
            "U" = "A",
            abort(paste0("Cannot reverse sequence for non-A/C/G/T/U.\nNon-compliant character: ", base), class = "argument_value_or_type")
        )
    })
    return(paste(reversed_vector, collapse = ""))
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

    numerical_vector <- vector("numeric", length = length)
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
    for (i in seq_along(sequences)) {
        numeric_sequence_representation <- convert_sequence_to_numbers(sequences[i], max_length)
        image_matrix[i, ] <- numeric_sequence_representation
    }

    image_data <- rasterise_matrix(image_matrix)
    return(image_data)
}



#' Convert vector of sequences to character matrix (generic `ggDNAvis` helper)
#'
#' @description
#' This function takes a vector of sequences (e.g. input to [visualise_many_sequences()]
#' or [visualise_methylation()], or vector split from input to [visualise_single_sequence()]).
#' It converts it into a matrix e.g. `c("GGCGGC", "", "ACGT", "")` would become:
#' \preformatted{G  G  C  G  G  C
#' NA NA NA NA NA NA
#' A  C  G  T  NA NA
#' NA NA NA NA NA NA
#' }
#'
#' The resulting matrix can then be rasterised into a coordinate-value dataframe via [rasterise_matrix()].
#'
#' @param sequences `character vector`. The sequences to transform into a matrix
#' @param line_length `integer`. The width of the matrix. Set to `NA` (default) to automatically use the length of the longest sequence in `sequences`.
#' @param blank_value `value`. The value that should be used to fill in blank/missing points of the matrix.
#'
#' @return `matrix`. A matrix of the sequences with one line per sequence, ready for rasterisation via [rasterise_matrix()].
#' @export
#'
#' @examples
#' convert_sequences_to_matrix(
#'     sequences = c("GGCGGC", "", "ACGT", "")
#' )
#'
#' convert_sequences_to_matrix(
#'     sequences = c("GGCGGC", "", "ACGT", ""),
#'     line_length = 10,
#'     blank_value = "X"
#' )
#'
convert_sequences_to_matrix <- function(
    sequences,
    line_length = NA,
    blank_value = NA
) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_null_or_na <- list(sequences = sequences)
    for (argument in names(not_null_or_na)) {
        if (any(is.null(not_null_or_na[[argument]])) || any(is.na(not_null_or_na[[argument]]))) {bad_arg(argument, not_null_or_na, "must not be NULL or NA.")}
    }
    not_null_or_na <- NULL

    if (any(is.na(line_length)) || any(is.null(line_length))) {
        line_length <- max(nchar(sequences))
    }

    length_1 <- list(line_length = line_length, blank_value = blank_value)
    for (argument in names(length_1)) {
        if (length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }
    length_1 <- NULL

    pos_int <- list(line_length = line_length)
    for (argument in names(pos_int)) {
        if (!is.numeric(pos_int[[argument]]) || any(pos_int[[argument]] %% 1 != 0) || any(pos_int[[argument]] < 1)) {bad_arg(argument, pos_int, "must be a positive integer.")}
    }
    pos_int <- NULL

    char <- list(sequences = sequences)
    for (argument in names(char)) {
        if (!is.character(char[[argument]])) {bad_arg(argument, char, "must be a character vector.")}
    }
    char <- NULL
    ## ---------------------------------------------------------------------


    split_sequences <- strsplit(sequences, split = "")
    split_sequences <- t(sapply(split_sequences, function(x) {c(x, rep(blank_value, line_length - length(x)))}))
    return(split_sequences)
}


#' Rasterise a matrix to an x/y/layer dataframe (generic `ggDNAvis` helper)
#'
#' @aliases rasterize_matrix
#'
#' @description
#' `rasterize_matrix()` is an alias for `rasterise_matrix()`.
#'
#' This function takes a matrix and rasterises it to a dataframe of x and y
#' coordinates, such that the matrix occupies the space from (0, 0) to (1, 1) and each
#' element of the matrix represents a rectangle with width 1/ncol(matrix) and height
#' 1/nrow(matrix). The "layer" column of the dataframe is simply the value of each element
#' of the matrix.
#'
#' @param image_matrix `matrix`. A matrix (or anything that can be coerced to a matrix via [base::as.matrix()]).
#' @param drop_na `logical`. A boolean specifying whether missing values should be dropped via [tidyr::drop_na()] (`TRUE`, default) or kept (`FALSE`).
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
#'
#' ## Create matrix with missing values
#' incomplete_matrix <- matrix(
#'     c(1, 2, 3, NA,
#'       5, NA, 7, 8),
#'     nrow = 2, ncol = 4, byrow = TRUE
#' )
#'
#' ## View
#' incomplete_matrix
#'
#' ## Rasterise, dropping NAs (default)
#' rasterise_matrix(incomplete_matrix, drop_na = TRUE)
#'
#' ## Rasterise, keeping NAs
#' rasterise_matrix(incomplete_matrix, drop_na = FALSE)
#'
#' @export
rasterise_matrix <- function(image_matrix, drop_na = TRUE) {
    if (any(is.na(drop_na)) || any(is.null(drop_na)) || !is.logical(drop_na) || length(drop_na) != 1) {
        bad_arg("drop_na", list(drop_na = drop_na), "must be a single logical/boolean value.")
    }

    image_matrix <- as.matrix(image_matrix)

    n <- nrow(image_matrix)
    k <- ncol(image_matrix)

    ## Instead of for-looping, make repeated vectors of i and j indices with loop "built in"
    j_vals <- rep(1:k, times = n)
    i_vals <- rep(1:n, each = k)

    ## Calculate coordinates of centre of each box
    x_vec <- (j_vals - 0.5) / k
    y_vec <- 1 - (i_vals - 0.5) / n

    ## Flatten matrix by row to get values
    value_vec <- as.vector(t(image_matrix))

    ## Collect into dataframe
    output_dataframe <- data.frame(x = x_vec, y = y_vec, value = value_vec)

    ## Drop NA rows if desired
    if (drop_na) {output_dataframe <- drop_na(output_dataframe)}

    ## Return
    return(output_dataframe)
}


#' Process index annotations and rasterise to a x/y/layer dataframe (generic `ggDNAvis` helper)
#'
#' @aliases visualize_index_annotations
#'
#' @description
#' `rasterize_index_annotations()` is an alias for `rasterise_index_annotations()`.
#'
#' This function is called by
#' [visualise_many_sequences()], [visualise_methylation()], and [visualise_single_sequence()]
#' to create the x/y position data for placing the index annotations on the graph.
#' Its arguments are either intermediate variables produced by the visualisation functions,
#' or arguments of the visualisation functions directly passed through.\cr\cr
#' Returns a dataframe with `x_position`, `y_position`, and `value` columns, where the
#' values are the index annotations.
#'
#' @param new_sequences_vector `vector`. The output of [insert_at_indices()] when used with identical arguments. Should be `original_sequences_vector` with some additional blank lines inserted.
#' @param original_sequences_vector `vector`. The vector of sequences used for plotting, that was originally given to [visualise_many_sequences()]/[visualise_methylation()] or split from the input sequence to [visualise_single_sequence()]. Must also have been used as input to [insert_at_indices()] to create `new_sequences_vector`.
#' @param sum_indices `logical`. Whether indices should be counted separately along each line (`FALSE`, default) or summed along all annotated lines (`TRUE`). May behave unexpectedly if `TRUE` when `annotate_full_lines` is also `TRUE`.
#' @param spacing `integer`. The number of blank lines inserted for each index annotation. Set to `NA` (default) to infer from `annotation_vertical_position`.
#' @param offset_start `integer`. The number of blank lines not present at the start, that otherwise would be expected based on `spacing` or `annotation_vertical_position`. Defaults to `0`.
#'
#' @inheritParams visualise_methylation
#'
#' @return `dataframe`. A dataframe with columns `x`, `y`, and `value`, with one observation per annotation number that needs to be drawn onto the ggplot.
#'
#' @examples
#' ## Set up arguments (e.g. from visualise_many_sequences() call)
#' sequences_data <- example_many_sequences
#' index_annotation_lines <- c(1, 23, 37)
#' index_annotation_interval <- 10
#' index_annotations_above <- TRUE
#' index_annotation_full_line <- FALSE
#' index_annotation_vertical_position <- 1/3
#'
#'
#' ## Create sequences vector
#' sequences <- extract_and_sort_sequences(
#'     example_many_sequences,
#'     grouping_levels = c("family" = 8, "individual" = 2)
#' )
#' sequences
#'
#' ## Insert blank rows as needed
#' new_sequences <- insert_at_indices(
#'     sequences,
#'     insertion_indices = index_annotation_lines,
#'     insert_before = index_annotations_above,
#'     insert = "",
#'     vert = index_annotation_vertical_position
#' )
#' new_sequences
#'
#' ## Create annnotation dataframe
#' rasterise_index_annotations(
#'     new_sequences_vector = new_sequences,
#'     original_sequences_vector = sequences,
#'     index_annotation_lines = index_annotation_lines,
#'     index_annotation_interval = 10,
#'     index_annotation_full_line = index_annotation_full_line,
#'     index_annotations_above = index_annotations_above,
#'     index_annotation_vertical_position = index_annotation_vertical_position,
#'     index_annotation_always_first_base = TRUE,
#'     index_annotation_always_last_base = TRUE,
#'     sum_indices = FALSE,
#'     spacing = NA, ## infer from vertical position
#'     offset_start = 0
#' )
#'
#'
#' @export
rasterise_index_annotations <- function(
    new_sequences_vector,
    original_sequences_vector,
    index_annotation_lines,
    index_annotation_interval = 15,
    index_annotation_full_line = TRUE,
    index_annotations_above = TRUE,
    index_annotation_vertical_position = 1/3,
    index_annotation_always_first_base = TRUE,
    index_annotation_always_last_base = TRUE,
    sum_indices = FALSE,
    spacing = NA,
    offset_start = 0
) {
    ## Validate arguments
    ## ---------------------------------------------------------------------
    not_na <- list(new_sequences_vector = new_sequences_vector, original_sequences_vector = original_sequences_vector, index_annotation_lines = index_annotation_lines, index_annotation_interval = index_annotation_interval, index_annotation_full_line = index_annotation_full_line, index_annotation_always_first_base = index_annotation_always_first_base, index_annotation_always_last_base = index_annotation_always_last_base, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, sum_indices = sum_indices, offset_start = offset_start)
    for (argument in names(not_na)) {
        if (any(is.na(not_na[[argument]]))) {bad_arg(argument, not_na, "must not be NA.")}
    }
    not_na <- NULL

    not_null <- list(new_sequences_vector = new_sequences_vector, original_sequences_vector = original_sequences_vector, index_annotation_lines = index_annotation_lines, index_annotation_interval = index_annotation_interval, index_annotation_always_first_base = index_annotation_always_first_base, index_annotation_always_last_base = index_annotation_always_last_base, index_annotation_full_line = index_annotation_full_line, index_annotations_above = index_annotations_above, index_annotation_vertical_position = index_annotation_vertical_position, spacing = spacing, sum_indices = sum_indices, offset_start = offset_start)
    for (argument in names(not_null)) {
        if (any(is.null(not_null[[argument]]))) {bad_arg(argument, not_null, "must not be NULL.")}
    }
    not_null <- NULL

    vectors <- list(new_sequences_vector = new_sequences_vector, original_sequences_vector = original_sequences_vector)
    for (argument in names(vectors)) {
        if (is.vector(vectors[[argument]]) == FALSE) {bad_arg(argument, vectors, "must be a vector.")}
    }
    vectors <- NULL

    length_1 <- list(index_annotation_interval = index_annotation_interval, index_annotation_full_line = index_annotation_full_line, index_annotations_above = index_annotations_above, index_annotation_always_first_base = index_annotation_always_first_base, index_annotation_always_last_base = index_annotation_always_last_base, index_annotation_vertical_position = index_annotation_vertical_position, spacing = spacing, sum_indices = sum_indices, offset_start = offset_start)
    for (argument in names(length_1)) {
        if (length(length_1[[argument]]) != 1) {bad_arg(argument, length_1, "must have length 1.")}
    }
    length_1 <- NULL

    non_neg_numeric <- list(index_annotation_lines = index_annotation_lines, index_annotation_interval = index_annotation_interval, index_annotation_vertical_position = index_annotation_vertical_position, offset_start = offset_start)
    for (argument in names(non_neg_numeric)) {
        if (is.numeric(non_neg_numeric[[argument]]) == FALSE || any(non_neg_numeric[[argument]] < 0)) {bad_arg(argument, non_neg_numeric, "must be numeric and non-negative.")}
    }
    non_neg_numeric <- NULL

    ## If spacing if NA or NULL, infer from vertical position
    if (is.na(spacing)) {
        spacing <- ceiling(index_annotation_vertical_position)
    }

    integers <- list(index_annotation_lines = index_annotation_lines, index_annotation_interval = index_annotation_interval, spacing = spacing, offset_start = offset_start)
    for (argument in names(integers)) {
        if (!is.numeric(integers[[argument]]) || any(integers[[argument]] %% 1 != 0)) {bad_arg(argument, integers, "must be integer only.")}
    }
    integers <- NULL

    non_neg <- list(spacing = spacing)
    for (argument in names(non_neg)) {
        if (any(non_neg[[argument]] < 0)) {bad_arg(argument, non_neg, "must be non-negative only.")}
    }
    non_neg <- NULL

    positive <- list(index_annotation_lines = index_annotation_lines)
    for (argument in names(positive)) {
        if (any(positive[[argument]] <= 0)) {bad_arg(argument, positive, "must be positive only.")}
    }
    positive <- NULL

    bools <- list(index_annotation_full_line = index_annotation_full_line, index_annotations_above = index_annotations_above, index_annotation_always_first_base = index_annotation_always_first_base, index_annotation_always_last_base = index_annotation_always_last_base, sum_indices = sum_indices)
    for (argument in names(bools)) {
        if (is.logical(bools[[argument]]) == FALSE) {bad_arg(argument, bools, "must be logical/boolean.")}
    }
    bools <- NULL

    ## Instantly return empty dataframe if interval or indices is blank
    if (index_annotation_interval == 0 || length(index_annotation_lines) == 0) {
        return(data.frame("x" = numeric(), "y" = numeric(), "value" = character()))
    }

    ## Check sorting and uniqueness
    if (any(sort(index_annotation_lines, na.last = TRUE) != index_annotation_lines)) {
        bad_arg("index_annotation_lines", list(index_annotation_lines = index_annotation_lines), "must be sorted.")
    }
    if (length(unique(index_annotation_lines)) != length(index_annotation_lines)) {
        bad_arg("index_annotation_lines", list(index_annotation_lines = index_annotation_lines), "must be unique.")
    }

    ## Warn about unexpected combination
    if (index_annotation_full_line && sum_indices) {
        warn("Unexpected behaviour (e.g. incorrect counts) might arise from annotating full lines *and* using a cumulative-sum index.", class = "parameter_recommendation")
    }
    ## ---------------------------------------------------------------------




    ## Calculate indices of the sequences we are annotating
    ## e.g. if sequences 1, 2, and 4 were annotated, they are now at positions:
    ## - 2, 4, and 7 if insertions went before
    ## - 1, 3, and 6 if insertions went after
    ## (assuming each insertion is only one line - seq_along term is scaled if needed)
    annotated_sequence_indices <- index_annotation_lines + seq_along(index_annotation_lines)*spacing - as.numeric(!index_annotations_above)*spacing - offset_start

    ## Remove out-of-range indices
    ## As original indices to annotate are sorted, positive, and unique, this will exclusively remove out-of-range indices
    if (length(annotated_sequence_indices) > length(original_sequences_vector)) {
        annotated_sequence_indices <- annotated_sequence_indices[seq_along(original_sequences_vector)]
    }

    ## Calculate scaling factors
    n <- length(new_sequences_vector)
    k <- max(nchar(new_sequences_vector))

    ## Create lists of i and j indices for all annotated bases
    ## Equivalent to for (i in 1:length(annotated_sequence_indices)) {for (j in 1:line_length)}
    ## where line_length is either the length of each sequence, or the length (k) of the longest sequence
    length_per_line <- nchar(new_sequences_vector[annotated_sequence_indices])
    if (index_annotation_full_line) {
        ## Can't annotate if interval is greater than max line length
        if (k < index_annotation_interval) {
            j_vals_each_line <- integer(0)
        } else {
            j_vals_each_line <- seq(index_annotation_interval, k, index_annotation_interval)
        }

        ## If we are overriding to always annotate the first base, add 1 to the start of the selected lines
        ## If we are overriding to always annotate the last, add k (the line length) to the end of the selected lines
        if (index_annotation_always_first_base) {
            j_vals_each_line <- c(1, j_vals_each_line)
        }
        if (index_annotation_always_last_base) {
            j_vals_each_line <- c(j_vals_each_line, k)
        }

        annotations_per_line <- length(j_vals_each_line)
        j_vals <- rep(j_vals_each_line, times = length(annotated_sequence_indices))
        i_vals <- rep(annotated_sequence_indices, each = annotations_per_line)

    } else {
        annotations_per_line <- length_per_line %/% index_annotation_interval
        if (index_annotation_always_first_base) {
            annotations_per_line[length_per_line > 0] <- annotations_per_line[length_per_line > 0] + 1
        }
        if (index_annotation_always_last_base) {
            annotations_per_line[length_per_line > 0] <- annotations_per_line[length_per_line > 0] + 1
        }

        j_vals <- unlist(lapply(length_per_line, function(l) {
            ## Essentially same logic as before but with per-line length rather than global max line length
            if (l == 0) {
                ## Lines with length 0 always have nothing annotated
                return(integer(0))
            } else {
                ## Same logic as above
                if (l < index_annotation_interval) {
                    j_vals_this_line <- integer(0)
                } else {
                    j_vals_this_line <- seq(index_annotation_interval, l, index_annotation_interval)
                }

                ## Add the extra j values if needed
                if (index_annotation_always_first_base) {
                    j_vals_this_line <- c(1, j_vals_this_line)
                }
                if (index_annotation_always_last_base) {
                    j_vals_this_line <- c(j_vals_this_line, l)
                }

                return(j_vals_this_line)
            }
        }))
        i_vals <- rep(annotated_sequence_indices, times = annotations_per_line)
    }

    ## Calculate x and y positions based on the indices and the box sizes
    x_vec <- (j_vals - 0.5) / k
    if (index_annotations_above) {
        y_vec <- 1 - (i_vals - 1 - index_annotation_vertical_position) / n
    } else {
        y_vec <- 1 - (i_vals + index_annotation_vertical_position) / n
    }

    ## Determine annotations (index along line, or index along line + previous sum)
    if (sum_indices) {
        ## Warn about unexpected combination
        if (index_annotation_full_line) {
            warn("Unexpected behaviour (e.g. incorrect counts) might arise from annotating full lines *and* using a cumulative-sum index.", class = "parameter_recommendation")
        }

        ## Current behaviour is to sum indices only along annotated sequences
        ## Maybe in future I could add an option for summing along all sequences, but why would anyone want this?
        prior_line_sums <- c(0, head(cumsum(length_per_line), -1))
        annotations <- j_vals + rep(prior_line_sums, annotations_per_line)
    } else {
        annotations <- j_vals
    }

    ## Create and return dataframe
    ## Has to be unique otherwise there could be duplicates from adding first/last bases if they would be annotated anyway
    annotation_data <- data.frame("x" = x_vec, "y" = y_vec, "value" = as.character(annotations))
    return(unique(annotation_data))
}


## Define alias
#' @rdname rasterise_matrix
#' @usage NULL
#' @export
rasterize_matrix <- rasterise_matrix

#' @rdname rasterise_index_annotations
#' @usage NULL
#' @export
rasterize_index_annotations <- rasterise_index_annotations
