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

1;