#!/usr/bin/perl
#
#	@Project  : Helios
#	@Architecture : Kim Bom
#	logout.pl
#
#	@Created by KimBom On 2016. 1. 3...
#	@Copyright (C) 2015 KimBom. All rights reserved.
#
use strict;
use warnings;
use CGI;
require 'aes.pl';
my $enc_name=AES_Encrypt("bluecandle_helios_cookie_id");
chop($enc_name);
chop($enc_name);
chop($enc_name);
#======
print <<EOF
Set-Cookie: $enc_name=; path=/; Expires=01-01-80
Content-Type: text/html; charset=ISO-8859-1

<html>
	<head>
		<title>BlueCandle</title>
		<script>
			window.location="../dist/main.pl";
		</script>
	</head>
	<body>
	</body>
</html>
EOF
;