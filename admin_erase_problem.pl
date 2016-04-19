#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use File::Copy qw(copy);

require 'library/aes.pl';	#must be require before info.pl
require 'library/info.pl';
require 'common_html.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );

my $c_id=GetCookieId($q);
my $redirect_script='';
if(is_admin($c_id)==2){
	my $pnum=$q->param('PNUM');
	if($pnum ne ''){
		my $state=$con->prepare("SELECT pr_group,pr_title FROM problem WHERE pr_optnum='$pnum'");
		$state->execute;
		my $row=$state->fetchrow_hashref;
		$state->finish;
		my $title=$row->{pr_title};
		$title=~s/ /\\ /g;
		system "rm -r problem_repository/$row->{pr_group}/$title";
		$con->do("DELETE FROM userinfo_problem WHERE pr_optnum='$pnum'");
		$con->do("DELETE FROM problem WHERE pr_optnum='$pnum'");
		$redirect_script='<script type="text/javascript">
			location.replace("admin_erase_problem.pl");
			location.href("admin_erase_problem.pl");
			history.go(-1);
			location.reload();
		</script>';
		
	}
#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print helios_html_head($q,$c_id,$redirect_script);
print '<body class="framed main-scrollable"><div class="wrapper">';


print_header($c_id);
print '<div class="dashboard">';
print_sidemenu($c_id);
	
###################################################################################

print <<EOF
<div class="main"><div class="main__scroll scrollbar-macosx"><div class="main__cont">
<div class="main-heading"><div class="main-title"><ol class="breadcrumb">
	<li><a href="problem_list.pl?show_type=all">SuperAdmin</a></li>
	<li class="active">Erase Problem</li>
</ol></div><div class="main-filter">
	
</div></div><div class="container-fluid half-padding"><div class="template template__table_data">
<div class="row"><div class="col-md-12"><div class="panel panel-danger"><div class="panel-heading">
	<h3 class="panel-title">Problem list</h3>
</div>

<div class="row"><div class="panel-body">
<div role="alert" class="alert alert-success alert-dismissible">
<button type="button" data-dismiss="alert" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button>
<i class="alert-ico fa fa-fw fa-check"></i><strong>Warn!&thinsp;</strong> if you click problem title, then problem is deleted.
</div>
</div></div>

<div class="panel-body"><div class="container-fluid half-padding"><div id="buttons"></div><table id="example" class="table datatable display table-hover" cellspacing="0" width="100%">
<thead><tr>
	<th>Number</th>
	<th>Title</th>
	<th>level</th>
	<th>Try</th>
	<th>Success</th>
	<th>Rate</th>
</tr></thead><tfoot><tr>
	<th>Number</th>
	<th>Title</th>
	<th>level</th>
	<th>Try</th>
	<th>Success</th>
	<th>Rate</th>
</tr></tfoot>
    <tbody>
EOF
;
my $query="SELECT * FROM problem ";
my $state=$con->prepare($query);
$state->execute;
while(my $row=$state->fetchrow_hashref){
	my $num=$row->{pr_optnum};
	my $title=$row->{pr_title};
	my $level=$row->{pr_level};
	my $state2=$con->prepare("SELECT count(DISTINCT ui_id) FROM userinfo_problem WHERE pr_optnum=\'$num\'");
	$state2->execute;
	my @row=$state2->fetchrow_array;
	$state2->finish;
	my $try=$row[0];
	$state2=$con->prepare("SELECT count(DISTINCT ui_id) FROM userinfo_problem WHERE pr_optnum=\'$num\' and uip_status=\'accepted\'");
	$state2->execute;
	@row=$state2->fetchrow_array;
	$state2->finish;
	my $success=$row[0];
	my $rate='0%';
	if($try!=0){
		$rate=($success/$try)*100;
		$rate.='%';
	}
	print "<tr>
	<td>$num</td>
	<td><a href='admin_erase_problem.pl?PNUM=$num'><strong style=\"color:#F361DC;\">$title</strong></a></td>
	<td>$level</td>
	<td>$try</td>
	<td>$success</td>
	<td>$rate</td>
	</tr>";	
}
 print '</tbody></table></div></div></div></div></div></div></div></div></div></div></div></div>';
##################################################################################
print '</div></div></div>';

#print_demo();

#print_js();
#print_graph_js();
print '<script src="libs/jquery/jquery.min.js"></script>
    <script src="libs/bootstrap/js/bootstrap.min.js"></script>
    <script src="libs/jquery.scrollbar/jquery.scrollbar.min.js"></script>
    <script src="libs/bootstrap-tabdrop/bootstrap-tabdrop.min.js"></script>
    <script src="libs/sparkline/jquery.sparkline.min.js"></script>
    <script src="libs/ionrangeslider/js/ion.rangeSlider.min.js"></script>
    <script src="libs/inputNumber/js/inputNumber.js"></script>
    <script src="libs/bootstrap-switch/dist/js/bootstrap-switch.min.js"></script>
    <script src="libs/selectize/dist/js/standalone/selectize.min.js"></script>
    <script src="libs/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
    <script src="libs/bootstrap-timepicker/js/bootstrap-timepicker.min.js"></script>
    <script src="libs/bootstrap-tabdrop/bootstrap-tabdrop.min.js"></script>
    <script src="libs/bootstrap-select/dist/js/bootstrap-select.min.js"></script>
    <script src="js/template/controls.js"></script>
    <script src="js/main.js"></script>
    <script src="js/demo.js"></script>';
     print '<script src="libs/datatables/media/js/jquery.dataTables.min.js"></script>
    <script src="libs/datatables/media/js/dataTables.bootstrap.js"></script>
    <script src="js/template/table_data.js"></script>';
###############################
print '
<script>
$(document).ready(function(){
	$("#submit").click(function(){
		
	})
	$("#inputfile").click(function(){
		$("#inputfile3").click();
		return false;
	})
	$("#inputfile3").change(function(){
		$("#inputfile2").val($("#inputfile3").val());
	})
	$("#outputfile").click(function(){
		$("#outputfile3").click();
		return false;
	})
	$("#outputfile3").change(function(){
		$("#outputfile2").val($("#outputfile3").val());
	})
	$("#stype").change(function(){
		if($("#stype").val()=="acm"){
			$("#MFILE").css("display","none");
		}else if($("#stype").val()=="topcoder"){
			$("#MFILE").css("display","block");
		}
	})
	$("#mfile").click(function(){
		$("#mfile3").click();
		return false;
	})
	$("#mfile3").change(function(){
		$("#mfile2").val($("#mfile3").val());
	})
});
</script>';
###############################
print '</body></html>';
}else{
	print $q->header(-charset=>"UTF-8");
	say404();
}
$con->disconnect;