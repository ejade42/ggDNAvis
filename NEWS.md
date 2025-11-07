# ggDNAvis (development version)

New features:

* `visualise_many_sequences()` now has index annotations! Arguments are the same as for `visualise_single_sequence()`, except with the additional `index_annotation_lines` (specifies any combination of lines to annotate, counting down from the top) and `index_annotation_full_lines` (specifies whether annotations should go up to the maximum line length, or stop for each line when that line's sequence ends) arguments. Of course, because each line is a different sequence, indices here "reset" each line rather than counting the total number of bases across lines.

* Added `bad_arg()` function to streamline error reporting. May be useful for argument validation in other packages so exported.

User-facing changes:

* Removed warning for "incorrectly" removing index annotations. Now setting any relevant argument to 0/empty (e.g. `index_annotation_size = 0`, `index_annotation_interval = 0`, `index_annotation_lines = numeric(0)`) will automatically change the "main" one to remove annotations.

Background changes:

* Added new helper functions: `insert_at_indices()` and `create_many_sequence_index_annotations()`

* Starting changing all error reporting to use `bad_arg()` rather than copy pasting.

# ggDNAvis 0.3.2

* Added files related to pkgdown website building to .Rbuildignore so they are not part of the R package anymore (this caused a CRAN rejection).

# ggDNAvis 0.3.1

Bug fixes:

* Fixed 1-pixel-wide border appearing between the panel and the margin when using non-white background colours

# ggDNAvis 0.3.0

Changes:

* Removed `raster::raster()` dependency

* Added new `rasterise_matrix()` function to do rasterisation

* Changed `convert_input_seq_to_sequence_list()` behaviour:

    * Instead of additional spacing lines always being added before or after first line of sequence, there are now independent boolean settings for whether there should be spacing lines before and whether there should be spacing lines after.

Bug fixes:

* Fixed critical error with plot matching lenience on some local linux systems that resulted in tests failing

* Inserted additional padding blank lines above/below with `index_annotation_vertical_position` > 1 to avoid plot dimensions breaking (`visualise_single_sequence()`)

Known issues remaining:

* Related to ggplot v4.0.0:

    * Pixel rendering changes means rectangles sometimes fail to render in visualise_methylation_colour_scale(), resulting in the appearance of vertical white lines. This depends on the precision and exact export size.
    
    * There is a faint line around the panel area with non-white backgrounds.

# ggDNAvis 0.2.1

* Documented that `debug_join_vector_num()` and `debug_join_vector_str()` do not return a value

* Changed some reference images to account for ggplot2 updating to v4.0.0

# ggDNAvis 0.2.0

* Initial CRAN submission

* Initial functionality: 

    * Visualise single DNA sequences, multiple DNA 
    sequences, and DNA modification (e.g. methylation): 
    `visualise_single_sequence()`,
    `visualise_many_sequences()`,
    `visualise_methylation()`

    * Read and write FASTQ, including modified FASTQ 
    produced with -T MM,ML that stores modification 
    information in the header rows:
    `read_fastq()`, `write_fastq()`,
    `read_modified_fastq()`, `write_modified_fastq()`

    * Intelligently merge with metadata including read
    direction, and reverse all information for reverse reads
    only to make all reads "forward" versions:
    `merge_fastq_with_metadata()`, `merge_methylation_with_metadata()`
