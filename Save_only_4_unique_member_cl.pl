#!usr/bin/perl;

#this script goes through a list of clusters (in this case they are already
#sorted by length and reduced to the desired length of 4 members) and only
#saves clusters with four unique gene_id names

$clusterlist = "Cucurbit_Blanca_clusters_by_length.txt";
$outfile = "Unique_Clusters.txt";
open FH, "<$clusterlist";
open OUT, "<$outfile";
%badhash = ();
@gene_id_array = ();
while (<FH>)
{
	if (/(^\S+\s\S+\s(\D+)\d\S+\s(\D+)\d\S+\s(\D+)\d\S+\s(\D+)\d\S+\s(\D+)\d)\S+/)
	{
	$line = $1;
	@gene_id_array = ($2, $3, $4, $5, $6);
	for $gene_id($gene_id_array)if ([$2$3$4$5$6] = (MU|Cla|Csa)
	if ($2 eq $3 || $3 eq $4 || $4 eq $5 ||$3 eq $5 ||$2 eq $5 ||$2 eq $4)
		{
		$badhash{$line}=1; 
		}
	}
if (! exists $badhash{$line})
	{
	print OUT "$line\n";
	}
}

						
		
		#@genes = ("$2", "$3", "$4", "$5");
		#$line = $1;
		#@unique = ();
		#%seen = ();
 		#foreach $value (@genes) 
		#	{
  		#	if (! $seen{$value}++ ) 
  		#		{
    	#		push @unique, $value;
  		#		}
		#	}
		#	print OUT "@unique\n";
		
close FH;


