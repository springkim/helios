#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use Array::Utils qw(:all);

require '../login/aes.pl';	#must be require before info.pl
require '../login/info.pl';
require 'common_html.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $c_id=GetCookieId($q);

#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print_head($q,$c_id);
print '<body class="framed main-scrollable"><div class="wrapper">';





print_header();
print '<div class="dashboard">';

print_sidemenu($c_id);
print '</div>';

print_demo();
print_js();
print '</div></body></html>';
$con->disconnect;