# Package index

## DNA visualisation

### Alias information

Information on how function and argument aliases are implemented in
ggDNAvis

- [`ggDNAvis_aliases`](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md)
  [`aliases`](https://ejade42.github.io/ggDNAvis/reference/ggDNAvis_aliases.md)
  :

  `ggDNAvis` aliases

### Main visualisation functions

Main functions for visualising DNA/RNA/methylation information

- [`visualise_single_sequence()`](https://ejade42.github.io/ggDNAvis/reference/visualise_single_sequence.md)
  : Visualise a single DNA/RNA sequence
- [`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
  : Visualise many DNA/RNA sequences
- [`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  : Visualise methylation probabilities for many DNA sequences
- [`visualise_methylation_colour_scale()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation_colour_scale.md)
  : Visualise methylation colour scalebar

### Key data processing functions

Frequently used functions for importing and processing

- [`read_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_fastq.md)
  : Read sequence and quality information from FASTQ
- [`read_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/read_modified_fastq.md)
  : Read modification information from modified FASTQ
- [`write_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_fastq.md)
  : Write sequence and quality information to FASTQ
- [`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md)
  : Write modification information stored in dataframe back to modified
  FASTQ
- [`merge_fastq_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_fastq_with_metadata.md)
  : Merge FASTQ data with metadata
- [`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
  : Merge methylation with metadata
- [`extract_and_sort_sequences()`](https://ejade42.github.io/ggDNAvis/reference/extract_and_sort_sequences.md)
  : Extract, sort, and add spacers between sequences in a dataframe
- [`extract_methylation_from_dataframe()`](https://ejade42.github.io/ggDNAvis/reference/extract_methylation_from_dataframe.md)
  : Extract methylation information from dataframe for visualisation

### Included data

Data included in ggDNAvis

- [`example_many_sequences`](https://ejade42.github.io/ggDNAvis/reference/example_many_sequences.md)
  : Example multiple sequences data
- [`sequence_colour_palettes`](https://ejade42.github.io/ggDNAvis/reference/sequence_colour_palettes.md)
  : Colour palettes for sequence visualisations
- [`fastq_quality_scores`](https://ejade42.github.io/ggDNAvis/reference/fastq_quality_scores.md)
  : Vector of the quality scores used by the FASTQ format

### Basic helpers

Small, widely used helper functions

- [`string_to_vector()`](https://ejade42.github.io/ggDNAvis/reference/string_to_vector.md)
  :

  Split a `","`-joined string back to a vector (generic `ggDNAvis`
  helper)

- [`vector_to_string()`](https://ejade42.github.io/ggDNAvis/reference/vector_to_string.md)
  :

  Join a vector into a comma-separated string (generic `ggDNAvis`
  helper)

- [`reverse_complement()`](https://ejade42.github.io/ggDNAvis/reference/reverse_complement.md)
  :

  Reverse complement a DNA/RNA sequence (generic `ggDNAvis` helper)

- [`debug_join_vector_num()`](https://ejade42.github.io/ggDNAvis/reference/debug_join_vector_num.md)
  :

  Print a numeric vector to console (`ggDNAvis` debug helper)

- [`debug_join_vector_str()`](https://ejade42.github.io/ggDNAvis/reference/debug_join_vector_str.md)
  :

  Print a character/string vector to console (`ggDNAvis` debug helper)

- [`bad_arg()`](https://ejade42.github.io/ggDNAvis/reference/bad_arg.md)
  :

  Emit an error message for an invalid function argument (generic
  `ggDNAvis` helper)

- [`resolve_alias()`](https://ejade42.github.io/ggDNAvis/reference/resolve_alias.md)
  :

  Resolve argument value when aliases are used (generic `ggDNAvis`
  helper)

### Advanced helpers

Helper functions that are mostly called by other functions; users
shouldn’t need these for normal use cases (but they could be helpful if
you need to do similar data processing steps for other workflows, so
they are available if needed)

- [`convert_base_to_number()`](https://ejade42.github.io/ggDNAvis/reference/convert_base_to_number.md)
  :

  Map a single base to the corresponding number (generic `ggDNAvis`
  helper)

- [`convert_locations_to_MM_vector()`](https://ejade42.github.io/ggDNAvis/reference/convert_locations_to_MM_vector.md)
  :

  Convert absolute index locations to MM tag
  ([`write_modified_fastq()`](https://ejade42.github.io/ggDNAvis/reference/write_modified_fastq.md)
  helper)

- [`convert_MM_vector_to_locations()`](https://ejade42.github.io/ggDNAvis/reference/convert_MM_vector_to_locations.md)
  : Convert MM tag to absolute index locations (deprecated helper)

- [`convert_modification_to_number_vector()`](https://ejade42.github.io/ggDNAvis/reference/convert_modification_to_number_vector.md)
  :

  Convert string-ified modification probabilities and locations to a
  single vector of probabilities
  ([`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  helper)

- [`convert_sequence_to_numbers()`](https://ejade42.github.io/ggDNAvis/reference/convert_sequence_to_numbers.md)
  :

  Map a sequence to a vector of numbers (generic `ggDNAvis` helper)

- [`convert_sequences_to_matrix()`](https://ejade42.github.io/ggDNAvis/reference/convert_sequences_to_matrix.md)
  :

  Convert vector of sequences to character matrix (generic `ggDNAvis`
  helper)

- [`create_image_data()`](https://ejade42.github.io/ggDNAvis/reference/create_image_data.md)
  :

  Rasterise a vector of sequences into a numerical dataframe for
  ggplotting (generic `ggDNAvis` helper)

- [`insert_at_indices()`](https://ejade42.github.io/ggDNAvis/reference/insert_at_indices.md)
  :

  Insert blank items at specified indices in a vector
  ([`visualise_many_sequences()`](https://ejade42.github.io/ggDNAvis/reference/visualise_many_sequences.md)
  helper)

- [`rasterise_index_annotations()`](https://ejade42.github.io/ggDNAvis/reference/rasterise_index_annotations.md)
  :

  Process index annotations and rasterise to a x/y/layer dataframe
  (generic `ggDNAvis` helper)

- [`rasterise_matrix()`](https://ejade42.github.io/ggDNAvis/reference/rasterise_matrix.md)
  :

  Rasterise a matrix to an x/y/layer dataframe (generic `ggDNAvis`
  helper)

- [`rasterise_probabilities()`](https://ejade42.github.io/ggDNAvis/reference/rasterise_probabilities.md)
  :

  Create dataframe of locations and rendered probabilities
  ([`visualise_methylation()`](https://ejade42.github.io/ggDNAvis/reference/visualise_methylation.md)
  helper)

- [`reverse_sequence_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_sequence_if_needed.md)
  :

  Reverse sequences if needed
  ([`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
  helper)

- [`reverse_quality_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_quality_if_needed.md)
  :

  Reverse qualities if needed
  ([`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
  helper)

- [`reverse_locations_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_locations_if_needed.md)
  :

  Reverse modification locations if needed
  ([`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
  helper)

- [`reverse_probabilities_if_needed()`](https://ejade42.github.io/ggDNAvis/reference/reverse_probabilities_if_needed.md)
  :

  Reverse modification probabilities if needed
  ([`merge_methylation_with_metadata()`](https://ejade42.github.io/ggDNAvis/reference/merge_methylation_with_metadata.md)
  helper)
