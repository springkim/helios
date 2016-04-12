#!/usr/bin/perl
use strict;
use warnings;
sub GetDB(){
	return "dbi:Pg:dbname=postgres";
}
sub GetUserName(){
	return "postgres";
}
sub GetPassword(){
	return "kb6331";	
}
sub GetCookieName(){
	return "bluecandle_helios_cookie_id";	
}
sub GetLocalTime(){
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
	$mon+=1;
	if(length($mon)==1){
		$mon='0'.$mon;	
	}
	if(length($mday)==1){
		$mday='0'.$mday;	
	}
	if(length($hour)==1){
		$hour='0'.$hour;
	}
	if(length($min)==1){
		$min='0'.$min;
	}
	if(length($sec)==1){
		$sec='0'.$sec;
	}
	my $date= ($year+1900).".".$mon.".".($mday).". "."$hour:"."$min:"."$sec";
	return $date;
}
1;