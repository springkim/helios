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
	my $take=$q->param('TAKE');
	my $uid=$q->param('ID');
	if($take ne '' and $uid ne ''){
		if($take eq 'change'){
			if(is_admin($uid)>0){
				$con->do("DELETE FROM admin WHERE ui_id='$uid'");	
			}else{
				$con->do("INSERT INTO admin VALUES('$uid')");
			}
		}elsif($take eq 'ban'){
				$con->do("DELETE FROM userlog WHERE ui_id='$uid'");
				$con->do("DELETE FROM userinfo_problem WHERE ui_id='$uid'");
				$con->do("DELETE FROM userinfo WHERE ui_id='$uid'");
		}
		$redirect_script='<script type="text/javascript">
			location.replace("admin_user_manage.pl");
			location.href("admin_user_manage.pl");
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
	<li class="active">Erase Notice</li>
</ol></div><div class="main-filter">
	
</div></div><div class="container-fluid half-padding"><div class="template template__table_data">
<div class="row"><div class="col-md-12"><div class="panel panel-danger"><div class="panel-heading">
	<h3 class="panel-title">Notice list</h3>
</div>

<div class="row"><div class="panel-body">
<div role="alert" class="alert alert-success alert-dismissible">
<button type="button" data-dismiss="alert" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button>
<i class="alert-ico fa fa-fw fa-check"></i><strong>Warn!&thinsp;</strong> change class and ban user.
</div>
</div></div>

<div class="panel-body"><div class="container-fluid half-padding"><div id="buttons"></div><table id="example" class="table datatable display table-hover" cellspacing="0" width="100%">
<thead><tr>
	<th>User id</th>
	<th>Name</th>
	<th>E-mail</th>
	<th>comment</th>
	<th>Change class</th>
	<th>Ban</th>
</tr></thead><tfoot><tr>
	<th>User id</th>
	<th>Name</th>
	<th>E-mail</th>
	<th>comment</th>
	<th>Change class</th>
	<th>Ban</th>
</tr></tfoot>
    <tbody>
EOF
;
my $query="SELECT * FROM userinfo WHERE ui_id<>'root'";
my $state=$con->prepare($query);
$state->execute;
while(my $row=$state->fetchrow_hashref){
	my $name=$row->{ui_name};
	my $id=$row->{ui_id};
	my $email=$row->{ui_email};
	my $comment=$row->{ui_comment};
	if(length($comment)>25){
		$comment=substr($comment,0,25);
	}
	my $a_str='';
	my $strong_color='';
	if(is_admin($id)==0){	#normal user
		$a_str='To Admin';
	}else{						#admin
		$a_str='To NormalUser';
		$strong_color='style="color:#6799FF"'
	}
	print "<tr>
	<td><strong $strong_color>$id</strong></td>
	<td>$name</td>
	<td>$email</td>
	<td>$comment</td>
	<td><a href='admin_user_manage.pl?TAKE=change&ID=$id'><strong style=\"color:#86E57F\">$a_str</strong></a></td>
	<td><a href='admin_user_manage.pl?TAKE=ban&ID=$id'><strong style=\"color:#F15F5F\">BAN!!</strong></a></td>
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

###############################
print '</body></html>';
}else{
	print $q->header(-charset=>"UTF-8");
	say404();
}
$con->disconnect;