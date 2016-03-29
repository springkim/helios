#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
require 'login/info.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );

#my $query="INSERT INTO userinfo VALUES('kimbom','1234','kimbom','yonsei','01026622666','springnode',3,'0','0','0','hello','dark',TRUE,TRUE,123)";
my $query="INSERT INTO userlog VALUES('kimbom','2016-3-28','128.169.0.1','Safari 64.0')";
$con->do($query);
$con->disconnect;
