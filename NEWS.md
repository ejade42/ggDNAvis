# ggDNAvis 0.3.0

Changes:

* Removed raster::raster() dependency

* Added new rasterise_matrix() function to do rasterisation

* Changed convert_input_seq_to_sequence_list() behaviour:

    * Instead of additional spacing lines always being added before or after first line of sequence, there are now independent boolean settings for whether there should be spacing lines before and whether there should be spacing lines after.

Bug fixes:

* Fixed critical error with plot matching lenience on some local linux systems that resulted in tests failing

* Inserted additional padding blank lines above/below with index annotation vertical position > 1 to avoid plot dimensions breaking

Known issues remaining:

* Related to ggplot v4.0.0:

    * Pixel rendering changes means rectangles sometimes fail to render in visualise_methylation_colour_scale(), resulting in the appearance of vertical white lines. This depends on the precision and exact export size.
    
    * There is a faint line around the panel area with non-white backgrounds.

# ggDNAvis 0.2.1

* Documented that debug_join_vector functions do not return a value

* Changed some reference images to account for ggplot updating to v4.0.0

# ggDNAvis 0.2.0

* Initial CRAN submission

* Initial functionality: 

    * Visualise single DNA sequences, multiple DNA 
    sequences, and DNA modification (e.g. methylation).

    * Read and write FASTQ, including modified FASTQ 
    produced with -T MM,ML that stores modification 
    information in the header rows.

    * Intelligently merge with metadata including read
    direction, and reverse all information for reverse reads
    only to make all reads "forward" versions.
