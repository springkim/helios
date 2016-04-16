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
	#	print $in,"\n";
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
#					문제 초기화.
#================================================================================
my $p_path="../main/problem_repository";
opendir DIR,$p_path;
my @dir=readdir(DIR);
foreach my $elem(@dir){	#algorithm datastducture
	if($elem ne '.' and $elem ne '..'){	
		opendir DIR2,"$p_path/$elem";
		my @dir2=readdir(DIR2);
		foreach my $elem2(@dir2){	#basic dp other...
			if($elem2 ne '.' and $elem2 ne '..'){
				opendir DIR3,"$p_path/$elem/$elem2";
				my @dir3=readdir(DIR3);
				foreach my $elem3(@dir3){	#두 숫자 더하기...
					if($elem3 ne '.' and $elem3 ne '..'and  $elem3 ne 'kimbom'){
							open FP,'<',"$p_path/$elem/$elem2/$elem3/problem";
							$/="\n";
							my $title=<FP>;chomp($title);
							my $class=<FP>;chomp($class);
							my $level=<FP>;chomp($level);
							my $tl=<FP>;chomp($tl);
							my $ml=<FP>;chomp($ml);
							my $type=<FP>;chomp($type);
							$/=undef;
							my $content=<FP>;
							$con->do("INSERT INTO problem VALUES(default,\'$title\',\'$level\',\'$class\',\'$tl\',\'$ml\',\'$content\',\'$type\')");
							close FP;
					}
				}
				closedir DIR3;
			}
		}
		closedir DIR2;	
	}
}
closedir DIR;
$con->disconnect;

