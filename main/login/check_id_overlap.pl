#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
require '../../login/info.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $id=$q->param('ID');
print $q->header(-charset=>"UTF-8");
my $state=$con->prepare("SELECT count(ui_id) FROM userinfo WHERE ui_id=\'$id\'");
$state->execute;
my @row=$state->fetchrow_array;
print $row[0];
$con->disconnect;