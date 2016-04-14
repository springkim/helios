#!/usr/bin/perl
use strict;
use warnings;
use DBI;
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
'i`m boring';