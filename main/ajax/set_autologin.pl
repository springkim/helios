#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
require '../../login/info.pl';
require '../../login/aes.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $id=$q->param('id');
my $bool=$q->param('TF');
my $state=$con->prepare("SELECT count(ui_id) FROM userinfo WHERE ui_id=\'$id\'");
$state->execute;
my @row=$state->fetchrow_array;
if($row[0]!=0){
	$con->do("UPDATE userinfo SET ui_autologin=$bool WHERE ui_id=\'$id\'");
}


my $enc_name=AES_Encrypt("bluecandle_helios_cookie_id");
chop($enc_name);
chop($enc_name);
chop($enc_name);
my $enc_id=AES_Encrypt($id);
if($bool eq '1'){
	my $c=$q->cookie(-name=>$enc_name,-value=>$enc_id,-expires=>'+1440M');
	print $q->header(-charset=>"UTF-8",-cookie=>$c);
}else{
	print $q->header(-charset=>"UTF-8");
}
$con->disconnect();