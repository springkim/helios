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
sub GetFooterHtml(){
	my $str='
	<div class="footer">
		<div class="footer_main">
			<div class="footer_content">
				<h1>Blue Candle Online Judge</h1>
				<a href="main.pl"><p>소개</p></a>
				<a href="main.pl"><p>도움말</p></a>
				<a href="main.pl"><p>블로그</p></a>
				<a href="main.pl"><p>Q&A</p></a>
			</div>
			<div class="footer_content">
				<h1>Problem</h1>
				<a href="main.pl"><p>종류별 문제</p></a>
				<a href="main.pl"><p>풀리지 않은 문제</p></a>
				<a href="main.pl"><p>랜덤문제</p></a>
			</div>
			<div class="footer_content">
				<h1>Language Reference</h1>
				<a href="https://www-s.acm.illinois.edu/webmonkeys/book/c_guide/"><p>C reference</p></a>
				<a href="http://www.cplusplus.com/reference/algorithm/"><p>C++ reference</p></a>
				<a href="http://perldoc.perl.org/perlref.html"><p>perl reference</p></a>
			</div>
			<div class="footer_content">
				<h1>Useful Site</h1>
				<a href="www.google.co.kr"><p>Google</p></a>
				<a href="https://github.com/"><p>GitHub</p></a>
				<a href="https://www.youtube.com/"><p>YouTube</p></a>
				<a href="http://stackoverflow.com/"><p>StackOverflow</p></a>
			</div>
			
		</div>
		<div class="footer_footer">
				<p>© 2016 Blue Candle, Inc.</p>
		</div>
	</div>';		
	return $str;
}
1;