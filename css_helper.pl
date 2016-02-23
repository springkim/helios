#!/usr/bin/perl
use CGI;

#	@name : PrintDot
#	@comment : 
#	@param1 : xSrc
#	@param2 : ySrc
#	@param3 : width
#	@param4 : height
sub PrintBigDot($$$$){
	my $ret="";
	my $q=new CGI;
	my $xsrc=shift;
	$xsrc-=2;
	my $ysrc=shift;
	$ysrc-=2;
	my $width=shift;
	my $height=shift;
	my $Xtemp=$xsrc."px";
	my $Ytemp=$ysrc."px";
	$ret=$ret."<div class=\"dot\" style=\"left:$Xtemp;top:$Ytemp\"></div>";#dot on left-top
	$Xtemp=$xsrc+$width;
	$Xtemp=$Xtemp."px";
	$ret=$ret."<div class=\"dot\" style=\"left:$Xtemp;top:$Ytemp\"></div>";#dot on right-top
	$Ytemp=$ysrc+$height;
	$Ytemp=$Ytemp."px";
	$Xtemp=$xsrc."px";
	$ret=$ret."<div class=\"dot\" style=\"left:$Xtemp;top:$Ytemp\"></div>";	#dot on left-bottom
	$Xtemp=$xsrc+$width;
	$Xtemp=$Xtemp."px";
	$ret=$ret."<div class=\"dot\" style=\"top:$Ytemp;left:$Xtemp\"></div>";	#dot on right-bottom
	return $ret;
}
sub PrintSmallDot($$$$){
	my $ret="";
	my $q=new CGI;
	my $xsrc=shift;
	$xsrc-=1;
	my $ysrc=shift;
	$ysrc-=1;
	my $width=shift;
	my $height=shift;
	my $Xtemp=$xsrc."px";
	my $Ytemp=$ysrc."px";
	$ret=$ret."<div class=\"dotinner\" style=\"left:$Xtemp;top:$Ytemp\"></div>";#dot on left-top
	$Xtemp=$xsrc+$width;
	$Xtemp=$Xtemp."px";
	$ret=$ret."<div class=\"dotinner\" style=\"left:$Xtemp;top:$Ytemp\"></div>";#dot on right-top
	$Ytemp=$ysrc+$height;
	$Ytemp=$Ytemp."px";
	$Xtemp=$xsrc."px";
	$ret=$ret."<div class=\"dotinner\" style=\"left:$Xtemp;top:$Ytemp\"></div>";	#dot on left-bottom
	$Xtemp=$xsrc+$width;
	$Xtemp=$Xtemp."px";
	$ret=$ret."<div class=\"dotinner\" style=\"top:$Ytemp;left:$Xtemp\"></div>";	#dot on right-bottom
	return $ret;
}
1;