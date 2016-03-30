#!/usr/bin/perl
#
# @Project				: Helios
# @Architecture 		: Kim Bom
# @file 				: global_require.pl
#
# @Created by KimBom On 2016. 03. 30...
# @Copyright (C) 2016 KimBom. All rights reserved.
#
use strict;
use warnings;
use CGI;
use DBI;
#================================================================================#
#	@subroutine 	: get theme 												 
#	@param1 		: user id
#	@comment 		: if id is nonexist, theme is dark(default)
#================================================================================#
sub GetTheme($){
	my $id=shift;
	my $theme='css/right.dark.css';;	#dark,lilac
	if($id){
		my $con = DBI->connect( GetDB(), GetID(), GetPW() );
		my $state=$con->prepare("SELECT ui_theme FROM userinfo WHERE ui_id=\'$id\'");
		$state->execute;
		my @row=$state->fetchrow_array;
		if($#row!=-1){
			$theme='css/right.$row[0].css';
		}
		$con->disconnect;
	}
	return $theme;
}
'Hall of fame';