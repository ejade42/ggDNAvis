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
