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
execute("SELECT * FROM userlog");

execute("SELECT * FROM problem");

execute("SELECT * FROM userinfo_problem");

execute("SELECT * FROM notice ORDER BY nt_date DESC");

execute("SELECT count(pr_path) FROM problem WHERE pr_group=\'algorithm\'");

execute("SELECT * FROM language_status");
print '=============================',"\n";
execute("SELECT count(DISTINCT pr_path) FROM userinfo_problem WHERE uip_status=\'accepted\' ");
