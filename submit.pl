#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use File::Copy qw(copy);
use Array::Utils qw(:all);

require 'library/aes.pl';	#must be require before info.pl
require 'library/info.pl';
require 'common_html.pl';

my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $c_id=GetCookieId($q);

my $pnum=$q->param("PNUM");
my $language=$q->param("lang");
my $src_file=$q->param("SFILE");


if($pnum ne '' and $language ne ''and  $src_file ne ''){
	my $date=GetLocalTime();
	$src_file =~ m<.+\.(\w+)?$>;    #확장자를 추출합니다.
	my $filename="$c_id-$date.$1";
	$filename=~s/ //g;
	copy($src_file,"user_source/$filename");
	my $state=$con->prepare("SELECT * FROM problem WHERE pr_optnum=\'$pnum\'");
	$state->execute;
	my $row=$state->fetchrow_hashref;
	$state->finish;
	my $query="INSERT INTO userinfo_problem VALUES($pnum,\'$c_id\',\'$language\',\'0\',\'wait\',\'$date\',\'user_source/$filename\')";
	#print FP $pnum," ",$language," ",$src_file,"\n",$query;
	$con->do($query);
}
#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print helios_html_head($q,$c_id);
print '<body class="framed main-scrollable"><div class="wrapper">';

print_header($c_id);
print '<div class="dashboard">';
print_sidemenu($c_id);
###################################################################################
print <<EOF
<div class="main"><div class="main__scroll scrollbar-macosx"><div class="main__cont"><div class="main-heading">
<div class="main-title"><ol class="breadcrumb">
	<li><a href="problem_list.pl?show_type=all">Problem</a></li>
	<li class="active">Submits</li>
</ol></div><div class="main-filter"></div></div><div class="container-fluid half-padding"><div class="template template__table_static">
<div class="row"><div class="col-md-12"><div class="panel panel-danger"><div class="panel-heading">
	<h3 class="panel-title">Submit Status</h3>
</div><div class="panel-body">
<div class="scrollable scrollbar-macosx"><table id="" class="table table_sortable {sortlist: [[0,0]]}" cellspacing="0" width="100%">
    <thead>
        <tr>
            <th>Number</th>
            <th>Title</th>
            <th>Language</th>
            <th>Status</th>
            <th>Time</th>
            <th>Date</th>
        </tr>
    </thead>
    <tfoot>
        <tr>
            <th>Number</th>
            <th>Title</th>
            <th>Language</th>
            <th>Status</th>
            <th>Time</th>
            <th>Date</th>
        </tr>
    </tfoot>
    <tbody>
EOF
;
my $state=$con->prepare("SELECT * FROM userinfo_problem WHERE ui_id=\'$c_id\' ORDER BY uip_date DESC");
$state->execute;
while(my $row=$state->fetchrow_hashref){
	my $num=$row->{pr_optnum};
	my $state2=$con->prepare("SELECT pr_title FROM problem WHERE pr_optnum=\'$row->{pr_optnum}\'");
	$state2->execute;
	my @row=$state2->fetchrow_array;
	my $title=$row[0];
	my $language=$row->{uip_language};
	my $status=$row->{uip_status};
	my $time=$row->{uip_time};
	my $date=$row->{uip_date};
	my $srcpath=$row->{uip_srcpath};
	my $color="#ffffff";
	if($status eq 'accepted'){
		$color='#6799FF';	
	}elsif($status eq 'wrong answer'){
		$color='#F15F5F';
	}elsif($status=~/^compile error/){
		$status="compile error";
		$color='#F29661';
	}elsif($status eq 'time limit'){
		$color='#F2CB61';
	}elsif($status eq 'memory limit'){
		$color='#BCE55C';	
	}elsif($status eq 'runtime error'){
		$color='#D9418C';	
	}elsif($status eq 'unable function use'){
		$color='#FFA7A7';	
	}
	print "<tr>
	<td>$num</td>
	<td><a href='problem.pl?PNUM=$num'><strong style=\"color:#eeeeee\">$title</strong></a></td>
	<td>$language</td>
	<td><a href='submit_detail.pl?SRCID=$c_id&SRCPATH=$srcpath'><strong style=\"color:$color\">$status</strong></a></td>
	<td>$time</td>
	<td>$date</td>
	</tr>";	
}

print <<EOF
    </tbody>
</table>
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
print '</div></div></div>';


print '<script src="libs/morris.js/morris.min.js"></script>
<script src="libs/jquery/jquery.min.js"></script>
    <script src="libs/bootstrap/js/bootstrap.min.js"></script>
    <script src="libs/jquery.scrollbar/jquery.scrollbar.min.js"></script>
    <script src="libs/bootstrap-tabdrop/bootstrap-tabdrop.min.js"></script>
    <script src="libs/sparkline/jquery.sparkline.min.js"></script>
    <script src="libs/ionrangeslider/js/ion.rangeSlider.min.js"></script>
    <script src="libs/inputNumber/js/inputNumber.js"></script>
    <script src="libs/bootstrap-switch/dist/js/bootstrap-switch.min.js"></script>
    <script src="libs/tablesorter/jquery.metadata.js"></script>
    <script src="libs/tablesorter/jquery.tablesorter.min.js"></script>
    <script src="js/template/table_sortable.js"></script>
    <script src="js/main.js"></script>
    <script src="js/demo.js"></script>
    <script>
		history.pushState(null,null,location.href);
		window.onpopstate = function(event){
			history.go(1);	
		}
	</script>';
###############################

###############################
print '</body></html>';
$con->disconnect;