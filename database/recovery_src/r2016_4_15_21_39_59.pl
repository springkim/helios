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
CreateTable($data);$con->do("INSERT INTO userinfo VALUES('root','41449ed8e25276b03b998bb5ac88797a041d6400a5b6f009255922e45af31d577c6dae98bdda3c26ae4c143c789cae9f0617f45392754db38eb349aa64c7fe02','kimbom','springnode\@gmail.com','edc8c640d14a66cde80017bf74c1c36807f3f6d41fc023224f7dd04c1344a09a','vLbkj1JSTyY49QxvnBVtyafPXaRZyFiA','한마디! 써주세요!','1','0')");
$con->do("INSERT INTO nonemail_certification VALUES('root')");
$con->do("INSERT INTO superadmin VALUES('root')");
$con->do("INSERT INTO problem VALUES('1','두 숫자 더하기2','easy','algorithm/basic','1sec','32MB','<div style="font-family: "Lucida Grande", "Segoe UI", "Apple SD Gothic Neo", "Malgun Gothic", "Lucida Sans Unicode", Helvetica, Arial, sans-serif; font-size: 0.9em; overflow-x: hidden; overflow-y: auto; margin: 0px !important; padding: 5px 20px 26px !important; background-color: rgb(255, 255, 255);font-family: "Hiragino Sans GB", "Microsoft YaHei", STHeiti, SimSun, "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "Segoe UI", AppleSDGothicNeo-Medium, "Malgun Gothic", Verdana, Tahoma, sans-serif; padding: 20px;padding: 20px; color: rgb(34, 34, 34); font-size: 15px; font-family: "Roboto Condensed", Tauri, "Hiragino Sans GB", "Microsoft YaHei", STHeiti, SimSun, "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "Segoe UI", AppleSDGothicNeo-Medium, "Malgun Gothic", Verdana, Tahoma, sans-serif; line-height: 1.6; -webkit-font-smoothing: antialiased; background: rgb(255, 255, 255);"><h2 id="두-숫자-더하기2" style="clear: both;font-size: 1.8em; font-weight: bold; margin: 1.275em 0px 0.85em;margin-top: 0px;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: rgb(230, 230, 230);"><a name="두-숫자-더하기2" href="#두-숫자-더하기2" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a>두 숫자 더하기2</h2><h4 id="==문제==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==문제==" href="#==문제==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">문제</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">두 16진수 숫자 A,B가 주어진다. A+B의 결과를 10진수로 출력하라.</p><h4 id="==입력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==입력==" href="#==입력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">입력</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">첫째 줄에 A와 B가 주어진다(0&lt;=A,B&lt;=0xFFFF)</p><h4 id="==출력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==출력==" href="#==출력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">출력</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">첫째 줄에 A+B를 10진수로 출력한다.</p><h4 id="==예제입력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==예제입력==" href="#==예제입력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">예제입력</mark></h4><pre style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); overflow: auto; padding: 0.5em;"><code data-origin="<pre><code>9 A
</code></pre>" style="border: 0px; display: block;font-family: Consolas, Inconsolata, Courier, monospace; font-weight: bold; white-space: pre; margin: 0px;border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-size: 1em; letter-spacing: -1px; font-weight: bold;">9 A
</code></pre><h4 id="==예제출력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==예제출력==" href="#==예제출력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">예제출력</mark></h4><pre style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); overflow: auto; padding: 0.5em;"><code data-origin="<pre><code>19
</code></pre>" style="border: 0px; display: block;font-family: Consolas, Inconsolata, Courier, monospace; font-weight: bold; white-space: pre; margin: 0px;border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-size: 1em; letter-spacing: -1px; font-weight: bold;">19
</code></pre><p style="margin: 1em 0px; word-wrap: break-word;"><code style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-family: Consolas, "Liberation Mono", Menlo, Courier, monospace; font-size: 85%; padding: 0.2em 0.5em; border: 1px solid rgb(239, 239, 239); background-color: rgba(0, 0, 0, 0.0196078);">문제를 만든 사람 : 김봄</code></p></div>
','acm')");
$con->do("INSERT INTO problem VALUES('2','두 숫자 더하기','easy','algorithm/basic','1sec','32MB','<div style="font-family: "Lucida Grande", "Segoe UI", "Apple SD Gothic Neo", "Malgun Gothic", "Lucida Sans Unicode", Helvetica, Arial, sans-serif; font-size: 0.9em; overflow-x: hidden; overflow-y: auto; margin: 0px !important; padding: 5px 20px 26px !important; background-color: rgb(255, 255, 255);font-family: "Hiragino Sans GB", "Microsoft YaHei", STHeiti, SimSun, "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "Segoe UI", AppleSDGothicNeo-Medium, "Malgun Gothic", Verdana, Tahoma, sans-serif; padding: 20px;padding: 20px; color: rgb(34, 34, 34); font-size: 15px; font-family: "Roboto Condensed", Tauri, "Hiragino Sans GB", "Microsoft YaHei", STHeiti, SimSun, "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "Segoe UI", AppleSDGothicNeo-Medium, "Malgun Gothic", Verdana, Tahoma, sans-serif; line-height: 1.6; -webkit-font-smoothing: antialiased; background: rgb(255, 255, 255);"><h2 id="두-숫자-더하기" style="clear: both;font-size: 1.8em; font-weight: bold; margin: 1.275em 0px 0.85em;margin-top: 0px;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: rgb(230, 230, 230);"><a name="두-숫자-더하기" href="#두-숫자-더하기" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a>두 숫자 더하기</h2><h4 id="==문제==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==문제==" href="#==문제==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">문제</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">두 숫자 A,B가 주어진다. A+B를 출력하라.</p><h4 id="==입력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==입력==" href="#==입력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">입력</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">첫째 줄에 A와 B가 주어진다 (0&lt;=A,B&lt;=2000000000)</p><h4 id="==출력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==출력==" href="#==출력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">출력</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">첫째 줄에 A+B를 출력한다.</p><h4 id="==예제입력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==예제입력==" href="#==예제입력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">예제입력</mark></h4><pre style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); overflow: auto; padding: 0.5em;"><code data-origin="<pre><code>6 7
</code></pre>" style="border: 0px; display: block;font-family: Consolas, Inconsolata, Courier, monospace; font-weight: bold; white-space: pre; margin: 0px;border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-size: 1em; letter-spacing: -1px; font-weight: bold;">6 7
</code></pre><h4 id="==예제출력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==예제출력==" href="#==예제출력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">예제출력</mark></h4><pre style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); overflow: auto; padding: 0.5em;"><code data-origin="<pre><code>13
</code></pre>" style="border: 0px; display: block;font-family: Consolas, Inconsolata, Courier, monospace; font-weight: bold; white-space: pre; margin: 0px;border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-size: 1em; letter-spacing: -1px; font-weight: bold;">13
</code></pre><p style="margin: 1em 0px; word-wrap: break-word;"><code style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-family: Consolas, "Liberation Mono", Menlo, Courier, monospace; font-size: 85%; padding: 0.2em 0.5em; border: 1px solid rgb(239, 239, 239); background-color: rgba(0, 0, 0, 0.0196078);">문제를 만든 사람 : 김봄</code></p></div>
','acm')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0','compile errorroot-2016.04.15.20:25:53.c: In function ‘main’:
root-2016.04.15.20:25:53.c:5:1: error: unknown type name ‘asd’
 asd 
 ^
root-2016.04.15.20:25:53.c:6:8: error: expected declaration specifiers or ‘...’ before string constant
  scanf("%d",&t);
        ^
root-2016.04.15.20:25:53.c:6:13: error: expected declaration specifiers or ‘...’ before ‘&’ token
  scanf("%d",&t);
             ^
root-2016.04.15.20:25:53.c:8:8: warning: ignoring return value of ‘scanf’, declared with attribute warn_unused_result [-Wunused-result]
   scanf("%d %d",&a,&b);
        ^
','2016.04.15. 20:25:53','user_source/root-2016.04.15.20:25:53.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0','compile errorroot-2016.04.15.20:28:17.c: In function ‘main’:
root-2016.04.15.20:28:17.c:5:1: error: unknown type name ‘asd’
 asd 
 ^
root-2016.04.15.20:28:17.c:6:8: error: expected declaration specifiers or ‘...’ before string constant
  scanf("%d",&t);
        ^
root-2016.04.15.20:28:17.c:6:13: error: expected declaration specifiers or ‘...’ before ‘&’ token
  scanf("%d",&t);
             ^
root-2016.04.15.20:28:17.c:8:8: warning: ignoring return value of ‘scanf’, declared with attribute warn_unused_result [-Wunused-result]
   scanf("%d %d",&a,&b);
        ^
','2016.04.15. 20:28:17','user_source/root-2016.04.15.20:28:17.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0','memory limit','2016.04.15. 20:29:06','user_source/root-2016.04.15.20:29:06.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0','compile error','2016.04.15. 20:29:26','user_source/root-2016.04.15.20:29:26.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0','compile error
root-2016.04.15.20:30:16.c: In function ‘main’:
root-2016.04.15.20:30:16.c:5:1: error: unknown type name ‘asd’
 asd 
 ^
root-2016.04.15.20:30:16.c:6:8: error: expected declaration specifiers or ‘...’ before string constant
  scanf("%d",&t);
        ^
root-2016.04.15.20:30:16.c:6:13: error: expected declaration specifiers or ‘...’ before ‘&’ token
  scanf("%d",&t);
             ^
root-2016.04.15.20:30:16.c:8:8: warning: ignoring return value of ‘scanf’, declared with attribute warn_unused_result [-Wunused-result]
   scanf("%d %d",&a,&b);
        ^
','2016.04.15. 20:30:16','user_source/root-2016.04.15.20:30:16.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0','runtime error','2016.04.15. 20:33:34','user_source/root-2016.04.15.20:33:34.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0','time limit','2016.04.15. 20:33:46','user_source/root-2016.04.15.20:33:46.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0','unable function use','2016.04.15. 20:33:57','user_source/root-2016.04.15.20:33:57.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0.001062','wrong answer','2016.04.15. 20:34:08','user_source/root-2016.04.15.20:34:08.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0.001746','accepted','2016.04.15. 20:34:21','user_source/root-2016.04.15.20:34:21.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0.001093','accepted','2016.04.15. 21:03:13','user_source/root-2016.04.15.21:03:13.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','C','0.000871','accepted','2016.04.15. 21:10:17','user_source/root-2016.04.15.21:10:17.c')");
$con->do("INSERT INTO userinfo_problem VALUES('2','root','Pascal','0','illegal language','2016.04.15. 21:38:35','user_source/root-2016.04.15.21:38:35.c')");
$con->do("INSERT INTO notice VALUES('1','2016-04-19','시험용 공지입니다.','안녕하십니까. 김봄은 코딩을 합니다.ㅠ')");
$con->do("INSERT INTO language_status VALUES('1','2016-04-15','C 100;C++ 21;Perl 0;Pascal 2;PHP 47')");
$con->do("INSERT INTO language_status VALUES('2','2016-04-16','C 120;C++ 161;Perl 1;Pascal 3;PHP 47')");
$con->do("INSERT INTO language_status VALUES('3','2016-04-17','C 120;C++ 181;Perl 2;Pascal 120;PHP 80')");
$con->do("INSERT INTO language_status VALUES('4','2016-04-18','C 200;C++ 191;Perl 43;Pascal 130;PHP 90')");
$con->do("INSERT INTO language_status VALUES('5','2016-04-19','C 400;C++ 151;Perl 56;Pascal 140;PHP 120')");
$con->do("INSERT INTO language_status VALUES('6','2016-04-20','C 500;C++ 199;Perl 92;Pascal 140;PHP 240')");
$con->do("INSERT INTO language_status VALUES('7','2016-04-21','C 555;C++ 218;Perl 120;Pascal 140;PHP 480')");
$con->do("INSERT INTO language_status VALUES('8','2016-04-22','C 666;C++ 301;Perl 113;Pascal 140;PHP 500')");
$con->disconnect;
__DATA__
create table userinfo(
	ui_id varchar(512) primary key,
	ui_pw varchar(512),
	ui_name varchar(512),
	ui_email varchar(512),
	ui_salt1 varchar(512),
	ui_salt2 varchar(512),
	ui_comment varchar(512),
	ui_savelog boolean,
	ui_visit int
);
create table nonemail_certification(
	ui_id varchar(512) references userinfo(ui_id)
);
create table admin(
	ui_id varchar(512) references userinfo(ui_id)
);
create table superadmin(
	ui_id varchar(512) references userinfo(ui_id)
);
create table friend(
	ui_id1 varchar(512) references userinfo(ui_id),
	ui_id2 varchar(512) references userinfo(ui_id)
);
create table problem(
	pr_optnum serial primary key,
	pr_title varchar(128),
	pr_level varchar(32),
	pr_group varchar(128),
	pr_timelimit varchar(128),
	pr_memlimit varchar(128),
	pr_content text,
	pr_type	varchar(128)
);
create table userinfo_problem(
	pr_optnum serial references problem(pr_optnum),
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
create table notice(
	nt_optday serial primary key,
	nt_date varchar(512),
	nt_title text,
	nt_content text
);
create table question(
	ui_id varchar(512) references userinfo(ui_id),
	qe_title text primary key,
	qe_content text,
	qe_date varchar(512),
	qe_watch boolean,
	qe_answer text
);
create table favorite(
	ui_id varchar(512) references userinfo(ui_id),
	fa_title varchar(512),
	fa_link text
);
create table userdateinfo(
	ui_id varchar(512) references userinfo(ui_id),
	udi_optday int,
	udi_visit int,
	udi_solve int,
	udi_rank int,
	primary key(ui_id,udi_optday)
);
create table language_status(
	ls_optday serial primary key,
	ls_date varchar(512),
	ls_language text
);