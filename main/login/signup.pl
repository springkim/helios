#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use Array::Utils qw(:all);

require '../../login/aes.pl';  #must be require before info.pl
require '../../login/info.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $c_id=GetCookieId($q);
#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print <<EOF
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
    <style>
    .signup__logo {
    	height: 175px;
    	margin-bottom: 20px;
    	background: url('../img/logo.png') 50% top no-repeat;
    	background-size: contain;
	}
    </style>
    <link href="../css/demo.css" rel="stylesheet"><!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script><![endif]-->
  </head>
  <body class="framed">
    <div class="wrapper">
      <div class="login">
        <form action="signup.pl" class="login__form">
          <div class="signup__logo"></div> 
           <div class="form-group  has-feedback">
                      <label class="control-label">Your best id</label>
                      <div class="form-group" >
                      	<input style="width:75%;display:inline" type="text"  id="ID" name="ID" maxlength="64" class="form-control">
                      	<button type="button" class="btn btn-info" style="float:right">Check</button>
                      </div>
                      
                      <span class="glyphicon form-control-feedback"></span>
                      
                      
			</div>
			
           <div class="form-group  has-feedback">
                      <label class="control-label">Safety password</label>
                      <div class="form-group"><input type="text"  id="PW" name="PW" maxlength="64" class="form-control"></div>
                      <span class="glyphicon form-control-feedback"></span>
			</div>
			<div class="form-group  has-feedback">
                      <label class="control-label">Confirm password</label>
                      <div class="form-group"><input type="text"  id="CPW" name="CPW" maxlength="64" class="form-control"></div>
                      <span class="glyphicon form-control-feedback"></span>
			</div>
			<div class="form-group  has-feedback">
                      <label class="control-label">Your name</label>
                      <div class="form-group"><input type="text"  id="NAME" name="NAME" maxlength="64" class="form-control"></div>
                      <span class="glyphicon form-control-feedback"></span>
			</div>
          <div class="form-group  has-feedback">
                      <label class="control-label">Your e-mail</label>
                      <div class="form-group" >
                      	<input style="width:75%;display:inline" type="text"  id="EMAIL" name="EMAIL" maxlength="64" class="form-control">
                      	<button type="button" class="btn btn-info" style="float:right">Check</button>
                      </div>
                      
                      <span class="glyphicon form-control-feedback"></span>
                      
                      
			</div>
          
          <div class="form-group login__action">
            <div class="login__submit">
              <button type="submit" class="btn btn-default">Sign up</button>
            </div>
          </div>
        </form>
      </div>
    </div>
    
    <script src="libs/jquery/jquery.min.js"></script>
    <script src="libs/bootstrap/js/bootstrap.min.js"></script>
    <script src="js/demo.js"></script>
  </body>
</html>

EOF
;
$con->disconnect;
