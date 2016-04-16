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
		foreach my $i (0..$#row) {
			print $row[$i]," ";
		}
		print "\n";
	}
	$state->finish();
	$con->disconnect;
	print "\n";
}


execute("SELECT * FROM userinfo");
execute("SELECT * FROM nonemail_certification");
#execute("SELECT * FROM userlog");

#execute("SELECT pr_title FROM problem");

#execute("SELECT * FROM userinfo_problem");

execute("SELECT * FROM notice ORDER BY nt_date DESC");



execute("SELECT * FROM language_status");

