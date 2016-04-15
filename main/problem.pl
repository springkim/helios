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
my $show_type=$q->param('show_type');
#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print helios_html_head($q,$c_id);
print '<body class="framed main-scrollable"><div class="wrapper">';

print_header($c_id);
print '<div class="dashboard">';
print_sidemenu($c_id);


print 'SHOW_TYPE: ',$show_type;


###################################################################################
print <<EOF
<div class="main"><div class="main__scroll scrollbar-macosx"><div class="main__cont">
<div class="main-heading"><div class="main-title"><ol class="breadcrumb">
	<li><a href="problem.pl">Problems</a></li>
	<li class="active">All</li>
</ol></div><div class="main-filter">
	<form class="main-filter__search"><div class="input-group">
	<input type="text" placeholder="Search" class="form-control"><span class="input-group-btn">
	<button type="button" class="btn btn-default">
	<div class="fa fa-search"></div>
	</button></span>
	</div>
	</form>
</div></div><div class="container-fluid half-padding"><div class="template template__table_data">
<div class="row"><div class="col-md-12"><div class="panel panel-danger"><div class="panel-heading">
	<h3 class="panel-title">Problem list</h3>
</div>
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
my $query;
if($show_type eq 'all'){
	$query="SELECT * FROM problem ";
}elsif($show_type eq 'easy'){
	$query="SELECT * FROM problem WHERE pr_level=\'easy\'";
}elsif($show_type eq 'normal'){
	$query="SELECT * FROM problem WHERE pr_level=\'normal\'";
}elsif($show_type eq 'hard'){
	$query="SELECT * FROM problem WHERE pr_level=\'hard\'";
}elsif($show_type eq 'crazy'){
	$query="SELECT * FROM problem WHERE pr_level=\'crazy\'";
}elsif($show_type eq 'solve'){
	$query="SELECT * FROM problem,userinfo_problem WHERE problem.pr_path=userinfo_problem.pr_path and uip_status=\'accepted\'";
}elsif($show_type eq 'nonsolve'){
	
}elsif($show_type eq 'algorithm'){
	
}elsif($show_type eq 'datastructure'){
	
}elsif($show_type eq 'try'){
	
}
#        <tr>
#            <td>Tiger Nixon</td>
#            <td>System Architect</td>
#            <td>Edinburgh</td>
#            <td>61</td>
#            <td>2011/04/25</td>
#            <td>$320,800</td>
#        </tr>
 print '</tbody></table></div></div></div></div></div></div></div></div></div></div></div></div>';
##################################################################################
print '</div></div></div>';

#print_demo();

print_js();

print '< <script src="libs/datatables/media/js/jquery.dataTables.min.js"></script>
    <script src="libs/datatables/media/js/dataTables.bootstrap.js"></script>
    <script src="js/template/table_data.js"></script>';
    
print '<script src="libs/morris.js/morris.min.js"></script>';
###############################

###############################
print '</body></html>';
$con->disconnect;