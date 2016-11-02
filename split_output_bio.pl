#!/usr/bin/perl

###########################
# bp_simpleSplitBlast.pl
# 
# Simple script demonstrating spliting a multi query BLAST report
# into individual query reports using the Bioperl SearchIO module.
###########################

# Standard pragmas.

use strict;
use warnings;


# The SearchIO module is used for both reading and writing the BLAST report files.
# The Writer::TextResultWriter is used by the output SearchIO object to format the output
# before writing.

use Bio::SearchIO;
use Bio::SearchIO::Writer::TextResultWriter;


# Input BLAST report filename is passed as the only argument on the command line.

my $fileName = $ARGV[0];


# Instantiate a SearchIO object to read the input file.
# The arguments are the file format and filename.

my $blastReport = new Bio::SearchIO(-format => 'blast',
                                     -file => $fileName);


# Instantiate a Writer object which will be used to format the output stream.
# This object will be reused by each output writer.

my $reportWriter = Bio::SearchIO::Writer::TextResultWriter->new();


# Parse the input BLAST report one result object at a time.
# The Bio::Search::Result::ResultI object exactly corresponds to one query,
# which is the desired output.
# For each result the query name is read to create unique file names.
# A new SearchIO object is instantiated for each output,
# passing the Writer object and file name.

while (my $blastResult = $blastReport->next_result) {
	my $qid = $blastResult->query_name;
	my $reportFile = "${qid}.bls";
	my $reportOutput = Bio::SearchIO->new(-writer => $reportWriter,
                                             -file => ">$reportFile");
	$reportOutput->write_result($blastResult);
}