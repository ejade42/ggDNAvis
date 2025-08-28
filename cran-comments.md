## R CMD check results

0 errors | 0 warnings | 2 notes

* This is a new release.

* R CMD check gives notes for unbound variables. 
These exclusively occur within tidyverse functions
(e.g. ggplot()) when referencing variables from the
input dataframe. Checks are in place to ensure
the dataframe has all required variables.
e.g. ggplot(my_data, aes(x = height)) warns that "height"
is an unbound global, when in context it is a variable
within the my_data dataframe.

* R CMD check gives note for unused import PNG.
This is not true, as PNG is used for some of the
examples (but the check doesn't appear to check
dependencies for example code)
