#!/usr/bin/perl

open(File,"blast_output");
my @data = <File>;
close File;

my @querylines = ();
for (my $i=0; $i<@data; $i++) {
    my $line = $data[$i];
    if ($line =~ m/Query=/g) {
        push(@querylines,$i);
    }
}

my @queries = ();
for (my $j=1; $j<@querylines; $j++) {
    my $endline = $querylines[$j];
    $endline--;
    my $startline = $querylines[$j-1];
    my @result = ();
    for (my $k=$startline; $k<=$endline; $k++) {
        push(@result,$data[$k]);
    }
    push(@queries,[@result]);
}

my $numqueries = scalar(@queries);
for (my $m=0; $m<$numqueries; $m++) {
    my $firstline = $queries[$m][0];
    my @linearray = split(' ',$firstline);
    my $name = $linearray[1];
    my @array = @{$queries[$m]};
    open(OUT,">$name.txt");
    foreach my $line (@array) {
        print OUT $line;
    }   
    close OUT;    
}