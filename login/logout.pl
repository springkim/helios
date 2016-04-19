#!/usr/bin/perl
#
#	@Project  : Helios
#	@Architecture : Kim Bom
#	logout.pl
#
#	@Created by KimBom On 2016. 3. 3...
#	@Copyright (C) 2016 KimBom. All rights reserved.
#
use strict;
use warnings;
use CGI;
require '../library/info.pl';
my $c_name=GetCookieName();
#======
print <<EOF
Set-Cookie: $c_name=; path=/; Expires=01-01-80
Content-Type: text/html; charset=ISO-8859-1

<html>
	<head>
		<title>BlueCandle</title>
		<script>
			window.location="../main.pl";
		</script>
	</head>
	<body>
	</body>
</html>
EOF
;