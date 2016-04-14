#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use Array::Utils qw(:all);

require '../login/aes.pl';	#must be require before info.pl
require '../login/info.pl';
require 'common_html.pl';
require 'language_rank.pl';
require 'overview.pl';
require 'notice.pl';
require 'submit_result.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $c_id=GetCookieId($q);
#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print helios_html_head($q,$c_id);
print '<body class="framed main-scrollable"><div class="wrapper">';

print_header($c_id);
print '<div class="dashboard">';
print_sidemenu($c_id);
	
###################################################################################
my $language_graph=print_language_graph();
my $overview=print_overview();
my $notice=print_notice();
my $submit_result=print_submit_result($c_id);
print <<EOF
<div class="main">
          <div class="main__scroll scrollbar-macosx">
            <div class="main__cont">
              <div class="main-heading">
                <div class="main-title">
                  <ol class="breadcrumb">
                    <li class="active">Dashboard</li>
                  </ol>
                </div>
                <div class="main-filter">
                  <form class="main-filter__search">
                    <div class="input-group">
                      <input type="text" placeholder="Search..." class="form-control"><span class="input-group-btn">
                        <button type="button" class="btn btn-default">
                          <div class="fa fa-search"></div>
                        </button></span>
                    </div>
                  </form>
                </div>
              </div>
              <div class="container-fluid half-padding">
                <div class="pages pages_dashboard">
                  <div class="row">
                   		$language_graph
                    $overview
                  </div>
                  <div class="row">
                    	$notice
                   	$submit_result
                    
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
EOF
;
##################################################################################
print '</div></div></div>';

#print_demo();

print_js();
print_graph_js();

print '<script src="libs/morris.js/morris.min.js"></script>';
###############################

###############################
print '</body></html>';
$con->disconnect;