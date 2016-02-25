#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use Time::Stamp 'gmstamp', 'parsegm';
use Array::Utils qw(:all);
require 'info.pl';
my $con=DBI->connect(GetDB(),GetUserName(),GetPassword());

$con->do("DELETE FROM notice_comment");
$con->do("DELETE FROM notice");



opendir(DIR,"notice") || die print $!;
my @notices=readdir(DIR);
my @delete_dir=qw/. ../;
@notices=array_minus(@notices,@delete_dir);
@notices=sort @notices;
foreach my $i(0..$#notices){
	my $title="";
	my $content="";
	my $date=gmstamp;
	$date =~ /([\d|-]+)/;
	$date=$1;
	print $date;
	$title=substr $notices[$i] ,2 , length $notices[$i];
	open FP,"<","notice/$notices[$i]";
	$/=undef;
	$content=<FP>;
	close FP;
	$con->do("INSERT INTO notice VALUES(\'$date\',\'$title\',\'$content\')");
}

print "complete\n";




