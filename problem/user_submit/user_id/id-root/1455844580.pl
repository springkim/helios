#!/usr/bin/perl
use strict;
use warnings;
my $t=<STDIN>;
chomp $t;
while($t--){
	my $s=<STDIN>;
	$s=~m/([0-9]+) ([0-9]+)/g;
	my $a=int $1;
	my $b=int $2;
	print $a+$b;
	print "\n";
}
	
