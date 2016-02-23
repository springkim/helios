#!/usr/bin/perl
use strict;
use warnings;
use DBI;
if($<!=0){print "you must execute in sudo\n";die;}require 'info.pl';
my $con = DBI->connect( GetDB(), GetUserName(), GetPassword() );

system "./drive-linux-x64 list -n> drivelist";
open FP,"<drivelist";
$/=undef;
my $file_data=<FP>;
close FP;
system "rm drivelist";
$file_data =~ s/\n/,/g;
my @ids= $file_data =~ /([^\s]+)(?:[\s]+)(?:[^\s]+)(?:[^,]+)(?:,)/g;
my @arr= $file_data =~ /(?:[^\s]+)(?:[\s]+)([^\s]+)(?:[^,]+)(?:,)/g;
sub GetPhotoFileId($$){
	my @arr=@{$_[0]};   #file list
    my @arr2=@{$_[1]};  #id list 
	my @ret;
	for(my $i=0;$i<=$#arr;$i++){
		$arr[$i]=~ m<.+\.(\w+)?$>;
		#".jpg", ".gif", ".bmp", ".png",".jpeg");
		if($1 eq "jpg" || $1 eq "gif" || $1 eq "bmp" || $1 eq "png" || $1 eq "jpeg"){
			push @ret,$arr2[$i];	
		} 
	}	
	return @ret;
}
my @gdrive=GetPhotoFileId(\@arr,\@ids);
if(-f "temp_photo"){
    system "rm -r temp_photo";
}
mkdir "temp_photo";
system "cp drive-linux-x64 temp_photo/";
chdir "temp_photo";
for(my $i=0;$i<=$#gdrive;$i++){
    system "./drive-linux-x64 download --id $gdrive[$i]";
}
system "rm drive-linux-x64";

sub DropTable($){
	my $data=shift;
	my @table= $data=~/create table ([[:alpha:]|_|\d]*)/g;
	my $query="drop table ";
	my $in;
	for(my $i=$#table;$i>=0;$i--){
		$con->do($query.$table[$i]);
	}
}
sub DeleteUserPhoto(){
	system("rm ../../../login/photo/*");
}
sub CreateTable($){
	my $data=shift;
	my @query=$data =~/([^;]*)/g;
	my $in;
	foreach $in(@query){
		chomp($in);
		if(length $in >3){
			$con->do($in);
		}
	}
}
$/=undef;
my $data=<DATA>;
DropTable($data);
DeleteUserPhoto();
system "mv * ../../../login/photo/";
system "rm -r ../temp_photo";
CreateTable($data);$con->do("INSERT INTO userinfo VALUES('root','1e8d41d0cb997695d8029b29f2152efa1d26ad4bd1dd53c955392ccf2d3cfeec577499133925984bd199506e01b321816fa6f8460eff673e7bf31213663e8473','root','root','1234','root\@root.root','root-0-.jpg','0','d18b0d200f56ce1a549a30117a64bb3c063ea6b9c450db7f3c17d52351e4972c','pCbQOQYzj5E9UarWzd0dstcAvBwKnQRf')");
$con->do("INSERT INTO emblem VALUES('r','image/emblem/1_r.png')");
$con->do("INSERT INTO emblem VALUES('tree','image/emblem/2_tree.png')");
$con->do("INSERT INTO emblem VALUES('lisp','image/emblem/1_lisp.png')");
$con->do("INSERT INTO emblem VALUES('fortran','image/emblem/1_fortran.png')");
$con->do("INSERT INTO emblem VALUES('list','image/emblem/2_list.png')");
$con->do("INSERT INTO emblem VALUES('graph','image/emblem/2_graph.png')");
$con->do("INSERT INTO emblem VALUES('c','image/emblem/1_c.png')");
$con->do("INSERT INTO emblem VALUES('java','image/emblem/1_java.png')");
$con->do("INSERT INTO emblem VALUES('python','image/emblem/1_python.png')");
$con->do("INSERT INTO emblem VALUES('pascal','image/emblem/1_pascal.png')");
$con->do("INSERT INTO emblem VALUES('perl','image/emblem/1_perl.png')");
$con->do("INSERT INTO emblem VALUES('cpp','image/emblem/1_cpp.png')");
$con->do("INSERT INTO problem VALUES('problem/problem_list/d0001.html','링크드리스트 구현','1','datastructure','list','1','128')");
$con->do("INSERT INTO problem VALUES('problem/problem_list/e0001.html','두 숫자 더하기','1','algorithm','basic','1','128')");
$con->do("INSERT INTO problem VALUES('problem/problem_list/e0005.html','A를 찾아라!!','2','algorithm','basic','1','128')");
$con->do("INSERT INTO problem VALUES('problem/problem_list/e0004.html','홀수 짝수 판별','1','algorithm','basic','1','128')");
$con->do("INSERT INTO problem VALUES('problem/problem_list/e0002.html','숫자들의 합','1','algorithm','basic','1','128')");
$con->do("INSERT INTO problem VALUES('problem/problem_list/e0003.html','약수 구하기','1','algorithm','basic','1','128')");
$con->disconnect;
__DATA__
create table userinfo(
	ui_id varchar(512) primary key,
	ui_pw varchar(521),
	ui_name varchar(512),
	ui_guild varchar(512),
	ui_phone varchar(512),
	ui_email varchar(512),
	ui_photo varchar(512),
	ui_level int,
	ui_salt1 varchar(512),
	ui_salt2 varchar(512)
);
create table admin(
	ui_id varchar(512) references userinfo(ui_id)
);
create table superadmin(
ui_id varchar(512) references userinfo(ui_id)
);
create table emblem(
	eb_name varchar(512) primary key,
	eb_path varchar(260)
);
create table userinfo_emblem(
	eb_name varchar(512) references emblem(eb_name),
	ui_id varchar(512) references userinfo(ui_id)
);
create table problem(
	pr_path varchar(260) primary key,
	pr_title varchar(128),
	pr_level varchar(16),
	pr_group varchar(128),
	pr_subgroup varchar(128),
	pr_timelimit varchar(128),
	pr_memlimit varchar(128)
);

create table userinfo_problem(
	pr_path varchar(512) references problem(pr_path),
	ui_id varchar(512) references userinfo(ui_id),
	uip_language varchar(512),
	uip_time varchar(512),
	uip_status text,
	uip_date varchar(512),
	uip_srcpath varchar(512),
	primary key(uip_srcpath,uip_date)
);

create table userlog(
	ui_id varchar(512) references userinfo(ui_id),
	ul_date varchar(512),
	ul_ip varchar(512),
	ul_env varchar(512)
);