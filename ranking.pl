#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use Array::Utils qw(:all);

require 'library/aes.pl';	#must be require before info.pl
require 'library/info.pl';
require 'common_html.pl';

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
    <thead><tr>
    <th>rank</th>
	<th>id</th>
	<th>Name</th>
	<th>Elo Rating</th>
	<th>Comment</th>
</tr></thead><tfoot><tr>
<th>rank</th>
	<th>id</th>
	<th>Name</th>
	<th>Elo Rating</th>
	<th>Comment</th>
</tr></tfoot>
    <tbody>
EOF
;
my $query="SELECT * FROM userinfo";
my $state=$con->prepare($query);
$state->execute;
my @array;
my $i=0;
while(my $row=$state->fetchrow_hashref){
	my $id=$row->{ui_id};
	my $name=$row->{ui_name};
	my $comment=$row->{ui_comment};
	my $hard_solve;
	my $normal_solve;
	my $easy_solve;
	my $crazy_solve;
	my $elo;
	my @row;
	my $state2=$con->prepare("SELECT count(DISTINCT problem.pr_optnum) FROM userinfo_problem NATURAL JOIN problem WHERE ui_id=\'$id\' and pr_level='easy' and uip_status='accepted'");
	$state2->execute;
	@row=$state2->fetchrow_array;
	$easy_solve=$row[0];
	$state2->finish;
	$state2=$con->prepare("SELECT count(DISTINCT problem.pr_optnum) FROM userinfo_problem NATURAL JOIN problem WHERE ui_id=\'$id\' and pr_level='normal' and uip_status='accepted'");
	$state2->execute;
	@row=$state2->fetchrow_array;
	$normal_solve=$row[0];
	$state2->finish;
	$state2=$con->prepare("SELECT count(DISTINCT problem.pr_optnum) FROM userinfo_problem NATURAL JOIN problem WHERE ui_id=\'$id\' and pr_level='hard' and uip_status='accepted'");
	$state2->execute;
	@row=$state2->fetchrow_array;
	$hard_solve=$row[0];
	$state2->finish;
	$state2=$con->prepare("SELECT count(DISTINCT problem.pr_optnum) FROM userinfo_problem NATURAL JOIN problem WHERE ui_id=\'$id\' and pr_level='crazy' and uip_status='accepted'");
	$state2->execute;
	@row=$state2->fetchrow_array;
	$crazy_solve=$row[0];
	$elo=($easy_solve*100)+($normal_solve*150)+($hard_solve*300)+($crazy_solve*200);
	push @array,"$elo;$id;$name;$comment";
	$i++;
	if($i==99){
		last;	
	}
}
$state->finish;
@array=sort {$b <=> $a} @array;
foreach my $i(1..$#array+1){
	my ($elo,$id,$name,$comment)=split /;/,$array[$i-1];
	print "<tr>
	<td>$i</td>
	<td>$id</td>
	<td>$name</td>
	<td>$elo</td>
	<td>$comment</td>
	</tr>";
}


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