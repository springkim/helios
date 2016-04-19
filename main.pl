#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use Array::Utils qw(:all);

require 'library/aes.pl';	#must be require before info.pl
require 'library/info.pl';
require 'common_html.pl';

sub print_notice(){
	my $notice_href="main.pl";
	my $notice_list='';
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	my $state=$con->prepare("SELECT * FROM notice ORDER BY nt_optnum DESC");
	$state->execute;
	my $i=0;
	while(my $row=$state->fetchrow_hashref){
			my $ntc='<div class="feed-widget__item feed-widget__item_product"><div class="feed-widget__ico"><i class="fa fa-fw"></i></div><div class="feed-widget__info">
			<div class="feed-widget__text"><b><a href="'.$notice_href.'">'.$row->{nt_title}.'</a></b><br>
			'.$row->{nt_content}.'</div><div class="feed-widget__date">'.$row->{nt_date}.'</div></div></div>';
			$notice_list.=$ntc;
			$i++;
			if($i>10){last;}
	}
	my $str='<div class="col-md-5">
                      <div class="panel panel-info">
                        <div class="panel-heading">
                          <h3 class="panel-title">Notice</h3>
                        </div>
                        <div class="feed-widget">
                          <div class="feed-widget__wrap scrollable scrollbar-macosx">
                            <div class="feed-widget__cont">
                              <div class="feed-widget__list">
                                '.$notice_list.'
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>';
                    return $str;
}
sub print_overview(){
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	my $state=$con->prepare("SELECT count(ui_id) FROM userinfo");
	$state->execute;
	my @row=$state->fetchrow_array;
	my $total_user=$row[0];
	$state->finish;
	$state=$con->prepare("SELECT count(*) FROM userlog");
	$state->execute;
	@row=$state->fetchrow_array;
	my $visit=$row[0];
	$state->finish;
	$state=$con->prepare("SELECT count(*) FROM problem");
	$state->execute;
	@row=$state->fetchrow_array;
	my $problem=$row[0];
	$state->finish;
	$state=$con->prepare("SELECT count(*) FROM userinfo_problem");
	$state->execute;
	@row=$state->fetchrow_array;
	my $submited=$row[0];
	$state->finish;
	$state=$con->prepare("SELECT count(DISTINCT pr_optnum) FROM userinfo_problem WHERE uip_status=\'accepted\'");
	$state->execute;
	@row=$state->fetchrow_array;
	my $conquest=0;
	if($problem!=0){
		$conquest=($row[0]/$problem)*100;
	}
	$state->finish;
	my $str='<div class="col-md-3">
                      <div class="panel panel-success">
                        <div class="panel-heading">
                          <h3 class="panel-title">Overview</h3>
                        </div>
                        <div class="panel-body">
                          <div class="ov-widget">
                            <div class="ov-widget__list">
                              <div class="ov-widget__item ov-widget__item_inc">
                                <div class="ov-widget__value">'.$total_user.'</div>
                                <div class="ov-widget__info">
                                  <div class="ov-widget__title">Total users</div>
                                  <div class="ov-widget__item"><i class="fa fa-user" style="float:right"></i></div>
                                </div>
                              </div>
                              <div class="ov-widget__item ov-widget__item_warn">
                                <div class="ov-widget__value">'.$visit.'</div>
                                <div class="ov-widget__info">
                                  <div class="ov-widget__title">Visits</div>
                                  		<div class="ov-widget__item"><i class="fa fa-thumbs-up" style="float:right"></i></div>
                                </div>
                              </div>
                              <div class="ov-widget__item ov-widget__item_dec">
                                <div class="ov-widget__value">'.$problem.'</div>
                                <div class="ov-widget__info">
                                  <div class="ov-widget__title">Problems</div>
                               <div class="ov-widget__item"><i class="fa fa-key" style="float:right"></i></div>
                                </div>
                              </div>
                              
                              <div class="ov-widget__item ov-widget__item_tack">
                                <div class="ov-widget__value">'.$submited.'</div>
                                <div class="ov-widget__info">
                                  <div class="ov-widget__title">Submited</div>
                                  <div class="ov-widget__item"><i class="fa fa-paper-plane" style="float:right"></i></div>
                                </div>
                              </div>
                              
                              <div class="ov-widget__bar"><span>The conquest problem</span>
                                <div class="progress">
                                  <div role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: '.$conquest.'%" class="progress-bar progress-bar-info"></div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>';
                    return $str;
}
sub print_language_graph(){
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	my @languages=("C","C++","Perl","Pascal");
	my $out_str='';
	foreach my $elem(@languages){
		my $state=$con->prepare("SELECT count(ui_id) FROM userinfo_problem WHERE uip_language='$elem'");
		$state->execute;
		my @row=$state->fetchrow_array;
		$out_str.="<div class=\"ld-widget-side__item\">
         <div class=\"ld-widget-side__label\">$elem</div>
         <div class=\"ld-widget-side__value\">$row[0]</div>
         </div>";
		$state->finish;
	}

	my $s='<div class="col-md-9">
              <div class="panel panel-danger">
                 <div class="panel-heading">
                      <h3 class="panel-title">Language rank</h3>
                     </div>
                     <div class="panel-body">
                       <div class="ld-widget">
                            <div class="ld-widget__cont">
                              <div class="ld-widget-main">
                                <div class="ld-widget-main__title">Frequency</div>
                                <div class="ld-widget-main__chart"></div>
                              </div>
                              <div class="ld-widget-side">
                                <div class="ld-widget-side__title">Ratio</div>
                                <div class="ld-widget-side__chart"></div>
                                <div class="ld-widget-side__footer">'.
                                 		$out_str
                                .'</div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>';
                    return $s;
}
sub print_graph_js(){
  my $con = DBI->connect( GetDB(), GetID(), GetPW());
  my $data='';
  my $cdata='';
    my @languages=("C","C++","Perl","Pascal");
    my $area_str='';
	foreach my $idx(0..7){
		my ($lsec,$lmin,$lhour,$mday,$lmon,$lyear,$wday,$yday) = localtime(time() - ((60*60*24)*$idx));
		my $locdate = sprintf("%04s.%02s.%02s",$lyear+1900,$lmon+1,$mday);
		my $locdate2 = sprintf("%04s-%02s-%02s",$lyear+1900,$lmon+1,$mday);
		$area_str.='{ z: new Date("'.$locdate2.'").getTime() ';
		
		my $alp='a';
		foreach my $elem(@languages){
			my $query="SELECT count(*) FROM userinfo_problem WHERE uip_language='$elem' and SUBSTR(uip_date,0,11)<='$locdate'";
			my $state=$con->prepare($query);
			$state->execute;
			my @row=$state->fetchrow_array;
			$area_str.=",$alp : $row[0] ";
			$state->finish;
			$alp++;
		}
	$area_str.='},
	';
	}
	$area_str=substr($area_str,0,length($area_str)-3);
	my $out_str='';
	foreach my $elem(@languages){
		my $state=$con->prepare("SELECT count(ui_id) FROM userinfo_problem WHERE uip_language='$elem'");
		$state->execute;
		my @row=$state->fetchrow_array;
		$out_str.="{label: \"$elem\", value:$row[0]}
		,";
		$state->finish;
	}
	$out_str=substr($out_str,0,length($out_str)-1);
#==============
  my $colors='["#ed4949","#CC723D","#FFE400","#86E57F","#5CD1E5"]';
  my $str= '<script type="text/javascript">$(document).ready(function() {
  if ($(".pages_dashboard").length) {
    
    if ($(".ld-widget-main__chart").length) {
      Morris.Line({
        element: $(".ld-widget-main__chart"),
        data: [
          '.$area_str.'
        ],
        xkey: "z",
        ykeys: ["a", "b", "c","d","e"],
        dateFormat: function (x) {
        	return new Date(x).toDateString();
        },
        xLabelFormat: function (x) {
          return new Date(x).toDateString();
        },
        labels: ["C", "C++", "Perl","Pascal","PHP"],
        lineColors: '.$colors.',
        pointSize: 0,
        pointStrokeColors: '.$colors.',
        lineWidth: 3,
        resize: true
      });
    }
    if ($(".ld-widget-side__chart").length) {
      Morris.Donut({
        element: $(".ld-widget-side__chart"),
        data: [
          '.$out_str.'
        ],
        colors: '.$colors.',
        backgroundColor: "#30363c",
        labelColor: "#88939C",
        resize: true
      });
    }

    $(".selectpicker").selectpicker();
  }
});
</script>';
	print $str;
}
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