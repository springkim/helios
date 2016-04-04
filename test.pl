#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
require 'login/info.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $e='springnode@gmail.com';
#my $query="INSERT INTO userinfo VALUES('kimbom2','1234','kimbom','$e','0','0','hello',TRUE,123)";
#my $query="INSERT INTO userlog VALUES('kimbom','2016-3-28','128.169.0.1','Safari 64.0')";
#$con->do($query);

my $id='root';
my $pw='1234';
my $name='kimbom';
my $email='springnode@gmail.com';
my $salt1='asdasdasdaaddsd';

$con->do("INSERT INTO userinfo VALUES(\'$id\',\'$pw\',\'$name\',\'$email\',\'$salt1\',\'salt2\',\'한마디! 써주세요!\',TRUE,0)");
$con->do("INSERT INTO nonemail_certification VALUES(\'$id\')");
$con->disconnect;
