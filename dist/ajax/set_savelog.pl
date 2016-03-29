#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
require '../../login/info.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $id=$q->param('id');
my $bool=$q->param('TF');
my $state=$con->prepare("SELECT count(ui_id) FROM userinfo WHERE ui_id=\'$id\'");
$state->execute;
my @row=$state->fetchrow_array;
if($row[0]!=0){
	$con->do("UPDATE userinfo SET ui_savelog=$bool WHERE ui_id=\'$id\'");
}

print $q->header(-charset=>"UTF-8");

$con->disconnect();