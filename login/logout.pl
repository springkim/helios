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
chop($enc_name);	#AES암호화후 생기는 ==문자와 개행문자를 제거한다.
chop($enc_name);
chop($enc_name);
#==============================쿠키를 삭제해 로그아웃 한다.
print <<EOF
Set-Cookie: $enc_name=; path=/; Expires=01-01-80
Content-Type: text/html; charset=ISO-8859-1

<html>
	<head>
		<title>BlueCandle</title>
		<script>
			window.location="../index.pl";
		</script>
	</head>
	<body>
	</body>
</html>
EOF
;