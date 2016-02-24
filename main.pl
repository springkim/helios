#!/usr/bin/perl
use strict;
use warnings;
use CGI;
require 'login/aes.pl';	#must be require before info.pl
require 'login/info.pl';
my $q=new CGI;
my $c_id=GetCookieId($q);

my $headline_css_file;
my $webmenu="";
if($c_id){	#login
	$webmenu.='<a href="login/user_info.pl"><img src="css/information.jpg"/></a>';
	$webmenu.='<a href="login/user_info.pl"><img src="css/setting.jpg"/></a>';
	$webmenu.='<a href="login/logout.pl"><img src="css/logout.jpg"/></a>';
	$headline_css_file='css/headline_login.css';
}else{		
	$webmenu.='<a href="login/login.pl"><img src="css/signin.jpg"/></a>';
	$webmenu.='<a href="login/signup.pl"><img src="css/joinus.jpg"/></a>';
	$headline_css_file='css/headline_logout.css';
}

#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print <<EOF
<html>
<head>
<link rel="stylesheet" type="text/css" href="$headline_css_file">
<link rel="stylesheet" type="text/css" href="css/main.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<center>
	<div class="headline">
		<img src="css/title.jpg"/>
		<div class="webmenu">
			$webmenu
  		</div>
  	</div>
</center>
  <center>
  	<div class="main">
      <p>this is main</p>
      
      <p>this is main</p>
      <p>this is main</p>
  </div>
  </center>
</body>
</html>
EOF
;