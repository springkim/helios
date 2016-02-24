#!/usr/bin/perl
use strict;
use warnings;

sub GetDB(){
	return "dbi:Pg:dbname=postgres";
}
sub GetID(){
	return "postgres";
}
sub GetPW(){
	return "kb6331";	
}
sub GetCookieId($){
	my $q=shift;
	my $enc_name=AES_Encrypt("bluecandle_helios_cookie_id");
	chop($enc_name);
	chop($enc_name);
	chop($enc_name);
	my $c=$q->cookie($enc_name);	#cookie
	if($c){
		$c=AES_Decrypt($c);
	}else{
		$c=undef;
	}
	return $c;
}
1;