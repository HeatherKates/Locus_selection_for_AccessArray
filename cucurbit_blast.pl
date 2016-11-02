#!/usr/bin/perl

#format database 
/apps/blast/ncbi/2.2.26/bin/formatdb -i cucumber_v2.fasta -o T -p F

#run blast
/apps/blast/ncbi/2.2.26/bin/blastall -p blastn -e 1.0e-5 -m 8 -d cucumber_v2.fasta -i cucurbita_pepo_v1_unigene.fa -o blast_output
#e-value cutoff is 1.0e-5.  
#-m 8 means that the output is in tabular format



