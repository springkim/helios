#!/usr/bin/perl
#
#	@Project  : Helios
#	@Architecture : Kim Bom
#	signup.pl
#
#	@Created by KimBom On 2016. 1. 2...
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
#==============================회원가입을 완료했을때 호출됩니다..==============================
if ($id) {
	$upload_file =~ m<.+\.(\w+)?$>;    #확장자를 추출합니다.
	my $photo_path = "$id-0-.$1";
	copy( $upload_file, "photo/$photo_path" );	#파일을 저장합니다.
	my $p_salt=salt(32);
	$pw=sha3_512_hex($p_salt.$pw);
	my $query = "INSERT INTO userinfo values(\'$id\',\'$pw\',\'$name\',\'$guild\',\'$phone\',\'$email\',\'$photo_path\',\'0\',\'$salt\',\'$p_salt\')";
	$con->do($query);
	$con->disconnect();
	print $q->redirect('login.pl');
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
#==============================CGI 부분==============================
print $q->header( -charset => "UTF-8" );
print <<EOF
<head>
	<title>BlueCandle</title>
	<link rel="stylesheet" type="text/css" href="css/signup.css" />
	<script src="javascript/sha3.js"></script>
	<script src="javascript/pbkdf2.js"></script>
	<script src="javascript/signup.js" type="text/javascript"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<section class="back">
		<form action="login.pl" method="post">
			<input type="submit" id="login"  value="back to login"></input>
		</form>
</selection>
<div class="container">	
	<form action="signup.pl" method="post" ENCTYPE="multipart/form-data">
	<div class="outer"><div class="inner"><div class="centered-top"></div><div class="centered">
		<div class="centered_inner_right"></div>
		<div id="msg" class="centered_inner_right2">
			<div class='warn' id="sameid" style="visibility:$visible;top:177px">The same id exist</div>
			<div class='warn' id="char4" style="visibility:$visible;top:137px">Id must be at least 4 char</div>
			<div class='warn' id="cid" style="visibility:$visible;top:145px">not matching ID</div>
			
			<div class='warn' id="pass4" style="visibility:$visible;top:154px">Password is too short</div>
			<div class='warn' id="ivchar" style="visibility:$visible;top:114px">Invaild character</div>
			<div class='warn' id="cpass" style="visibility:$visible;top:124px">not matching password</div>
			<div class='warn' id="namechk" style="visibility:$visible;top:134px">input your name</div>
			<div class='warn' id="guildchk" style="visibility:$visible;top:144px">input your guild</div>
			<div class='warn' id="phonechk" style="visibility:$visible;top:154px">input your phone</div>
			<div class='warn' id="emchk" style="visibility:$visible;top:164px">This is not a valid e-mail</div>
		</div>
		<div class="centered_inner_left">
			<p class="leftP">Your best id</p>
			<p class="leftP">Confirm id</p>
			<p class="leftP">Safety password</p>
			<p class="leftP">Confirm password</p>
			<p class="leftP">What`s your name?</p>
			<p class="leftP">Where do you belong?</p>
			<p class="leftP">Phone number</p>
			<p class="leftP">Your most used e-mail</p>
			<p class="leftP">Your pretty face</p>
		</div>
		<section class="webdesigntuts-workshop">
			<input type="hidden" id="IDS"  value="$ids"></input>
			<input type="hidden" id="HPW" name="HPW" value=""></input>
			<input type="hidden" id="HID" name="HID" value=""></input>
			<input type="hidden" id="HSALT" name="HSALT" value=""></input>
			
			<input type="text" id="ID" autocomplete="off" name="ID" placeholder="ID" onkeyup="id_keyup()" onblur="id_keyup()" maxlength="64"></input>
			<input type="text" id="CID" autocomplete="off" name="CID" placeholder="Confirm ID" onkeyup="cid_keyup()" onblur="cid_keyup()" maxlength="64"></input>
			<input type="password" id="PW" autocomplete="off" name="PW" placeholder="PW" onkeyup="pw_keyup()" onblur="pw_keyup()" maxlength="64"></input>
			<input type="password" id="CPW" autocomplete="off" name="CPW" placeholder="confirm PW" onkeyup="cpw_keyup()" onblur="pw_keyup()" maxlength="64"></input>
			<input type="text" id="NAME" autocomplete="off" name="NAME" placeholder="NAME" maxlength="64" onkeyup="nempty_keyup('NAME','namechk')" onblur="nempty_keyup('NAME','namechk')"></input>
			<input type="text" id="GUILD" autocomplete="off" name="GUILD" placeholder="GUILD" maxlength="64" onkeyup="nempty_keyup('GUILD','guildchk')" onblur="nempty_keyup('GUILD','guildchk')"></input>
			<input type="text" id="PHONE" autocomplete="off" name="PHONE" placeholder="PHONE" onkeyup="tel_keyup()" onblur="tel_keyup()" maxlength="64" ></input>
			<input type="email" id="EMAIL" autocomplete="off" name="EMAIL" placeholder="EMAIL" onkeyup="em_keyup()" onblur="em_keyup()" maxlength="100"></input>
			<input type="file" style="display:none" id="FILE" name="FILE" onchange="filesizechk(this)" accept="image/*" ></input>
	
			<input type="text" id="fakeFile" value="" style="width:200px;" readonly="readonly"></input>
			<input type="button" value="UPLOAD" onclick="goFile()" style="width:90px;"></input>
			<input type="submit" value="Sign up" onclick="return CheckSubmit();"></input>
		</section>
	</div></div></div></div>
	</form>
	
</body>
</html>
EOF
  ;
