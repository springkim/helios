#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use Array::Utils qw(:all);

require '../login/aes.pl';	#must be require before info.pl
require '../login/info.pl';
require 'common_html.pl';
sub print_submit_result($){
	my $id=shift;
	my $show_all_href="submit.pl";
	my $msg_cnt='0';
	my $submit_data='';
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	if($id){
		my $state=$con->prepare("SELECT count(*) FROM userinfo_problem WHERE ui_id=\'$id\' and uip_status=\'wait\'");
		$state->execute;
		my @row=$state->fetchrow_array;
		$state->finish;
		$msg_cnt=$row[0];
		$state=$con->prepare("SELECT * FROM userinfo_problem WHERE ui_id=\'$id\' ORDER BY uip_date DESC");
		$state->execute;
		my $i=0;
		while(my $row=$state->fetchrow_hashref){
			my $path=$row->{pr_optnum};
			my $state2=$con->prepare("SELECT pr_title FROM problem WHERE pr_optnum=\'$path\'");
			$state2->execute;
			my @row2=$state2->fetchrow_array;
			my $problem=$row2[0];
			my $date=$row->{uip_date};
			my $text=$row->{uip_status};
			if($text=~/^compile error/){
				$text="compile error";
			}
			$submit_data.="<div class=\"sp-widget__item\">
                                  <div class=\"sp-widget__user\">
                                  <a href=\"#\"><strong>$problem</strong></a>
                                  <span class=\"sp-widget__date\">[$date]</span></div>
                                  <div class=\"sp-widget__text\">$text</div>
                                </div>";
				$i++;
				if($i==10){last;}
		}
		$state->finish;
	}else{
		$show_all_href='#';	
	}
	my $str=' <div class="col-md-4">
                      <div class="panel panel-danger">
                        <div class="panel-heading panel-heading_label">
                          <h3 class="panel-title">Submit result</h3>
                          <div class="label label-danger">'.$msg_cnt.'</div>
                        </div>
                        <div class="sp-widget">
                          <div class="sp-widget__wrap scrollable scrollbar-macosx">
                            <div class="sp-widget__cont">
                              <div class="sp-widget__top">
                                <div class="sp-widget__info">
                                  <div class="sp-widget__title"><i class="fa fa-envelope-o"></i><span>'.$msg_cnt.' Receved</span></div>
                                </div>
                                <div class="sp-widget__all"><a href="'.$show_all_href.'" class="btn btn-default btn-block">Show All</a></div>
                              </div>
                              <div class="sp-widget__list">
                                '.$submit_data.'
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>';
                    return $str;
}
sub print_notice(){
	my $notice_href="main.pl";
	my $notice_list='';
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	my $state=$con->prepare("SELECT * FROM notice ORDER BY nt_optday DESC");
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
	my $state=$con->prepare("SELECT ls_optday FROM language_status ORDER BY ls_optday DESC");
	$state->execute;
	my @row=$state->fetchrow_array;
	$state->finish;
	$state=$con->prepare("SELECT ls_language FROM language_status WHERE ls_optday=$row[0]");
	$state->execute;
	@row=$state->fetchrow_array;
	$state->finish;
	my @language_stat=split /;/,$row[0];
	my $out_str;
	foreach my $str(@language_stat){
		my @tmp_arr=split / /,$str;
		 $out_str.="<div class=\"ld-widget-side__item\">
         <div class=\"ld-widget-side__label\">$tmp_arr[0]</div>
         <div class=\"ld-widget-side__value\">$tmp_arr[1]</div>
         </div>";
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
  my $state=$con->prepare("SELECT ls_date,ls_language FROM language_status ORDER BY ls_optday DESC");
  $state->execute;
  my $date_str='';
  my $data='';
  my $i=0;
  while(my @row=$state->fetchrow_array){
  	$date_str='"'.$row[0].'",'.$date_str;
  	my $tmp="{z: new Date(\"$row[0]\").getTime(), ";# a: 15, b: 5, c: 75},";
  	my @tmp_arr=split /;/,$row[1];
  	my @alpha=('a'..'y');
  	foreach my $i(0..$#tmp_arr){
  		my @subtmp=split / /,$tmp_arr[$i];
  		$tmp.=	"$alpha[$i]: $subtmp[1], ";
  	}
  	$tmp=substr($tmp,0,length($tmp)-2);
  	$tmp.="},\n";
  	$data=$tmp.$data;
  	$i++;
  	if($i>=30){last;}
  }
  $data=substr($data,0,length($data)-2);
  $date_str='var month =['.$date_str;
  $date_str=substr($date_str,0,length($date_str)-1);
  $date_str.='];';
  $state->finish;
  my $colors='["#ed4949","#CC723D","#FFE400","#86E57F","#5CD1E5"]';
	#===============
	$state=$con->prepare("SELECT ls_optday FROM language_status ORDER BY ls_optday DESC");
	$state->execute;
	my @row=$state->fetchrow_array;
	$state->finish;
	$state=$con->prepare("SELECT ls_language FROM language_status WHERE ls_optday=$row[0]");
	$state->execute;
	@row=$state->fetchrow_array;
	$state->finish;
	my @language_stat=split /;/,$row[0];
	my $cdata;
	foreach my $str(@language_stat){
		my @tmp_arr=split / /,$str;
		$cdata.=" {label: \"$tmp_arr[0]\", value: $tmp_arr[1]},"
	}
	$cdata=substr($cdata,0,length($cdata)-1);
	#==============
  my $str= '<script type="text/javascript">$(document).ready(function() {
  if ($(".pages_dashboard").length) {'.$date_str.'
    
    if ($(".ld-widget-main__chart").length) {
      Morris.Line({
        element: $(".ld-widget-main__chart"),
        data: [
          '.$data.'
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
          '.$cdata.'
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