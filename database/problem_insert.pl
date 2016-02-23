#!/usr/bin/perl
use strict;
use warnings;
use DBI;
my $con = DBI->connect( "dbi:Pg:dbname=postgres", "postgres", "kb6331" );

$con->do("delete FROM userinfo_problem");
$con->do("delete FROM problem");


my $state = $con->prepare("SELECT pr_path FROM problem");
$state->execute();
my @arr;
while(my @row = $state->fetchrow_array){
	foreach my $i (@row) {
		push @arr,$i;	
	}	
}
$state->finish();


opendir( DIR, "../problem/problem_list" ) || die print $!;
my @files = readdir(DIR);
foreach my $elem ( 0 .. $#files ) {
	if ( $files[$elem] ne '.' and $files[$elem] ne '..' ) {
		my $pr_path = "problem/problem_list/" . $files[$elem];
		if(!grep{$_ eq $pr_path}@arr){	#not in database
			open(FP,"<../$pr_path") or die $!;
			$/=undef;
			my $data=<FP>;
			$data =~ /HIDDEN:::(.*):::/;
			my @arr=split(',',$1);
			close(FP);
			my $query = "INSERT INTO problem VALUES(\'$pr_path\',\'$arr[0]\',\'$arr[1]\',\'$arr[2]\',\'$arr[3]\',\'$arr[4]\',\'$arr[5]\')";
			$con->do($query);
		}
	}
}

$con->disconnect();