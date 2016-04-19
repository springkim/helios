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

my $src_id=$q->param("SRCID");
my $src_path=$q->param("SRCPATH");
my $state=$con->prepare("SELECT count(uip_srcpath) FROM userinfo_problem WHERE ui_id=\'$c_id\' and uip_srcpath='$src_path'");
$state->execute;
my @row=$state->fetchrow_array;
$state->finish;
if(is_admin($c_id)>0){
	$row[0]=1;	
}
if($src_id ne '' and $c_id ne ''and  $src_id eq $c_id and $row[0]==1){

#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print helios_html_head($q,$c_id,'<link rel="stylesheet" href="styles/zenburn.css">
<script src="highlight.pack.js"></script>
<script>hljs.initHighlightingOnLoad();</script>');
print '<body class="framed main-scrollable"><div class="wrapper">';

print_header($c_id);
print '<div class="dashboard">';
print_sidemenu($c_id);
###################################################################################
my $state=$con->prepare("SELECT * FROM userinfo_problem WHERE uip_srcpath=\'$src_path\'");
$state->execute;
my $row=$state->fetchrow_hashref;
$state->finish;
my $status="<strong style=\"color:#cccccc\">Problem Number : </strong>".$row->{pr_optnum}."<br>";
$state=$con->prepare("SELECT * FROM problem WHERE pr_optnum=\'$row->{pr_optnum}\'");
$state->execute;
my $row2=$state->fetchrow_hashref;
$state->finish;
$status.="<strong style=\"color:#cccccc\">Title : </strong>".$row2->{pr_title}."<br>";
$status.="<strong style=\"color:#cccccc\">Level : </strong>".$row2->{pr_level}."<br>";
$status.="<strong style=\"color:#cccccc\">Time Limit : </strong>".$row2->{pr_timelimit}."<br>";
$status.="<strong style=\"color:#cccccc\">Memory Limit : </strong>".$row2->{pr_memlimit}."<br><br>";

$status.="<strong style=\"color:#cccccc\">User : </strong>".$row->{ui_id}."<br>";
$status.="<strong style=\"color:#cccccc\">Language : </strong>".$row->{uip_language}."<br>";
$status.="<strong style=\"color:#cccccc\">Time : </strong>".$row->{uip_time}."<br>";
my $sta=$row->{uip_status};
$sta=~s/\n/<br>/g;
$status.="<strong style=\"color:#cccccc\">Status : </strong>".$sta."<br>";
$status.="<strong style=\"color:#cccccc\">Date : </strong>".$row->{uip_date}."<br>";
open FP,'<',$row->{uip_srcpath};
$/=undef;
my $code=<FP>;
close FP;
$code=~s/</&lt/g;
$code=~s/>/&gt/g;

my $lang=$row->{uip_language};
if($lang eq 'C'){
	$lang='cpp';
}elsif($lang eq 'C++'){
	$lang='cpp';
}elsif($lang eq 'Perl'){
	$lang='perl';
}elsif($lang eq 'Pascal'){
	$lang='ruby';	
}

my $cover='<pre style="background:#30363c;border:0px;padding:0px"><code class="'.$lang.'" style="background:#30363c">'.$code.'</code></pre>';
print <<EOF
<div class="main">
	<div class="main__scroll scrollbar-macosx">
		<div class="main__cont">
			<div class="main-heading">
				<div class="main-title">
					<ol class="breadcrumb">
						<li><a href="submit.pl">Problem / Submit</a></li>
						<li class="active">Detail</li>
					</ol>
				</div>
				<div class="main-filter">
				</div>
			</div>
			<div class="container-fluid half-padding">
				<div class="template template__table_static">
					<div class="row">
					<div class="col-md-4">
                      <div class="panel panel-info">
                         <div class="panel-heading">
                             <h3 class="panel-title">Submit Status</h3>
                         </div>
                         <div class="panel-body">
                             	<strong>$status</strong>
                         </div>
                       </div>
                  </div>
						<div class="col-md-8">
                            <div class="panel panel-info">
                              <div class="panel-heading">
                                <h3 class="panel-title">Code</h3>
                              </div>
                              <div class="panel-body">
                                $cover
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


print '
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
    <script src="libs/morris.js/morris.min.js"></script>
   
});
    ';
###############################

###############################
print '</body></html>';
}else{
	print $q->header(-charset=>"UTF-8");
	say404();	
}
$con->disconnect;