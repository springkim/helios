#!/usr/bin/perl
use strict;
use warnings;
use DBI;
my $con = DBI->connect( "dbi:Pg:dbname=postgres", "postgres", "kb6331" );

#$con->do("delete FROM userinfo_emblem");
#$con->do("delete FROM emblem");


my $state = $con->prepare("SELECT eb_name FROM emblem");
$state->execute();
my @arr;
while(my @row = $state->fetchrow_array){
	foreach my $i (@row) {
		push @arr,$i;	
	}	
}
$state->finish();


opendir( DIR, "../image/emblem" ) || die print $!;
my @files = readdir(DIR);
foreach my $elem ( 0 .. $#files ) {
	if ( $files[$elem] ne '.' and $files[$elem] ne '..' ) {
		my $eb_path = "image/emblem/" . $files[$elem];
		$files[$elem] =~ /([a-z]+)./g;
		my $eb_name = $1;
		if(!grep{$_ eq $eb_name}@arr){
			my $query   = "INSERT INTO emblem VALUES(\'$eb_name\',\'$eb_path\')";
			$con->do($query);
		}
	}
}

$con->disconnect();
