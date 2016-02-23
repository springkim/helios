#!/usr/bin/perl
use strict;
use warnings;
use CGI;
my $q=new CGI;
my $file="___";
print $q->header(-charset=>"UTF-8");

print <<EOF
<head>
	<title>BlueCandle</title>
	<link rel="stylesheet" type="text/css" href="../css/$file.css" />
	<script src="javascript/$file.js" type="text/javascript"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	</head>
<body>
EOF
;
print <<EOF
<form action="index.pl" method="post">
	<input type="text" placeholder="ID"></input>
	<input type="text" placeholder=PW"></input>
	<input type="text" placeholder="NAME"></input>
	<input type="text" placeholder="GUILD"></input>
	<input type="text" placeholder="EMAIL"></input>
	<input type="submit" value="send"></input>
</form>
EOF
;

print $q->end_html; 
