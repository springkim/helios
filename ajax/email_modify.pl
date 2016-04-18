#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use Crypt::Salt;
require '../../login/info.pl';
require '../../login/aes.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );

my $id=$q->param('ID');
my $email=$q->param('EMAIL');
if($id ne ''){
	$con->do("UPDATE userinfo SET ui_email=\'$email\' WHERE ui_id=\'$id\'");
	my $state=$con->prepare("SELECT count(ui_id) FROM nonemail_certification WHERE ui_id=\'$id\'");
	$state->execute;
	my @row=$state->fetchrow_array;
	$state->finish;
	if($row[0]==0){
		my $salt=salt(32);
		$con->do("INSERT INTO nonemail_certification VALUES(\'$id\',\'$salt\')");
	}
	print $q->header(-charset=>"UTF-8");
}
$con->disconnect();