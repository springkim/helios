#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use Crypt::Salt;
use Digest::SHA3 qw(sha3_512_hex);
require '../library/info.pl';
require '../library/aes.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );

my $id=$q->param('ID');
my $cpw=$q->param('CPW');
my $npw=$q->param('NPW');
my $salt1=$q->param('SALT');
open FP,'>',"test";
print FP $id,"\n",$cpw,"\n",$npw,"\n",$salt1,"\n";

print $q->header(-charset=>"UTF-8");
if($id ne '' and $cpw ne '' and $npw ne ''and  $salt1 ne ''){
	#get SALT2
	my $state=$con->prepare("SELECT ui_salt2 FROM userinfo WHERE ui_id=\'$id\'");
	$state->execute;
	my @row=$state->fetchrow_array;
	$state->finish;
	my $salt2=$row[0];
	#encrypt current password
	foreach my $i(0..777){
		$cpw=sha3_512_hex($salt2.$cpw);
	}
	print FP $cpw,"\n",$salt2,"\n";
	#compare 
	$state=$con->prepare("SELECT count(ui_id) FROM userinfo WHERE ui_id='$id' AND ui_pw='$cpw'");
	$state->execute;
	@row=$state->fetchrow_array;
	$state->finish;
	print FP "ROW : ",$row[0],"\n";
	#current password is correct!!
	if($row[0]==1){
		#create new salt
		my $nsalt2=salt(32);
		#encrype new password
		foreach my $i(0..777){
			$npw=sha3_512_hex($nsalt2.$npw);
		}
		$con->do("UPDATE userinfo SET ui_pw=\'$npw\',ui_salt1=\'$salt1\',ui_salt2=\'$nsalt2\' WHERE ui_id=\'$id\'");
		print 'success';
	}else{
		print 'fail';
	}
}
close FP;
$con->disconnect();