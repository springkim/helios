#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
require '../library/info.pl';
require '../library/aes.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );

my $id=$q->param('ID');
my $cmt=$q->param('COMMENT');
if($id ne ''){
	$con->do("UPDATE userinfo SET ui_comment=\'$cmt\' WHERE ui_id=\'$id\'");
	print $q->header(-charset=>"UTF-8");
}
$con->disconnect();