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
my $id=$q->param('ID');
my $pw=$q->param('PW');
my $name=$q->param('NAME');
my $email=$q->param('EMAIL');
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
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
     <script src="signup.js"></script>
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
  <body class="framed" >
    <div class="wrapper" >
    <div class="main" style="margin-left:0px;padding-left:0px;margin-bottom:0px;">
     <div class="main__scroll scrollbar-macosx "style="height : 100%;min-height:100%">
      <div class="login" style="background-color:rgba(0,0,0,0)">
        <form action="signup.pl" class="login__form">
          <div class="signup__logo"></div> 
           <div class="form-group has-feedback" id="ID_EDITBOX">
                      <label class="control-label">Your best id</label>
                      <div class="form-group" >
                      	<input style="width:75%;display:inline" type="text"  id="ID" name="ID" maxlength="64" class="form-control">
                      	
                      	<div class="template template__modals" style="display:inline"><div class="template__modal" style="display:inline">
                                
                              <button id="checkid" type="button" data-toggle="modal" data-target="#modal3" class="btn btn-info" style="float:right">Check</button>
                         </div></div>
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
              <button type="submit" class="btn btn-default" style="margin-top:10px">Sign up</button>
            </div>
          </div>
        </form>
      </div>
    </div>
    </div>
    
    
    
    
    
    <div id="modal3" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header">
    <button type="button" data-dismiss="modal" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title">user id overlap check</h4></div>
    <div class="modal-body">
    <div role="alert" class="alert alert-danger" id="IDCHECK_DIALOG_COLOR">
    <h4><i class="alert-ico fa fa-fw fa-ban" id="IDCHECK_DIALOG"></i><strong id="IDCHECK_TITLE"><strong>Fail</strong></strong></h4>Change a few things up and try submitting again.
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

EOF
;
$con->disconnect;
