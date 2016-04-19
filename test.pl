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
$con->do("INSERT INTO userinfo VALUES('$id',\'$pw\',\'$name\',\'$email\',\'$salt1\',\'$salt2\',\'한마디! 써주세요!\',TRUE,0)");
$con->do("INSERT INTO nonemail_certification VALUES(\'$id\',\'$salt2\')");
$con->do("INSERT INTO superadmin VALUES(\'$id\')");
die;
my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
$mon+=1;
$year+=1900;
if(length($mon)==1){
		$mon='0'.$mon;	
	}
	if(length($mday)==1){
		$mday='0'.$mday;	
	}
	if(length($hour)==1){
		$hour='0'.$hour;
	}
	if(length($min)==1){
		$min='0'.$min;
	}
	if(length($sec)==1){
		$sec='0'.$sec;
	}
my $uip_date="$year-$mon-$mday-$hour-$min-$sec";
my $h2=$hour+1;
my $uip_date2="$year-$mon-$mday-$h2-$min-$sec";


$con->do("INSERT INTO notice VALUES(default,'$id',\'$year-$mon-19\',\'시험용 공지입니다.\',\'안녕하십니까. 김봄은 코딩을 합니다.ㅠ 테스트로 좀 긴 문장을 몇개 쳐봅니다.난나 나나난나 난나나
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
쭈쭈쭈 쭈쭈쭈 \')");
$con->do("INSERT INTO notice VALUES(default,'$id',\'$year-$mon-20\',\'영어하세요.\',\'코딩하지말고 영어하세요 김봄씨\')");

$con->do("INSERT INTO board VALUES(default,'$id',\'$year-$mon-20\','질문있습니다.','1번문제가 맞았는데 틀렸다고 나와요.','question')");
$con->do("INSERT INTO board VALUES(default,'$id',\'$year-$mon-21\','알려주세요.','ㅋㅋㅋㅋ문제가 너무 쉬워요.','suggest')");
$con->do("INSERT INTO board VALUES(default,'$id',\'$year-$mon-22\','이게 뭔가요??.','버그를 찾았어요 이메일로 보내면 되나요??.','question')");
$con->do("INSERT INTO board VALUES(default,'$id',\'$year-$mon-23\','아 웨케 할께 많을까여.','봄아 힘내자.','talk')");

$con->do("INSERT INTO board_comment VALUES(1,'$id','니가 못하는 거에요.')");
$con->do("INSERT INTO board_comment VALUES(1,'$id','초보자한테 너무 뭐라하지 맙시다.')");
$con->disconnect;
