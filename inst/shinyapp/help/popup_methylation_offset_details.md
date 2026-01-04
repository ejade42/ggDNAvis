When reading from FASTQ, reads can be of either strand along the DNA (labelled
"forward" if in the desired direction e.g. the coding strand, and "reverse"
if in the non-desired direction e.g. the template strand).

There are three options for visualising reverse reads:
 * Leave them as they are
 * Reverse them, so that they are complementary to the forward reads
 * Reverse-complement them, so that they are identical to the forward reads

However, reverse-complementing presents a quandary for methylation visualisation.
Methylation is most commonly assessed at the Cs of CpG sites (CG dinucleotides),
but when these are reverse-complemented this location now corresponds to the G of the
reverse CG dinucleotide. The modification probability can then either be left in place
and illustrated over the G, or it can be offset by 1 to the new C (the original G).

Offsetting by 0 preserves the base-perfect location at which modification was assessed,
but offsetting by 1 provides consistency between forward and reverse reads. In either case,
there is exactly one modification probability per CpG site, and the offset can be thought of
as deciding whether it is always visualised at the C of the CpG or if it should be visualised
at the G of the CpG in the case of reverse-complemented reverse reads.

See the 
[offset section of the documentation](https://ejade42.github.io/ggDNAvis/dev/#id_68-think-about-the-offset)
for a more thorough explanation accompanied by a helpful visualisation image.

A text-based visualisation is as follows:
    
    ## Here the stars represent the true biochemical modifications on the reverse strand:
    ## (occurring at the Cs of CGs in the 5'-3' direction)
    ## 
    ## 
    ## 5'  GGCGGCGGCGGCGGCGGA  3'
    ## 3'  CCGCCGCCGCCGCCGCCT  5'
    ##        *  *  *  *  *

    ## If we take the complementary locations on the forward strand,
    ## the modification locations correspond to Gs rather than Cs,
    ## but are in the exact same locations:
    ## 
    ##        o  o  o  o  o      
    ## 5'  GGCGGCGGCGGCGGCGGA  3'
    ## 3'  CCGCCGCCGCCGCCGCCT  5'
    ##        *  *  *  *  *

    ## If we offset the locations by 1 on the forward strand,
    ## the modifications are always associated with the C of a CG,
    ## but the locations are moved slightly:
    ## 
    ##       o  o  o  o  o       
    ## 5'  GGCGGCGGCGGCGGCGGA  3'
    ## 3'  CCGCCGCCGCCGCCGCCT  5'
    ##        *  *  *  *  *
