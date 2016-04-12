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
                    <div class="col-md-4">
                      <div class="panel panel-danger">
                        <div class="panel-heading panel-heading_label">
                          <h3 class="panel-title">Submit result</h3>
                          <div class="label label-danger">2</div>
                        </div>
                        <div class="sp-widget">
                          <div class="sp-widget__wrap scrollable scrollbar-macosx">
                            <div class="sp-widget__cont">
                              <div class="sp-widget__top">
                                <div class="sp-widget__info">
                                  <div class="sp-widget__title"><i class="fa fa-envelope-o"></i><span>2 New Messages</span></div>
                                </div>
                                <div class="sp-widget__all"><a href="inbox.html" class="btn btn-default btn-block">Show All</a></div>
                              </div>
                              <div class="sp-widget__list">
                                <div class="sp-widget__item">
                                  <div class="sp-widget__user"><a href="./">Carol Burton</a><span class="sp-widget__date">, 18:06 pm</span></div>
                                  <div class="sp-widget__text">Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.</div>
                                </div>
                                <div class="sp-widget__item">
                                  <div class="sp-widget__user"><a href="./">Judy Shaw</a><span class="sp-widget__date">, 11:38 pm</span></div>
                                  <div class="sp-widget__text">Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.</div>
                                </div>
                                <div class="sp-widget__item">
                                  <div class="sp-widget__user"><a href="./">Angela Kennedy</a><span class="sp-widget__date">, 13:03 pm - 01.09.2016</span></div>
                                  <div class="sp-widget__text">Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.</div>
                                </div>
                                <div class="sp-widget__item">
                                  <div class="sp-widget__user"><a href="./">Larry Cole</a><span class="sp-widget__date">, 15:10 pm - 01.08.2016</span></div>
                                  <div class="sp-widget__text">Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.</div>
                                </div>
                                <div class="sp-widget__item">
                                  <div class="sp-widget__user"><a href="./">Wanda Watson</a><span class="sp-widget__date">, 09:18 pm - 01.08.2016</span></div>
                                  <div class="sp-widget__text">Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.</div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
EOF
;
##################################################################################
print '</div></div>';

#print_demo();
print_js();
print '<script src="libs/morris.js/morris.min.js"></script>';
###############################
print_graph_js();
###############################
print '</div></body></html>';
$con->disconnect;