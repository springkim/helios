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
}
my $id='root';
my $elem='easy';

#execute("SELECT count(DISTINCT problem.pr_optnum) FROM userinfo_problem NATURAL JOIN problem WHERE pr_level=\'$elem\' and ui_id=\'$id\' and uip_status=\'accepted\'");
#execute("SELECT * FROM userinfo");
#execute("SELECT * FROM nonemail_certification");
#execute("SELECT * FROM userlog");
execute("SELECT pr_title FROM problem");
#execute("SELECT * FROM userinfo_problem");
#execute("SELECT count(DISTINCT problem.pr_optnum) FROM userinfo_problem NATURAL JOIN problem WHERE ui_id='root' AND uip_status='accepted' AND pr_level='easy'");
#execute("SELECT * FROM notice ORDER BY nt_date DESC");
#execute("SELECT * FROM language_status");

