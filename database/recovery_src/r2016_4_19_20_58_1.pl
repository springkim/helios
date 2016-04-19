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
$con->do("INSERT INTO nonemail_certification VALUES('root','vLbkj1JSTyY49QxvnBVtyafPXaRZyFiA')");
$con->do("INSERT INTO superadmin VALUES('root')");
$con->do("INSERT INTO problem VALUES('1','정렬을 해보자','easy','algorithm/basic','1sec','32MB','<div style="font-family: "Lucida Grande", "Segoe UI", "Apple SD Gothic Neo", "Malgun Gothic", "Lucida Sans Unicode", Helvetica, Arial, sans-serif; font-size: 0.9em; overflow-x: hidden; overflow-y: auto; margin: 0px !important; padding: 5px 20px 26px !important; background-color: rgb(255, 255, 255);font-family: "Hiragino Sans GB", "Microsoft YaHei", STHeiti, SimSun, "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "Segoe UI", AppleSDGothicNeo-Medium, "Malgun Gothic", Verdana, Tahoma, sans-serif; padding: 20px;padding: 20px; color: rgb(34, 34, 34); font-size: 15px; font-family: "Roboto Condensed", Tauri, "Hiragino Sans GB", "Microsoft YaHei", STHeiti, SimSun, "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", "Segoe UI", AppleSDGothicNeo-Medium, "Malgun Gothic", Verdana, Tahoma, sans-serif; line-height: 1.6; -webkit-font-smoothing: antialiased; background: rgb(255, 255, 255);"><h2 id="정렬을-해보자" style="clear: both;font-size: 1.8em; font-weight: bold; margin: 1.275em 0px 0.85em;margin-top: 0px;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: rgb(230, 230, 230);"><a name="정렬을-해보자" href="#정렬을-해보자" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a>정렬을 해보자</h2><h3 id="==문제==" style="clear: both;font-size: 1.6em; font-weight: bold; margin: 1.125em 0px 0.75em;"><a name="==문제==" href="#==문제==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">문제</mark></h3><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">숫자를 정렬해 보자.</p><h3 id="==입력==" style="clear: both;font-size: 1.6em; font-weight: bold; margin: 1.125em 0px 0.75em;"><a name="==입력==" href="#==입력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">입력</mark></h3><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">첫째줄에 정렬할 데이터의 개수 N이 주어진다.<br style="clear: both;">두번째 줄에 정렬할 원소 N개가 공백을 기준으로 주어진다.</p><h3 id="==출력==" style="clear: both;font-size: 1.6em; font-weight: bold; margin: 1.125em 0px 0.75em;"><a name="==출력==" href="#==출력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">출력</mark></h3><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">한줄에 하나씩 정렬된 결과를 출력한다.</p><h3 id="==예제입력==" style="clear: both;font-size: 1.6em; font-weight: bold; margin: 1.125em 0px 0.75em;"><a name="==예제입력==" href="#==예제입력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">예제입력</mark></h3><pre style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); overflow: auto; padding: 0.5em;"><code data-origin="<pre><code>5
2 5 1 3 4
</code></pre>" style="border: 0px; display: block;font-family: Consolas, Inconsolata, Courier, monospace; font-weight: bold; white-space: pre; margin: 0px;border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-size: 1em; letter-spacing: -1px; font-weight: bold;">5
2 5 1 3 4
</code></pre><h3 id="==예제출력==" style="clear: both;font-size: 1.6em; font-weight: bold; margin: 1.125em 0px 0.75em;"><a name="==예제출력==" href="#==예제출력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">예제출력</mark></h3><pre style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); overflow: auto; padding: 0.5em;"><code data-origin="<pre><code>1 2 3 4 5
</code></pre>" style="border: 0px; display: block;font-family: Consolas, Inconsolata, Courier, monospace; font-weight: bold; white-space: pre; margin: 0px;border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-size: 1em; letter-spacing: -1px; font-weight: bold;">1 2 3 4 5
</code></pre><p style="margin: 1em 0px; word-wrap: break-word;"><code style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-family: Consolas, "Liberation Mono", Menlo, Courier, monospace; font-size: 85%; padding: 0.2em 0.5em; border: 1px solid rgb(239, 239, 239); background-color: rgba(0, 0, 0, 0.0196078);">문제를 만든 사람:김봄</code></p></div>
','acm')");
$con->do("INSERT INTO problem VALUES('2','개발자의 생일을 출력하시오','crazy','algorithm/basic','1sec','128MB','<div style="font-family: 'Lucida Grande', 'Segoe UI', 'Apple SD Gothic Neo', 'Malgun Gothic', 'Lucida Sans Unicode', Helvetica, Arial, sans-serif; font-size: 0.9em; overflow-x: hidden; overflow-y: auto; margin: 0px !important; padding: 5px 20px 26px !important; background-color: rgb(255, 255, 255);font-family: 'Hiragino Sans GB', 'Microsoft YaHei', STHeiti, SimSun, 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'Segoe UI', AppleSDGothicNeo-Medium, 'Malgun Gothic', Verdana, Tahoma, sans-serif; padding: 20px;padding: 20px; color: rgb(34, 34, 34); font-size: 15px; font-family: 'Roboto Condensed', Tauri, 'Hiragino Sans GB', 'Microsoft YaHei', STHeiti, SimSun, 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'Segoe UI', AppleSDGothicNeo-Medium, 'Malgun Gothic', Verdana, Tahoma, sans-serif; line-height: 1.6; -webkit-font-smoothing: antialiased; background: rgb(255, 255, 255);"><h2 id="개발자의-생일을-출력하시오" style="clear: both;font-size: 1.8em; font-weight: bold; margin: 1.275em 0px 0.85em;margin-top: 0px;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: rgb(230, 230, 230);"><a name="개발자의-생일을-출력하시오" href="#개발자의-생일을-출력하시오" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a>개발자의 생일을 출력하시오</h2><h4 id="==문제==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==문제==" href="#==문제==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">문제</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">개발자의 생일을 출력해라, 만일 생일이 4월2일 이라면<br style="clear: both;">0402를 출력한다.</p><h4 id="==입력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==입력==" href="#==입력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">입력</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">이 문제는 입력이 존재하지 않는다.</p><h4 id="==출력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==출력==" href="#==출력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">출력</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">첫째 줄에 개발자의 생일을 출력한다.</p><h4 id="==예제입력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==예제입력==" href="#==예제입력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">예제입력</mark></h4><pre style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); overflow: auto; padding: 0.5em;"><code data-origin="<pre><code>

</code></pre>" style="border: 0px; display: block;font-family: Consolas, Inconsolata, Courier, monospace; font-weight: bold; white-space: pre; margin: 0px;border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-size: 1em; letter-spacing: -1px; font-weight: bold;">

</code></pre><h4 id="==예제출력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==예제출력==" href="#==예제출력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">예제출력</mark></h4><pre style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); overflow: auto; padding: 0.5em;"><code data-origin="<pre><code>

</code></pre>" style="border: 0px; display: block;font-family: Consolas, Inconsolata, Courier, monospace; font-weight: bold; white-space: pre; margin: 0px;border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-size: 1em; letter-spacing: -1px; font-weight: bold;">

</code></pre><p style="margin: 1em 0px; word-wrap: break-word;"><code style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-family: Consolas, 'Liberation Mono', Menlo, Courier, monospace; font-size: 85%; padding: 0.2em 0.5em; border: 1px solid rgb(239, 239, 239); background-color: rgba(0, 0, 0, 0.0196078);">문제를 만든 사람 : 김봄</code></p></div>
','acm')");
$con->do("INSERT INTO problem VALUES('3','두 숫자 더하기','easy','algorithm/basic','1sec','32MB','<div style="font-family: 'Lucida Grande', 'Segoe UI', 'Apple SD Gothic Neo', 'Malgun Gothic', 'Lucida Sans Unicode', Helvetica, Arial, sans-serif; font-size: 0.9em; overflow-x: hidden; overflow-y: auto; margin: 0px !important; padding: 5px 20px 26px !important; background-color: rgb(255, 255, 255);font-family: 'Hiragino Sans GB', 'Microsoft YaHei', STHeiti, SimSun, 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'Segoe UI', AppleSDGothicNeo-Medium, 'Malgun Gothic', Verdana, Tahoma, sans-serif; padding: 20px;padding: 20px; color: rgb(34, 34, 34); font-size: 15px; font-family: 'Roboto Condensed', Tauri, 'Hiragino Sans GB', 'Microsoft YaHei', STHeiti, SimSun, 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'Segoe UI', AppleSDGothicNeo-Medium, 'Malgun Gothic', Verdana, Tahoma, sans-serif; line-height: 1.6; -webkit-font-smoothing: antialiased; background: rgb(255, 255, 255);"><h2 id="두-숫자-더하기2" style="clear: both;font-size: 1.8em; font-weight: bold; margin: 1.275em 0px 0.85em;margin-top: 0px;border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: rgb(230, 230, 230);"><a name="두-숫자-더하기2" href="#두-숫자-더하기2" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a>두 숫자 더하기2</h2><h4 id="==문제==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==문제==" href="#==문제==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">문제</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">두 16진수 숫자 A,B가 주어진다. A+B의 결과를 10진수로 출력하라.</p><h4 id="==입력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==입력==" href="#==입력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">입력</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">첫째 줄에 A와 B가 주어진다(0&lt;=A,B&lt;=0xFFFF)</p><h4 id="==출력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==출력==" href="#==출력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">출력</mark></h4><p style="margin-top: 0px;margin: 1em 0px; word-wrap: break-word;">첫째 줄에 A+B를 10진수로 출력한다.</p><h4 id="==예제입력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==예제입력==" href="#==예제입력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">예제입력</mark></h4><pre style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); overflow: auto; padding: 0.5em;"><code data-origin="<pre><code>9 A
</code></pre>" style="border: 0px; display: block;font-family: Consolas, Inconsolata, Courier, monospace; font-weight: bold; white-space: pre; margin: 0px;border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-size: 1em; letter-spacing: -1px; font-weight: bold;">9 A
</code></pre><h4 id="==예제출력==" style="clear: both;font-size: 1.4em; font-weight: bold; margin: 0.99em 0px 0.66em;"><a name="==예제출력==" href="#==예제출력==" style="text-decoration: none; vertical-align: baseline;color: rgb(50, 105, 160);"></a><mark style="color: rgb(0, 0, 0); background-color: rgb(252, 248, 227);">예제출력</mark></h4><pre style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); overflow: auto; padding: 0.5em;"><code data-origin="<pre><code>19
</code></pre>" style="border: 0px; display: block;font-family: Consolas, Inconsolata, Courier, monospace; font-weight: bold; white-space: pre; margin: 0px;border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-size: 1em; letter-spacing: -1px; font-weight: bold;">19
</code></pre><p style="margin: 1em 0px; word-wrap: break-word;"><code style="border-top-left-radius: 3px; border-top-right-radius: 3px; border-bottom-right-radius: 3px; border-bottom-left-radius: 3px; word-wrap: break-word; border: 1px solid rgb(204, 204, 204); padding: 0px 5px; margin: 0px 2px;font-family: Consolas, 'Liberation Mono', Menlo, Courier, monospace; font-size: 85%; padding: 0.2em 0.5em; border: 1px solid rgb(239, 239, 239); background-color: rgba(0, 0, 0, 0.0196078);">문제를 만든 사람 : 김봄</code></p></div>
','acm')");
$con->do("INSERT INTO notice VALUES('1','root','2016-04-19','시험용 공지입니다.','안녕하십니까. 김봄은 코딩을 합니다.ㅠ 테스트로 좀 긴 문장을 몇개 쳐봅니다.난나 나나난나 난나나
난나 나나난나 난나나

쭈쭈쭈 쭈쭈쭈 쭈쭈쭈
쭈쭈쭈 쭈쭈쭈 쭈쭈쭈

나는 꿈을 꾸었죠
네모난 달이 떴죠
하늘위로 올라가 
달에게 말을했죠

늦은밤 잠에서 깨어
날개를 흔들었죠
오리는 날수없다
엄마에게 혼났죠

이제는 하늘로 날아갈래요
하늘위 떠있는 멋진 달되고 싶어

날아올라 저 하늘 멋진 달이 될래요
깊은밤 하늘에 빛이 되어 춤을 출꺼야

날아올라 밤하늘 가득 안고 싶어요
이렇게 멋진 날개를 펴
꿈을 꾸어요 난 날아올라

쭈쭈쭈 쭈쭈쭈 쭈쭈쭈
쭈쭈쭈 쭈쭈쭈 쭈쭈쭈

나는 꿈을 꾸었죠
달님이 말을 했죠
어서 위로 올라와 
나와 함께 놀자고

늦은밤 잠에서 깨어
날개를 흔들었죠
엄마도 날수없다
오늘도 혼이났죠

이제는 하늘로 날아갈래요
하늘위 떠있는 멋진 달되고 싶어

날아올라 저 하늘 멋진 달이 될래요
깊은밤 하늘에 빛이 되어 춤을 출꺼야

날아올라 밤하늘 가득 안고 싶어요
이렇게 멋진 날개를 펴
꿈을 꾸어요 난 날아올라

날아올라 날아올라 저 하늘로

깊은밤 하늘에 빛이 되어 춤을 출꺼야

날아올라 날아올라 날아올라 저 하늘로

이제는 날개를 활짝펴고 날아갈꺼야

날아올라 저 하늘 멋진 달이 될래요

깊은밤 하늘에 빛이 되어 춤을 출꺼야

날아올라 밤하늘 가득 안고 싶어요
이렇게 멋진 날개를 펴
꿈을 꾸어요 난 날아올라

쭈쭈쭈 쭈쭈쭈 
쭈쭈쭈 쭈쭈쭈 ')");
$con->do("INSERT INTO notice VALUES('2','root','2016-04-20','영어하세요.','코딩하지말고 영어하세요 김봄씨')");
$con->do("INSERT INTO board VALUES('1','root','2016-04-20','질문있습니다.','1번문제가 맞았는데 틀렸다고 나와요.','question')");
$con->do("INSERT INTO board VALUES('2','root','2016-04-21','알려주세요.','ㅋㅋㅋㅋ문제가 너무 쉬워요.','suggest')");
$con->do("INSERT INTO board VALUES('3','root','2016-04-22','이게 뭔가요??.','버그를 찾았어요 이메일로 보내면 되나요??.','question')");
$con->do("INSERT INTO board VALUES('4','root','2016-04-23','아 웨케 할께 많을까여.','봄아 힘내자.','talk')");
$con->do("INSERT INTO board VALUES('5','root','2016-04-19','자 새로운 질문을 올려봅시다.','제곧내','')");
$con->do("INSERT INTO board_comment VALUES('1','root','니가 못하는 거에요.')");
$con->do("INSERT INTO board_comment VALUES('1','root','초보자한테 너무 뭐라하지 맙시다.')");
$con->do("INSERT INTO board_comment VALUES('5','root','이딴거 올리지마')");
$con->disconnect;
__DATA__
create table userinfo(
	ui_id varchar(48) primary key,
	ui_pw varchar(512),
	ui_name varchar(48),
	ui_email varchar(256),
	ui_salt1 varchar(256),
	ui_salt2 varchar(256),
	ui_comment varchar(128),
	ui_savelog boolean,
	ui_visit int
);
create table nonemail_certification(
	ui_id varchar(48) references userinfo(ui_id),
	nec_str varchar(512)
);
create table admin(
	ui_id varchar(48) references userinfo(ui_id)
);
create table superadmin(
	ui_id varchar(48) references userinfo(ui_id)
);
create table friend(
	ui_id1 varchar(48) references userinfo(ui_id),
	ui_id2 varchar(48) references userinfo(ui_id)
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
	ui_id varchar(48) references userinfo(ui_id),
	uip_language varchar(512),
	uip_time varchar(512),
	uip_status text,
	uip_date varchar(512),
	uip_srcpath varchar(512),
	primary key(uip_srcpath,uip_date)
);
create table userlog(
	ui_id varchar(48) references userinfo(ui_id),
	ul_date varchar(512),
	ul_ip varchar(512),
	ul_env varchar(512)
);
create table notice(
	nt_optnum serial primary key,
	ui_id varchar(48) references userinfo(ui_id), 
	nt_date varchar(512),
	nt_title text,
	nt_content text
);
create table board(
	bd_optnum serial primary key,
	ui_id varchar(48) references userinfo(ui_id),
	bd_date varchar(512),
	bd_title varchar(256),
	bd_content text,
	bd_type varchar(512)
);
create table board_comment(
	bd_optnum serial references board(bd_optnum),
	ui_id varchar(48) references userinfo(ui_id),
	bd_comment varchar(512)
);