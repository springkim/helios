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
$con->do("INSERT INTO userinfo VALUES('$id',\'$pw\',\'$name\',\'$email\',\'$salt1\',\'$salt2\',\'내가 바로 관리자다.\',TRUE,0)");
$con->do("INSERT INTO nonemail_certification VALUES(\'$id\',\'$salt2\')");
$con->do("INSERT INTO superadmin VALUES(\'$id\')");

system "chmod 777 -R problem_repository";
system "chmod 700 -R database";


$con->disconnect;
