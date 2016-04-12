#!/usr/bin/perl
#
# @Project			: Helios
# @Architecture 		: Kim Bom
# @file 				: global_head.pl
#
# @Created by KimBom On 2016. 03. 30...
# @Copyright (C) 2016 KimBom. All rights reserved.
#
use strict;
use warnings;
require 'global_require.pl';
#================================================================================#
#	@subroutine		: print_head
#	@param1			: $q(CGI)
#	@param2			: $id(cookie id)
#	@comment 		: print html head tag
#================================================================================#
sub helios_html_head($$){
	my ($q,$id)=@_;
	my $title='Helios';	#page title
	my $theme=GetTheme($id);
	my $ret='<html lang="en">
  		<head>
    		<meta charset="utf-8">
		    <meta http-equiv="X-UA-Compatible" content="IE=edge">
		    <meta name="viewport" content="width=device-width, initial-scale=1">'.
		    "<title>$title</title>".
		    '<link rel="icon" type="image/png" href="img/favicon.png">
		    <link rel="apple-touch-icon-precomposed" href="img/apple-touch-favicon.png">
		    <link href="libs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
		    <link href="http://fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic,900,900italic" rel="stylesheet" type="text/css">
		    <link href="libs/font-awesome/css/font-awesome.min.css" rel="stylesheet">
		    <link href="libs/jquery.scrollbar/jquery.scrollbar.css" rel="stylesheet">
		    <link href="libs/ionrangeslider/css/ion.rangeSlider.css" rel="stylesheet">
		    <link href="libs/ionrangeslider/css/ion.rangeSlider.skinFlat.css" rel="stylesheet">
		     <link href="libs/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.min.css" rel="stylesheet">
		    <link href="libs/morris.js/morris.css" rel="stylesheet">
		    <link href="libs/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.min.css" rel="stylesheet">'
		    ."<link href=\"$theme\" rel=\"stylesheet\" class=\"demo__css\">".
		    '<link href="css/demo.css" rel="stylesheet"><!--[if lt IE 9]>
		    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
		    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
  		</head>';
  	return $ret;
}
'You can do it';