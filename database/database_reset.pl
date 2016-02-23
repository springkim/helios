#!/usr/bin/perl
use strict;
use warnings;
use DBI;
require 'info.pl';
my $con=DBI->connect(GetDB(),GetUserName(),GetPassword());
#================================================================================
#					데이터베이스 생성,초기화, 사진폴더 삭제
#================================================================================
sub DropTable($){
	my $data=shift;
	my @table= $data=~/create table ([[:alpha:]|_|\d]*)/g;
	my $query="drop table ";
	my $in;
	for(my $i=$#table;$i>=0;$i--){
		$con->do($query.$table[$i]);
	}
}
sub CreateTable($){
	my $data=shift;
	my @query=$data =~/([^;]*)/g;
	my $in;
	foreach $in(@query){
		$con->do($in);
	}
}
sub DeleteUserPhoto(){
	system("rm ../login/photo/*");	
}
open(TEXT,"<table.txt") || die $!;
$/=undef;
my $data=<TEXT>;
DropTable($data);
DeleteUserPhoto();
CreateTable($data);
close(TEXT);
#================================================================================
#					엠블럼 초기화 부분.
#================================================================================
my $state = $con->prepare("SELECT eb_name FROM emblem");
$state->execute();
my @arr;
while(my @row = $state->fetchrow_array){
	foreach my $i (@row) {
		push @arr,$i;	
	}	
}
$state->finish();
opendir( DIR, "../image/emblem" ) || die print $!;
my @files = readdir(DIR);
foreach my $elem ( 0 .. $#files ) {
	if ( $files[$elem] ne '.' and $files[$elem] ne '..' ) {
		my $eb_path = "image/emblem/" . $files[$elem];
		$files[$elem] =~ /([a-z]+)./g;
		my $eb_name = $1;
		if(!grep{$_ eq $eb_name}@arr){
			my $query   = "INSERT INTO emblem VALUES(\'$eb_name\',\'$eb_path\')";
			$con->do($query);
		}
	}
}
#================================================================================
#					문제 초기화.
#================================================================================
$state = $con->prepare("SELECT pr_path FROM problem");
$state->execute();
my @garr;
while(my @row = $state->fetchrow_array){
	foreach my $i (@row) {
		push @garr,$i;	
	}	
}
$state->finish();


opendir( DIR, "../problem/problem_list" ) || die print $!;
@files = readdir(DIR);
foreach my $elem ( 0 .. $#files ) {
	if ( $files[$elem] ne '.' and $files[$elem] ne '..' ) {
		my $pr_path = "problem/problem_list/" . $files[$elem];
		if(!grep{$_ eq $pr_path}@garr){	#not in database
			open(FP,"<../$pr_path") or die $!;
			$/=undef;
			my $data=<FP>;
			$data =~ /HIDDEN:::(.*):::/;
			my @arr=split(',',$1);
			close(FP);
			my $query = "INSERT INTO problem VALUES(\'$pr_path\',\'$arr[0]\',\'$arr[1]\',\'$arr[2]\',\'$arr[3]\',\'$arr[4]\',\'$arr[5]\')";
			$con->do($query);
		}
	}
}
$con->disconnect;

