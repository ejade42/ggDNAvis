# Vector of the quality scores used by the FASTQ format

A vector of the characters used to indicate quality scores from 0 to 40
in the FASTQ format. These scores are related to the error probability
\\p\\ via \\Q = -10 \text{ log}\_{10}(p)\\, so a Q-score of 10
(represented by `"+"`) means the error probability is 0.1, a Q-score of
20 (`"5"`) means the error probability is 0.01, and a Q-score of 30
(`"?"`) means the error probability is 0.001.  
  
The character representations store Q-scores in one byte each by using
ASCII encodings, where the Q-score for a character is its ASCII code
minus 33 (e.g. `A` has an ASCII code of 65 and represents a Q-score of
32).  
  
This vector contains the characters in order but starting with a score
of 0, meaning the character at index \\n\\ represents a Q-score of
\\n-1\\ e.g. the first character (`"!"`) represents a score of 0; the
eleventh character (`"+"`) represents a score of 10.  
  
The full set of possible score representations, in order and presented
as a single string, is `!"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHI`.  
  
Generation code is available at `data-raw/fastq_quality_scores.R`

## Usage

``` r
fastq_quality_scores
```

## Format

### `fastq_quality_scores`

A character vector of length 41

- fastq_quality_scores:

  The vector
  `c("!", '"', "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I")`
