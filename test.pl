#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
require 'library/info.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );


my $id='root';
my $pw='41449ed8e25276b03b998bb5ac88797a041d6400a5b6f009255922e45af31d577c6dae98bdda3c26ae4c143c789cae9f0617f45392754db38eb349aa64c7fe02';
my $name='kimbom';
my $email='springnode@gmail.com';
my $salt1='edc8c640d14a66cde80017bf74c1c36807f3f6d41fc023224f7dd04c1344a09a';
my $salt2='vLbkj1JSTyY49QxvnBVtyafPXaRZyFiA';
$con->do("INSERT INTO userinfo VALUES('$id',\'$pw\',\'$name\',\'$email\',\'$salt1\',\'$salt2\',\'한마디! 써주세요!\',TRUE,0)");
$con->do("INSERT INTO nonemail_certification VALUES(\'$id\',\'$salt2\')");
$con->do("INSERT INTO superadmin VALUES(\'$id\')");

my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
$mon+=1;
$year+=1900;
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
my $uip_date="$year-$mon-$mday-$hour-$min-$sec";
my $h2=$hour+1;
my $uip_date2="$year-$mon-$mday-$h2-$min-$sec";

$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-15\',\'C 100;C++ 21;Perl 0;Pascal 2;PHP 47\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-16\',\'C 120;C++ 161;Perl 1;Pascal 3;PHP 47\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-17\',\'C 120;C++ 181;Perl 2;Pascal 120;PHP 80\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-18\',\'C 200;C++ 191;Perl 43;Pascal 130;PHP 90\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-19\',\'C 400;C++ 151;Perl 56;Pascal 140;PHP 120\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-20\',\'C 500;C++ 199;Perl 92;Pascal 140;PHP 240\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-21\',\'C 555;C++ 218;Perl 120;Pascal 140;PHP 480\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-22\',\'C 666;C++ 301;Perl 113;Pascal 140;PHP 500\')");

$con->do("INSERT INTO notice VALUES(default,\'$year-$mon-19\',\'시험용 공지입니다.\',\'안녕하십니까. 김봄은 코딩을 합니다.ㅠ\')");
$con->do("INSERT INTO notice VALUES(default,\'$year-$mon-20\',\'영어하세요.\',\'코딩하지말고 영어하세요 김봄씨\')");


$con->disconnect;
