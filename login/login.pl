#!/usr/bin/perl
#
#	@Project  : Helios
#	@Architecture : DaeHyun, Hwang
#	signup.pl
#
#	@Created by On 2016. 1. 2...
#	@Copyright (C) 2016 DaeHyun, Hwang. All rights reserved.
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
use CGI                 qw( );
use HTTP::BrowserDetect qw( );
#==============================Ready for CGI.===================================
my $q = new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );

#==============================HTML String==============================
my $explain = '<p class="leftP">Your ID</p>';
my $input_text =
'<input type="text" id="ID" value="" autocomplete="off" name="ID" placeholder="ID" onkeyup="id_keyup()" onblur="id_keyup()" maxlength="64"></input>';
my $salt_hidden="";
my $button_text="Next";
my $function_name="id_submit()";
#==============================Recive 'Form' data.==============================
my $id   = $q->param('HID');
my $pw   = $q->param('HPW');
my $salt = $q->param("SALT");
#==============================================================
my $state;
my $c="";
my $redirect_script="";
#=========================in input login==============================
if ($id) {
	if ($pw) {
		$state = $con->prepare("SELECT ui_salt2 FROM userinfo WHERE ui_id = \'$id\'");
		$state->execute();
		my @row = $state->fetchrow_array;
		
		$pw=sha3_512_hex($row[0].$pw);
		$state = $con->prepare("SELECT count(ui_id) FROM userinfo WHERE ui_id = \'$id\' and ui_pw=\'$pw\'");
		$state->execute();
		@row = $state->fetchrow_array;
		if($row[0]=="1"){
			#save cookie
			my $enc_name=AES_Encrypt("bluecandle_helios_cookie_id");
			chop($enc_name);
			chop($enc_name);
			chop($enc_name);
			my $enc_id=AES_Encrypt($id);
			$c=$q->cookie(-name=>$enc_name,-value=>$enc_id);
			
			my $ip = $q->remote_host;
			my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
			my $date=($year+1900).".".($mon+1).".".($mday).". "."$hour:"."$min:"."$sec";
			
			my $bd = HTTP::BrowserDetect->new($q->user_agent());
			my $env=$bd->browser_string(). ' '. $bd->public_version();
			my $query = "INSERT INTO userlog VALUES(\'$id\',\'$date\',\'$ip\',\'$env\')";
			$con->do($query);
			
			$redirect_script='<script>window.location="../index.pl";</script>';
		}else{
			print $q->redirect("login.pl");
		}
	}
	else {	#only input id
		$state = $con->prepare("SELECT ui_salt1 FROM userinfo WHERE ui_id = \'$id\'");
		$state->execute();
		my @row = $state->fetchrow_array;
		if(!$row[0]){
			$row[0]=salt(32);
		}
		$salt_hidden="<input type=\"hidden\" id=\"SALT\" name=\"SALT\" value=\"$row[0]\"/>";
		$explain='<p class="leftP">Your Password</p>';
		$input_text='<input type="password" id="PW" autocomplete="off" name="PW" placeholder="PW" onkeyup="pw_keyup()" onblur="pw_keyup()" maxlength="64"></input>';
		$button_text="Login";
		$function_name="pw_submit()";
	}
}
$con->disconnect();
#------------------------------------end database-------------------------------
if($c){
	print $q->header(-cookie=>$c);
}else{
	print $q->header( -charset => "UTF-8" );
}
print <<EOF
<head>
	<title>BlueCandle</title>
	<link rel="stylesheet" type="text/css" href="css/signup.css" />
	<script src="javascript/sha3.js"></script>
	<script src="javascript/pbkdf2.js"></script>
	<script src="javascript/signup.js" type="text/javascript"></script>
	<script src="javascript/login.js" type="text/javascript"></script>
	$redirect_script
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body>
	<form id="loginForm" action="login.pl" method="post" ENCTYPE="multipart/form-data">
		<div class="container">
			<div class="outer">
				<div class="inner">
					<div class="centered_inner_left">
						$explain
					</div>
					<section class="webdesigntuts-workshop">
					$salt_hidden
					$input_text
					
					<input type="hidden" id="HPW" name="HPW" value=""></input>
					<input type="hidden" id="HID" name="HID" value="$id"></input>
					
					<input type="submit" value="$button_text" onclick="return $function_name"></input>
	</form>
					<form action="signup.pl" >
						<input type="submit" value="Sign Up" style="position:relative;left:-20px;top:-100px">
					</form>
					</section>
				</div>
				
				<div id="msg" class="centered_inner_right2">
						<div class='warn' id="ivchar" style="visibility:hidden;top:175px">Invaild character</div>
				</div>			
			</div>
		</div>
</body>
</html>
EOF
;

