#!/usr/bin/perl
use strict;
use warnings;
use DBI;
require 'info.pl';


sub execute($) {
	my $con = DBI->connect( GetDB(), GetUserName(), GetPassword() );
	my $query = shift;
	my $state = $con->prepare($query);
	$state->execute();
	while ( my @row = $state->fetchrow_array ){
		foreach my $i (@row) {
			print $i. " ";
		}
		print "\n";
	}
	$state->finish();
	$con->disconnect;
	print "\n\n";
}


execute("SELECT * FROM userinfo");
execute("SELECT * FROM emblem");
execute("SELECT * FROM userinfo_emblem");
execute("SELECT * FROM userlog");

execute("SELECT * FROM problem");

execute("SELECT * FROM userinfo_problem");

