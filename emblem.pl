#!/usr/bin/perl
#
#	@Project : Helios
#	@Architecture : KimBom
#	emblem.pl
#
#	@Created by On 2016. 01. 21...
#	@Copyright (C) 2016 KimBom. All rights reserved.
#
use DBI;
require 'css_helper.pl';
require 'login/info.pl';

# @name PrintEmblemBox
# @param1 : emblem name array
sub PrintEmblemBox($) {
	my @emblem_image = @{ $_[0] };
	my $dot_emblem =
	  PrintBigDot( "0", "0", "0", "70" ) . PrintSmallDot( "0", "0", "0", "70" );
	my $ret    = "";
	my $string =
	 '<div class= "user_state_3" id="STATE3_IIIII" "style=display:XXXXX">
         		<div class= "user_state_3_1">
         			DDDDD
         			YYYYY
         		</div>
         		<div class= "user_state_3_2">
         			DDDDD
         			YYYYY
         		</div>
         		<div class= "user_state_3_3">
         			DDDDD
         			YYYYY
         		</div>
         		<div class= "user_state_3_4">
         			DDDDD
         			YYYYY
         		</div>
         		<div class= "user_state_3_5">
         			DDDDD
         			YYYYY
         		</div>
         		<div class= "user_state_3_6">
         			DDDDD
         			YYYYY
         		</div>
         		<div class= "user_state_3_7">
         			DDDDD
         			YYYYY
         		</div>
         		<div class= "user_state_3_8">
         			DDDDD
         			YYYYY
         		</div>
         		<div class= "user_state_3_9">
         			DDDDD
         			YYYYY
         		</div>
         	</div>';
	my $block = $string;
	$block =~ s/XXXXX/block/g;
	for ( my $i = 0 ; $i <= $#emblem_image && $i < 9 ; $i++ ) {
		my $tmp =
		  "<img src=\"$emblem_image[$i]\" style=\"display:block\" id=\"EMBLEM_$i\" width=\"70px\" height=\"70px\">";
		$block =~ s/YYYYY/$tmp/;
	}
	$block =~ s/YYYYY//g;
	$ret = $ret . $block;

	#this is hidden block
	for ( my $i = 9 ; $i <= $#emblem_image ; $i++ ) {
		$block = $string;
		$block =~ s/XXXXX/none/g;
		for ( my $j = $i + 9 ; $i < $j && $i <= $#emblem_image ; $i++ ) {
			my $tmp =
			  "<img src=\"$emblem_image[$i]\" style=\"display:none\" id=\"EMBLEM_$i\" width=\"70px\" height=\"70px\">";
			$block =~ s/YYYYY/$tmp/;
		}
		$block =~ s/YYYYY//g;

		$ret = $ret . $block;
	}
	$ret =~ s/DDDDD/$dot_emblem/g;
	for(my $i=0;$i<=$#emblem_image;$i+=9){
		my $j=$i/9;
		$ret =~ s/IIIII/$j/;
	}
	my $sz=$#emblem_image+1;
	$ret=$ret."<input type=\"hidden\" id=\"EMBLEM_SZ\" value=\"$sz\"/>";
	$ret=$ret."<input type=\"hidden\" id=\"EMBLEM_INDEX\" value=\"0\"/>";
	return $ret;
}

1;
