#!/usr/bin/perl -w

# script to construct single-linkage clusters.
# input:  file with two columns, each entry one sequence id, each line indicating a "hit",
#	entries separated by a single tab.
# output:  file with n lines where n is the number of clusters, each line starts with  
#	[CLuster xxx] and is followed by a set of sequence identifiers separated by a space.



# variable set by user --------

$hitFile = "Cucurbita_single_copy_gene_hits.txt";
#This is the name of our input file - change it to match your input file
#Assumes the input file is in the same directory as this script 

$clusterFile = "Cucurbita_genome_clusters.clList";
#This is the main output file - You can change the name

$textFileDebugging = "cluster_blast_results.log";
#This is a log file for debugging purposes - you can change the name


$clusterSummary = "Cucurbita_genome_clusters.clSumm";
#This file gives a summary of the clusters (the cluster number and the number of sequences in each cluster

# -----------------------------

$newClusterNumber = 0;

die ("Missing input file.") if (! (-e $hitFile));
open FH1, "<$hitFile";
open FH3, ">$textFileDebugging";

while (<FH1>) 
{
	chomp;
	@twoSeqIDs = split /\t/, $_;
	$seqID1 = $twoSeqIDs[0];
	$seqID2 = $twoSeqIDs[1];
  #if both are already listed, then the two clusters have to merge, taking the lower value.
	if (exists $seqHash{$seqID1} && exists $seqHash{$seqID2}) 
	{	
		if ( $seqHash{$seqID1} < $seqHash{$seqID2} ) 
		{
			$clusterNumber = $seqHash{$seqID1};
			$clusterToChange = $seqHash{$seqID2};
		}
		elsif ( $seqHash{$seqID1} > $seqHash{$seqID2} ) 
		{
			$clusterNumber = $seqHash{$seqID2};
			$clusterToChange = $seqHash{$seqID1};
		} 
		elsif ( $seqHash{$seqID1} == $seqHash{$seqID2} ) 
		{
			$clusterToChange = -1;
		}
		if ($clusterToChange >= 0) 
		{
			print FH3 "merging clusters $seqHash{$seqID1} and $seqHash{$seqID2} because of $seqID1 or $seqID2\n";
			print FH3 " $clusterNumber is replacing $clusterToChange\n";
			foreach $key (keys %seqHash) 
			{
				if ( $seqHash{$key} == $clusterToChange) 
				{
					$seqHash{$key} = $clusterNumber;
				}
			}
		}
  #if only one is listed, simply add the other by giving it a cluster value.
	} 

	elsif (exists $seqHash{$seqID1}) 
	{
		$seqHash{$seqID2} = $seqHash{$seqID1}		#find the cluster number and apply it to the other one in the pair
	} 
	elsif (exists $seqHash{$seqID2}) 
	{
		$seqHash{$seqID1} = $seqHash{$seqID2};
  # if neither is listed, start a new cluster.
	} 
	else 
	{
		print FH3 "making new cluster $newClusterNumber of $seqID1 and $seqID2\n";
		$seqHash{$seqID1} = $newClusterNumber;	 	#assign the next new cluster number to both
		$seqHash{$seqID2} = $newClusterNumber;
		++$newClusterNumber;	 	
	}
}
close FH1;

# print output ------------------------------------
open FH4, ">$clusterSummary";
open FH2, ">$clusterFile";
	foreach $ii (0..$newClusterNumber) {
		foreach $key (keys %seqHash) {
			if ($seqHash{$key} == $ii) {
				push @tempArray, $key;
				$clusterExisted = 1;
			}
		}
		if ( $clusterExisted ) {
			print FH2 "[Cluster $ii] @tempArray\n";
			$numInCluster = $#tempArray +1;
			print FH4 "$ii $numInCluster\n";
			splice @tempArray;
			$clusterExisted = 0;
		}
	 }
close FH2;
close FH3;
close FH4;
