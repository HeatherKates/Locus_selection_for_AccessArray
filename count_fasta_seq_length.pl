#!/usr/bin/perl

#this script must be run before the blast output can be processed.  The output
#from this file should be used as input for Build_seq_length_hash.pl.

open FH, "<FILE_WITH_ALL_YOUR_SEQS.fasta";
open OUT, ">OUTPUT_FILE_NAME_seqs_length.txt";


	$name = "";
	$sequence = "";
	$seqlength = "";
	while (<FH>)
	{
		if (/^\>(\S+)/)
		{
			$name = $1;
			print OUT "$name\t";
		}
		elsif (/^(\w+)/)
		{
			$sequence = $1;
			$seqlength = length ($sequence);
			print OUT "$seqlength\n";
		}
		 
	}
	

close FH;

