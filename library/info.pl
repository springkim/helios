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
	my $c=$q->cookie('bluecandle_helios_cookie_id');	#cookie
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
#=============database subroutine========================
sub is_email_confirm($){
	my $id=shift;
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	my $state=$con->prepare("SELECT count(ui_id) FROM nonemail_certification WHERE ui_id=\'$id\'");
	$state->execute;
	my @row=$state->fetchrow_array;
	$state->finish;
	$con->disconnect;
	if($row[0]==1){
		return undef;	
	}
	return 1;
}
sub is_admin($){
	my $id=shift;
	my $ret=undef;
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	my $state=$con->prepare("SELECT count(ui_id) FROM admin WHERE ui_id=\'$id\'");
	$state->execute;
	my @row=$state->fetchrow_array;
	$state->finish;
	
	if($row[0]==1){
		$ret=1;
	}else{
		$state=$con->prepare("SELECT count(ui_id) FROM superadmin WHERE ui_id=\'$id\'");
		$state->execute;
		@row=$state->fetchrow_array;
		$state->finish;
		if($row[0]==1){
			$ret=2;	
		}
	}
	$con->disconnect;
	return $ret;	
	#0 normal user 
	#1 admin 
	#2 superadmin
}
#================================================================
1;