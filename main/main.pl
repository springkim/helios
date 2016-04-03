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
print helios_html_head($q,$c_id);
print '<body class="framed main-scrollable"><div class="wrapper">';

print_header();
print '<div class="dashboard">';
print_sidemenu($c_id);
print '</div>';
###################################################################################
print '<div class="main"><div class="main__scroll scrollbar-macosx"><div class="main__cont">';
print <<EOF
<div class="main-heading">
                <div class="main-title">
                  <ol class="breadcrumb">
                    <li class="active">Helios Main Page</li>
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
EOF
;
################################################################################
print '<div class="container-fluid half-padding"><div class="pages pages_dashboard">';
                
print <<EOF
                  <div class="row">
                    <div class="col-md-9">
                      <div class="panel panel-danger">
                        <div class="panel-heading">
                          <h3 class="panel-title">Language statistic</h3>
                        </div>
                        <div class="panel-body">
                          <div class="ld-widget">
                            <div class="ld-widget__cont">
                              <div class="ld-widget-main">
                                <div class="ld-widget-main__title">Languages</div>
                                <div class="ld-widget-main__chart"></div>
                              </div>
                              <div class="ld-widget-side">
                                <div class="ld-widget-side__title">Ratio</div>
                                <div class="ld-widget-side__chart"></div>
                                <div class="ld-widget-side__footer">
                                  <div class="ld-widget-side__item">
                                    <div class="ld-widget-side__label">Free</div>
                                    <div class="ld-widget-side__value">45</div>
                                  </div>
                                  <div class="ld-widget-side__item">
                                    <div class="ld-widget-side__label">Light</div>
                                    <div class="ld-widget-side__value">30</div>
                                  </div>
                                  <div class="ld-widget-side__item">
                                    <div class="ld-widget-side__label">Pro</div>
                                    <div class="ld-widget-side__value">20</div>
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
print'</div></div>';
print '</div></div></div>';
##################################################################################


#print_demo();
print_js();

###############################
print '<script>
$(document).ready(function() {

  if ($(".pages_dashboard").length) {
    var month = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"];
    if ($(".ld-widget-main__chart").length) {
      Morris.Line({
        element: $(".ld-widget-main__chart"),
        data: [
          {d: new Date("2015-01-01").getTime(), a: 15, b: 5, c: 75},
          {d: new Date("2015-02-01").getTime(), a: 60, b: 15, c: 90},
          {d: new Date("2015-03-01").getTime(), a: 30, b: 10, c: 80},
          {d: new Date("2015-04-01").getTime(), a: 50, b: 20, c: 90},
          {d: new Date("2015-05-01").getTime(), a: 35, b: 10, c: 95},
          {d: new Date("2015-06-01").getTime(), a: 90, b: 5, c: 15},
          {d: new Date("2015-07-01").getTime(), a: 35, b: 15, c: 50},
          {d: new Date("2015-08-01").getTime(), a: 50, b: 10, c: 100},
          {d: new Date("2015-09-01").getTime(), a: 30, b: 5, c: 75},
          {d: new Date("2015-10-01").getTime(), a: 95, b: 15, c: 30},
          {d: new Date("2015-11-01").getTime(), a: 30, b: 20, c: 45}
        ],
        xkey: "d",
        ykeys: ["a", "b", "c"],
        dateFormat: function (x) {
          return new Date(x).toDateString();
        },
        xLabelFormat: function (x) {
          return month[new Date(x).getMonth()];
        },
        labels: ["Light", "Pro", "Free"],
        lineColors: ["#ed4949", "#FED42A", "#20c05c", "#1e59d9"],
        pointSize: 0,
        pointStrokeColors: ["#ed4949", "#FED42A", "#20c05c", "#1e59d9"],
        lineWidth: 3,
        resize: true
      });
    }
    if ($(".ld-widget-side__chart").length) {
      Morris.Donut({
        element: $(".ld-widget-side__chart"),
        data: [
          {label: "Light", value: 30},
          {label: "Pro", value: 20},
          {label: "Free", value: 45}
        ],
        colors: ["#ed4949", "#FED42A", "#20c05c", "#1e59d9"],
        backgroundColor: "#30363c",
        labelColor: "#88939C",
        resize: true
      });
    }

    $(".selectpicker").selectpicker();
  }
});
</script>';
###############################
print '</div></body></html>';
$con->disconnect;