#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use feature 'say';
use Digest::SHA3 qw(sha3_512_hex);
use Crypt::Salt;

require '../../login/aes.pl';  #must be require before info.pl
require '../../login/info.pl';
my $q=new CGI;

my $id=$q->param('ID');
my $pw=$q->param('EPW');
my $name=$q->param('NAME');
my $email=$q->param('EMAIL');
my $salt1=$q->param('SALT1');
open FP,">","test";
print FP $id,"\n",$pw,"\n",$name,"\n",$email,"\n",$salt1,"\n";
close FP;
if($id ne "" && $pw ne "" && $name ne "" && $email ne "" && $salt1 ne ""){
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );	
	my $salt2=salt(32);
	say $q->redirect("../main.pl");
	foreach my $i(0..777){
		$pw=sha3_512_hex($salt2.$pw);
	}
	$con->do("INSERT INTO userinfo VALUES(\'$id\',\'$pw\',\'$name\',\'$email\',\'$salt1\',\'salt2\',\'한마디! 써주세요!\',TRUE,0)");
	$con->do("INSERT INTO nonemail_certification VALUES(\'$id\')");
	$con->disconnect;	
	
}

#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
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
    <script src="signup.js"></script>
    <style>
    .signup__logo {
    	height: 175px;
    	margin-bottom: 20px;
    	background: url("../img/logo.png") 50% top no-repeat;
    	background-size: contain;
	}
    </style>
    <link href="../css/demo.css" rel="stylesheet"><!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
  </head>
  <body class="framed" >
    <div class="wrapper" >
    <div class="main" style="margin-left:0px;padding-left:0px;margin-bottom:0px;">
     <div class="main__scroll scrollbar-macosx "style="height : 100%;min-height:100%">
      <div class="login" style="background-color:rgba(0,0,0,0)">
        <form id="SIGNUPFORM" action="signup.pl" class="login__form" method="post" ENCTYPE="multipart/form-data">
          <div class="signup__logo"></div> 
           <div class="form-group has-feedback" id="ID_EDITBOX">
                      <label class="control-label">Your best id</label>
                      <div class="form-group" >
                      	<input style="width:75%;display:inline" type="text"  id="ID" name="ID" maxlength="64" class="form-control">
                      	
                      	<div class="template template__modals" style="display:inline"><div class="template__modal" style="display:inline">
                                
                              <button id="checkid" type="button" data-toggle="modal" data-target="#modal1" class="btn btn-info" style="float:right">Check</button>
                         </div></div>
                      </div>
                      
                      <span class="glyphicon form-control-feedback"></span>
                      
                      
			</div>
			
           <div class="form-group  has-feedback" id="PW_EDITBOX">
                      <label class="control-label">Safety password</label>
                      <div class="form-group"><input type="password"  id="PW" name="PW" maxlength="64" class="form-control"></div>
                      <span class="glyphicon form-control-feedback"></span>
			</div>
			<div class="form-group  has-feedback" id="CPW_EDITBOX">
                      <label class="control-label">Confirm password</label>
                      <div class="form-group"><input type="password"  id="CPW" name="CPW" maxlength="64" class="form-control"></div>
                      <span class="glyphicon form-control-feedback"></span>
			</div>
			<div class="form-group  has-feedback" id="NAME_EDITBOX">
                      <label class="control-label">Your name</label>
                      <div class="form-group"><input type="text"  id="NAME" name="NAME" maxlength="64" class="form-control"></div>
                      <span class="glyphicon form-control-feedback"></span>
			</div>
          <div class="form-group  has-feedback" id="EMAIL_EDITBOX">
                      <label class="control-label">Your e-mail</label>
                      <div class="form-group" >
                      	<input style="width:75%;display:inline" type="text"  id="EMAIL" name="EMAIL" maxlength="64" class="form-control">
                      	
                      	<div class="template template__modals" style="display:inline"><div class="template__modal" style="display:inline">
                                
                              <button id="checkemail" type="button" data-toggle="modal" data-target="#modal2" class="btn btn-info" style="float:right">Check</button>
                         </div></div>
                      </div>
                      
                      <span class="glyphicon form-control-feedback"></span>
                      
                      <span class="glyphicon form-control-feedback"></span>
                      
                      
			</div>
			<div style="display:none">
          <input type="submit" id="SUBMIT_BTN" value=""></input>
          </div>
          <input type="hidden" id="SALT1" name="SALT1" value=""></input>
          <input type="hidden" id="EPW" name="EPW" value="" maxlength="500"></input>
         <button id="signup" class="btn btn-default" style="margin-top:10px;margin-bottom:10px;float:right">Sign up</button>
            
        </form>
      </div>
    </div>
    </div>
    
    <div style="display:none">
    <div class="template template__modals" style="display:inline"><div class="template__modal" style="display:inline">                           
    <button id="SIGNUPDLG" type="check" data-toggle="modal" data-target="#modal3" class="btn btn-info" style="float:right">Check</button>
    </div></div></div>
    
    
    <div id="modal1" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header">
    <button type="button" data-dismiss="modal" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title">user id overlap check</h4></div>
    <div class="modal-body">
    <div role="alert" class="alert alert-danger" id="IDCHECK_DIALOG_COLOR">
    <h4><i class="alert-ico fa fa-fw fa-ban" id="IDCHECK_DIALOG"></i><strong id="IDCHECK_TITLE"><strong>Fail</strong></strong></h4>
    <strong id="IDCHECK_COMMENT"><h5>Hello, World</h5></strong>
    </div>
    </div>
    <div class="modal-footer">
    <button type="button" data-dismiss="modal" class="btn btn-default">Close</button>
    </div></div></div></div>
    
    <div id="modal2" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header">
    <button type="button" data-dismiss="modal" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title">user email overlap check</h4></div>
    <div class="modal-body">
    <div role="alert" class="alert alert-danger" id="EMAILCHECK_DIALOG_COLOR">
    <h4><i class="alert-ico fa fa-fw fa-ban" id="EMAILCHECK_DIALOG"></i><strong id="EMAILCHECK_TITLE"><strong>Fail</strong></strong></h4>
    <strong id="EMAILCHECK_COMMENT"><h5>return 0;</h5></strong>
    </div>
    </div>
    <div class="modal-footer">
    <button type="button" data-dismiss="modal" class="btn btn-default">Close</button>
    </div></div></div></div>
    
    <div id="modal3" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header">
    <button type="button" data-dismiss="modal" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title">sign up error!!</h4></div>
    <div class="modal-body">
    <div role="alert" class="alert alert-danger" id="SIGNUP_DIALOG_COLOR">
    <h4><i class="alert-ico fa fa-fw fa-ban" id="SIGNUP_DIALOG"></i><strong id="SIGNUP_TITLE"><strong>Fail</strong></strong></h4>
    <strong id="SIGNUP_COMMENT"><h5>stdio</h5></strong>
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

