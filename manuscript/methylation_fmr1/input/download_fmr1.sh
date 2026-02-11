## Fragile X affected male - NA04026 / GBXM123343
curl https://sra-pub-src-2.s3.amazonaws.com/SRR17859098/GBXM123343.tar.1 --output GBXM123343.tar
tar --extract --file=GBXM123343.tar

## Unaffected control (female) - NA12878 (HG001) / MBXM044264
curl https://sra-pub-src-1.s3.amazonaws.com/SRR17859075/MBXM044264.tar.2 --output MBXM044264.tar
tar --extract --file=MBXM044264.tar

## Reference genome
curl http://ftp.ensembl.org/pub/release-115/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz --output Homo_sapiens.GRCh38.dna.primary_assembly_250707.fa.gz
