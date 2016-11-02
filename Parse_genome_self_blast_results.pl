#!usr/bin/perl

$minoverlap = 0.8;
open OUT, ">Cucurbita_single_copy_gene_hits.txt";
open FH, "<squash_genome_seqs_lengths.txt";


%length_hash = ();

while (<FH>)
	{
	if (/^(\S+)\s+(\S+)/)
		{
		$length_hash{$1}=$2;
		}
	}

open FH2, "<Cuc_self_BLASTREPORT";

%alignment_hash = ();

while (<FH2>)
	{
	if (/^(\S+\s+\S+)\s+\S+\s+(\S+)/)
		{
		$hit = $1;
		$length = $2;
			if (! exists $alignment_hash{$hit})
				{
				$alignment_hash{$hit} = $length;
				}
			else 
				{
				$alignment_hash{$hit} = $alignment_hash{$hit} + $length;
				}
			}
		}
		close FH2;
		

%temphash = ();

for $HIT(keys %alignment_hash)
{
	if ($HIT =~ m/^(\S+)\s+(\S+)$/)
	{
		$seq1 = $1;
		$seq2 = $2;
		if (! exists $temphash{"$seq2\t$seq1"})
		{
			$temphash{"$seq1\t$seq2"} = 1;
			if (($alignment_hash{$HIT} >= ($minoverlap * $length_hash{$seq1})) && ($alignment_hash{$HIT} >= ($minoverlap * $length_hash{$seq2})))
			{
				print OUT "$HIT\n";
			}
		}
	}
}
			