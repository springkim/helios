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
1;