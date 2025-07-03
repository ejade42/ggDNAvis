fastq_quality_scores <- strsplit("!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI", "")[[1]]
usethis::use_data(fastq_quality_scores, overwrite = TRUE)
