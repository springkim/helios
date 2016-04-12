#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
require 'login/info.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );


my $id='root2';
my $pw='1234';
my $name='kimbom';
my $email='springnode@gmail.com';
my $salt1='asdasdasdaaddsd';
$con->do("INSERT INTO userinfo VALUES(\'$id\',\'$pw\',\'$name\',\'$email\',\'$salt1\',\'salt2\',\'한마디! 써주세요!\',TRUE,0)");
$con->do("INSERT INTO nonemail_certification VALUES(\'$id\')");
$con->do("INSERT INTO userinfo_problem VALUES(\'problem/problem_list/e0001.html\',\'$id\',\'C\',\'0.00\',\'accepted\',\'4/30\',\'1\')");
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
$mon+=1;
$year+=1900;
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-15\',\'C 100;C++ 21;Perl 0;Pascal 2;PHP 47\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-16\',\'C 200;C++ 61;Perl 1;Pascal 3;PHP 47\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-17\',\'C 250;C++ 81;Perl 2;Pascal 120;PHP 80\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-18\',\'C 300;C++ 121;Perl 2;Pascal 323;PHP 90\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-19\',\'C 400;C++ 151;Perl 3;Pascal 323;PHP 120\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-20\',\'C 500;C++ 199;Perl 7;Pascal 323;PHP 240\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-21\',\'C 555;C++ 218;Perl 9;Pascal 323;PHP 480\')");
$con->do("INSERT INTO language_status VALUES(default,\'$year-$mon-22\',\'C 666;C++ 301;Perl 11;Pascal 323;PHP 500\')");

$con->do("INSERT INTO notice VALUES(default,\'$year-$mon-19\',\'헬리오스가 오픈했습니다.\',\'안녕하십니까. 헬리오스가 오픈하였습니다 ㅎㅎ 많이많이 문제를 풀어 주세요.\')");
$con->disconnect;
