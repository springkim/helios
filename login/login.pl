#!/usr/bin/perl
#
# @Project				: Helios
# @Architecture 		: Kim Bom
# @file 				: login.pl
#
# @Created by KimBom On 2016. 04. 08...
# @Copyright (C) 2016 KimBom. All rights reserved.
#
use strict;
use warnings;
use CGI;
use DBI;
use feature 'say';
use Digest::SHA3 qw(sha3_512_hex);
use Crypt::Salt;
use HTTP::BrowserDetect qw( );

require '../../login/aes.pl';  #must be require before info.pl
require '../../login/info.pl';
my $q=new CGI;
my $cookie="";
my $redirect_script="";

my $cid=GetCookieId($q);
if($cid ne ""){
	say $q->redirect('../main.pl');
}

my $id=$q->param('ID');
my $pw=$q->param('EPW');
if($id ne "" && $pw ne ""){
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );	
	my $state=$con->prepare("SELECT ui_salt2 FROM userinfo WHERE ui_id=\'$id\'");
	$state->execute;
	my @row=$state->fetchrow_array;
	$state->finish;
	my $salt2=$row[0];
	foreach my $i(0..777){
		$pw=sha3_512_hex($salt2.$pw);
	}
	$state=$con->prepare("SELECT ui_id,ui_savelog FROM userinfo WHERE ui_id=\'$id\' and ui_pw=\'$pw\'");
	$state->execute;
	@row=$state->fetchrow_array;
	$state->finish;
	#login success
	
	if($#row==1){
		if($row[1] eq "1"){
			#ip address
			my $ip = $q->remote_host;
			#current time(server)
			my $date=GetLocalTime();
			#browser state
			my $bd = HTTP::BrowserDetect->new($q->user_agent());
			my $env=$bd->browser_string(). ' '. $bd->public_version();
			$con->do("INSERT INTO userlog VALUES(\'$id\',\'$date\',\'$ip\',\'$env\')");
		}
		#set cookie
		my $enc_id=AES_Encrypt($id);
		$cookie=$q->cookie(-name=>GetCookieName(),-value=>$enc_id);
		$redirect_script='<script>window.location="../main.pl";</script>';
	}else{	#login failure
		$redirect_script='<script>$(document).ready(function(){
			$("#LFAIL_TITLE").html("<strong>Login failure</strong>");
			$("#LFAIL_COMMENT").html("<h5>Please check your id or password.</h5>");
			$("#LFAILDLG").click();
		})</script>';
		#say $q->redirect('logout.pl');
	}
	$con->disconnect;	
}
#==============================WRITE PERL CGI==============================
if($cookie){
	print $q->header(-cookie=>$cookie);
}else{
	print $q->header(-charset=>"UTF-8");
}
my $str='
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Right - Bootstrap Admin Template</title>
    <link rel="icon" type="image/png" href="../img/favicon.png">
    <link rel="apple-touch-icon-precomposed" href="../img/apple-touch-favicon.png">
    <link href="../libs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="http://fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic,900,900italic" rel="stylesheet" type="text/css">
    <link href="../libs/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="../libs/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" rel="stylesheet">
    <link href="../css/right.dark.css" rel="stylesheet" class="demo__css">
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
    <script src="sha/sha3.js"></script>
	 <script src="sha/pbkdf2.js"></script>
    <script src="login.js"></script>
    <style>
    .signup__logo {
    	height: 175px;
    	margin-bottom: 20px;
    	background: url("../img/login_logo.png") 50% top no-repeat;
    	background-size: contain;
	}
    </style>
    '.$redirect_script.'
    <link href="../css/demo.css" rel="stylesheet"><!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
  </head>
  <body class="framed" >
    <div class="wrapper" >
    <div class="main" style="margin-left:0px;padding-left:0px;margin-bottom:0px;">
     <div class="main__scroll scrollbar-macosx "style="height : 100%;min-height:100%">
      <div class="login" style="background-color:rgba(0,0,0,0)">
        <form id="LOGINFORM" action="login.pl" class="login__form" method="post" ENCTYPE="multipart/form-data">
          <div class="signup__logo"></div> 
           <div class="form-group has-feedback" id="ID_EDITBOX">
                      <label class="control-label">Input your id</label>
                      <div class="form-group"><input type="password"  id="ID" name="ID" maxlength="64" class="form-control"></div>
                      <span class="glyphicon form-control-feedback"></span>
			</div>
			
           <div class="form-group  has-feedback" id="PW_EDITBOX">
                      <label class="control-label">Secret password</label>
                      <div class="form-group"><input type="password"  id="PW" name="PW" maxlength="64" class="form-control"></div>
                      <span class="glyphicon form-control-feedback"></span>
			</div>
			
			<div style="display:none">
          <input type="submit" id="SUBMIT_BTN" value=""></input>
          </div>
          <input type="hidden" id="EPW" name="EPW" value="" maxlength="500"></input>
         <button id="login" class="btn btn-success" style="margin-top:10px;margin-bottom:10px;float:right">
         Login
         </button>
            
        </form>
      </div>
    </div>
    </div>
    
    <div style="display:none">
    <div class="template template__modals" style="display:inline"><div class="template__modal" style="display:inline">                           
    <button id="LOGINDLG" type="check" data-toggle="modal" data-target="#modal1" class="btn btn-info" style="float:right">Check</button>
    </div></div></div>
    
    <div style="display:none">
    <div class="template template__modals" style="display:inline"><div class="template__modal" style="display:inline">                           
    <button id="LFAILDLG" type="check" data-toggle="modal" data-target="#modal2" class="btn btn-info" style="float:right">Check</button>
    </div></div></div>
    
    <div id="modal1" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header">
    <button type="button" data-dismiss="modal" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title">login information missing</h4></div>
    <div class="modal-body">
    <div role="alert" class="alert alert-danger" id="LOGIN_DIALOG_COLOR">
    <h4><i class="alert-ico fa fa-fw fa-ban" id="LOGIN_DIALOG"></i><strong id="LOGIN_TITLE"><strong>Fail</strong></strong></h4>
    <strong id="LOGIN_COMMENT"><h5>Hello, World</h5></strong>
    </div>
    </div>
    <div class="modal-footer">
    <button type="button" data-dismiss="modal" class="btn btn-default">Close</button>
    </div></div></div></div>
    
    <div id="modal2" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header">
    <button type="button" data-dismiss="modal" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title">Login failure</h4></div>
    <div class="modal-body">
    <div role="alert" class="alert alert-danger" id="LFAIL_DIALOG_COLOR">
    <h4><i class="alert-ico fa fa-fw fa-ban" id="LFAIL_DIALOG"></i><strong id="LFAIL_TITLE"><strong>Fail</strong></strong></h4>
    <strong id="LFAIL_COMMENT"><h5>return 0;</h5></strong>
    </div>
    </div>
    <div class="modal-footer">
    <button type="button" data-dismiss="modal" class="btn btn-default">Close</button>
    </div></div></div></div>
     
    
    
    </div>
    <script src="../libs/jquery/jquery.min.js"></script>
    <script src="../libs/bootstrap/js/bootstrap.min.js"></script>
    <script src="../js/demo.js"></script>
    <script src="../js/main.js"></script>
    <script src="../libs/jquery/jquery.min.js"></script>
    <script src="../libs/bootstrap/js/bootstrap.min.js"></script>
    <script src="../libs/jquery.scrollbar/jquery.scrollbar.min.js"></script>
    <script src="../libs/bootstrap-tabdrop/bootstrap-tabdrop.min.js"></script>
    <script src="../libs/sparkline/jquery.sparkline.min.js"></script>
    <script src="../libs/ionrangeslider/js/ion.rangeSlider.min.js"></script>
    <script src="../libs/inputNumber/js/inputNumber.js"></script>
    <script src="../libs/bootstrap-switch/dist/js/bootstrap-switch.min.js"></script>
    <script src="../libs/raphael/raphael-min.js"></script>
    <script src="../libs/morris.js/morris.min.js"></script>
    <script src="../libs/bootstrap-select/dist/js/bootstrap-select.min.js"></script>
    
    <script src="../libs/jquery/jquery.min.js"></script>
    <script src="../libs/bootstrap/js/bootstrap.min.js"></script>
    <script src="../libs/jquery.scrollbar/jquery.scrollbar.min.js"></script>
    <script src="../libs/bootstrap-tabdrop/bootstrap-tabdrop.min.js"></script>
    <script src="../libs/sparkline/jquery.sparkline.min.js"></script>
    <script src="../libs/ionrangeslider/js/ion.rangeSlider.min.js"></script>
    <script src="../libs/inputNumber/js/inputNumber.js"></script>
    <script src="../libs/bootstrap-switch/dist/js/bootstrap-switch.min.js"></script>
    <script src="../js/main.js"></script>
    <script src="../js/demo.js"></script>
  </body>
</html>
';
$str=~s/\s+/ /g;
say $str;
