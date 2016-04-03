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
	my $i;
	my $j;
	my $c=0;
	for($i=0;$i<100000;$i++){
		for($j=0;$j<100000;$j++){
			if(($i+$j)%7==0){
				$c++;
			}
		}
	}
	print $c;
	print $a+$b;
	print "\n";
}
	
