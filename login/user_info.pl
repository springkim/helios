#!/usr/bin/perl
#
#	@Project  : Helios
#	@Architecture : Kim Bom
#	user_info.pl
#
#	@Created by KimBom On 2016. 2. 19...
#	@Copyright (C) 2015 KimBom. All rights reserved.
#
use strict;
use warnings;
use CGI;
use DBI;
use File::Copy;
use Digest::SHA3 qw(sha3_512_hex);
use Crypt::Salt;
require 'info.pl';
require 'aes.pl';

#==============================CGI 작업을 준비합니다.==============================
my $q = new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );

#==============================Form의 값을 받아옵니다.==============================
my $id          = $q->param('HID');
my $pw          = $q->param('HPW');
my $name        = $q->param('NAME');
my $guild       = $q->param('GUILD');
my $phone       = $q->param('PHONE');
my $email       = $q->param('EMAIL');
my $upload_file = $q->param('FILE');
my $salt        = $q->param('HSALT');
#$id='root';$pw='root';$name='root';$guild='root';$phone='1234';$email='root';$salt='abvs';
my $ids = "";    #데이터베이스의 아이디 목록입니다.

#get cookie
my $enc_name=AES_Encrypt("bluecandle_helios_cookie_id");
chop($enc_name);
chop($enc_name);
chop($enc_name);
my $c=$q->cookie($enc_name);	#cookie
if($c){
	$c=AES_Decrypt($c);
}
my $e_id="";
my $e_name="";
my $e_guild="";
my $e_phone="";
my $e_email="";
my $e_photo="";
my $e_salt="";
if($c){
    my $state=$con->prepare("SELECT ui_id,ui_name,ui_guild,ui_phone,ui_email,ui_photo,ui_salt1 FROM userinfo WHERE ui_id=\'$c\'");
    $state->execute();
    while ( my $row = $state->fetchrow_hashref ) {
        $e_id=$row->{ui_id};
        $e_name=$row->{ui_name};
        $e_guild=$row->{ui_guild};
        $e_phone=$row->{ui_phone};
        $e_email=$row->{ui_email};
        $e_photo=$row->{ui_photo};
        $e_salt=$row->{ui_salt1};
    }
}else{
    print $q->redirect("../index.pl");
}
my $script="";
#==============================회원가입을 완료했을때 호출됩니다..==============================
my $DEBUG=$id;
if ($id) {
    #기존 비밀번호의 매칭을 검사.
    my $default_salt="";
    my $default_pw="";
     my $state=$con->prepare("SELECT ui_pw,ui_salt2 FROM userinfo WHERE ui_id=\'$c\'");
    $state->execute();
    while ( my $row = $state->fetchrow_hashref ) {    
        $default_salt=$row->{ui_salt2};
        $default_pw=$row->{ui_pw};
    }
    my $passchk=sha3_512_hex($default_salt.$q->param('CURRPW'));
    $DEBUG=$q->param('CURRPW');
    if($default_pw ne $passchk){
        $script='<script>alert("current password is wrong!!")</script>';
    }else{
    my $photo_path=$e_photo;
    if($upload_file ne ""){
	   $upload_file =~ m<.+\.(\w+)?$>;    #확장자를 추출합니다.
        my $exe=$1;
       $e_photo =~ m/-([^-]*)-/;
       my $num=$1+1;
	   $photo_path = "$id-$num-.$exe";
	   copy( $upload_file, "photo/$photo_path" );	#파일을 저장합니다.
    }
	my $p_salt=salt(32);
	$pw=sha3_512_hex($p_salt.$pw);
    my $query="UPDATE userinfo set ui_pw=\'$pw\' , ui_name=\'$name\' , ui_guild=\'$guild\' , ui_phone=\'$phone\' ,ui_email=\'$email\',ui_photo=\'$photo_path\'
    ,ui_salt1=\'$salt\',ui_salt2=\'$p_salt\' WHERE ui_id=\'$id\'";
    $DEBUG=$query;
	#my $query = "INSERT INTO userinfo values(\'$id\',\'$pw\',\'$name\',\'$guild\',\'$phone\',\'$email\',\'$photo_path\',\'0\',\'$salt\',\'$p_salt\')";
	$con->do($query);
	$con->disconnect();
	print $q->redirect('../index.pl');
    }
}
else {
	my $query = "SELECT ui_id FROM userinfo";
	my $state = $con->prepare($query);
	$state->execute();
	while ( my @row = $state->fetchrow_array ) {
		$ids = $ids . $row[0] . ",";
	}
	chop($ids);
	$state->finish();
	$con->disconnect();
    
}
#=======================================DEBUG=================
my $visible="hidden";
#==============================CGI 부분==============================72
print $q->header( -charset => "UTF-8" );
print <<EOF
<head>
	<title>BlueCandle</title>
	<link rel="stylesheet" type="text/css" href="css/user_info.css" />
	<script src="javascript/sha3.js"></script>
	<script src="javascript/pbkdf2.js"></script>
	<script src="javascript/user_info.js" type="text/javascript"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    $script
</head>
<body>
<p>$DEBUG</p>
<section class="back">
		<form action="../index.pl" method="post">
			<input type="submit" id="login"  value="go to main"></input>
		</form>
</selection>
<div class="container">	
	<form action="user_info.pl" method="post" ENCTYPE="multipart/form-data">
    
	<img src="photo/$e_photo" width="200px" height="200px" style="border-radius:20px;position:absolute;left:42%">
    <div class="outer"><div class="inner"><div class="centered-top"></div><div class="centered">
    
		<div class="centered_inner_right"></div>
		<div id="msg" class="centered_inner_right2" >
			
			<div class='warn' id="pass4" style="visibility:$visible;top:226px">Password is too short</div>
			<div class='warn' id="ivchar" style="visibility:$visible;top:186px">Invaild character</div>
			<div class='warn' id="cpass" style="visibility:$visible;top:196px">not matching password</div>
			<div class='warn' id="namechk" style="visibility:$visible;top:206px">input your name</div>
			<div class='warn' id="guildchk" style="visibility:$visible;top:216px">input your guild</div>
			<div class='warn' id="phonechk" style="visibility:$visible;top:226px">input your phone</div>
			<div class='warn' id="emchk" style="visibility:$visible;top:236px">This is not a valid e-mail</div>
		</div>
		<div class="centered_inner_left">
			<p class="leftP">Your best id</p>
			<p class="leftP">Safety password</p>
			<p class="leftP">Confirm password</p>
			<p class="leftP">What`s your name?</p>
			<p class="leftP">Where do you belong?</p>
			<p class="leftP">Phone number</p>
			<p class="leftP">Your most used e-mail</p>
			<p class="leftP">Your pretty face</p>
            <p class="leftP2">Current Password</p>
		</div>
		<section class="webdesigntuts-workshop" >
			<input type="hidden" id="IDS"  value="$ids"></input>
			<input type="hidden" id="HPW" name="HPW" value=""></input>
			<input type="hidden" id="HID" name="HID" value=""></input>
			<input type="hidden" id="HSALT" name="HSALT" value=""></input>
            <input type="hidden" id="DEFAULT_SALT" name="DEFAULT_SALT" value="$e_salt"></input>
            
			<input type="text" id="ID" autocomplete="off" name="ID"  onkeyup="id_keyup()" onblur="id_keyup()" maxlength="64" value="$e_id" readonly="readonly"></input>
			<input type="password" id="PW" autocomplete="off" name="PW"  onkeyup="pw_keyup()" onblur="pw_keyup()" maxlength="64"></input>
			<input type="password" id="CPW" autocomplete="off" name="CPW"  onkeyup="cpw_keyup()" onblur="pw_keyup()" maxlength="64"></input>
			<input type="text" id="NAME" autocomplete="off" name="NAME"  maxlength="64" onkeyup="nempty_keyup('NAME','namechk')" onblur="nempty_keyup('NAME','namechk')" value="$e_name"></input>
			<input type="text" id="GUILD" autocomplete="off" name="GUILD"  maxlength="64" onkeyup="nempty_keyup('GUILD','guildchk')" onblur="nempty_keyup('GUILD','guildchk')" value="$e_guild"></input>
			<input type="text" id="PHONE" autocomplete="off" name="PHONE"  onkeyup="tel_keyup()" onblur="tel_keyup()" maxlength="64" value="$e_phone"></input>
			<input type="email" id="EMAIL" autocomplete="off" name="EMAIL"  onkeyup="em_keyup()" onblur="em_keyup()" maxlength="100" value="$e_email"></input>
			<input type="file" style="display:none" id="FILE" name="FILE" onchange="filesizechk(this)" accept="image/*" value="$e_photo"></input>
	
			<input type="text" id="fakeFile" value="" placeholder="***default***" style="width:200px;" readonly="readonly"></input>
			<input type="button" value="UPLOAD" onclick="goFile()" style="width:90px;"></input>
            <input type="password" id="CURRPW" autocomplete="off" name="CURRPW"  onkeyup="pw_keyup()" onblur="pw_keyup()" maxlength="64"></input>
			<input type="submit" value="Confirm information" onclick="return CheckSubmit();"></input>
		</section>
	</div></div></div></div>
	</form>
	
</body>
</html>
EOF
  ;
