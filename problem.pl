#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

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
my $pnum=$q->param('PNUM');
if($pnum eq ''){
	print $q->redirect('main.pl');	
}
my $state=$con->prepare("SELECT * FROM problem WHERE pr_optnum=\'$pnum\'");
$state->execute;
my $row=$state->fetchrow_hashref;
$state->finish;
my $content=$row->{pr_content};
my $ptype=$row->{pr_type};
my $tl=$row->{pr_timelimit};
my $ml=$row->{pr_memlimit};
my $combo='';
if($ptype eq 'acm'){
	$combo.='<option>C++</option><option>Perl</option><option>Pascal</option>';	
}
#############################################
my $submit_block='';
my $jquery='';
$state=$con->prepare("SELECT count(ui_id) FROM nonemail_certification WHERE ui_id=\'$c_id\'");
$state->execute;
my @c_email=$state->fetchrow_array;
$state->finish;
if($c_id ne ''){
	if($c_email[0]==0){
$submit_block='<div class="col-md-12">
                      <div class="panel panel-danger">
                        <div class="panel-heading">
                          <h3 class="panel-title">Submit</h3>
                        </div>
                        <div class="panel-body">
                          <div class="form-horizontal" >
                             <div class="form-group">
                              <label class="col-sm-2 control-label">Language</label>
                              <div class="col-sm-10">
                                <select placeholder="Select" id="lang" name="lang" class="selectpicker form-control">
                                  		<option>C</option>
                                  			'.$combo.'
                                </select>
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Source file</label>
                              <div class="col-sm-10">
                                <button type="submit" id="sourcefile" class="btn btn-default">Upload source file</button>
                                <input type="text" readonly="readonly" id="sourcefile2" name="sourcefile2" placeholder="--" class="form-control">
                                <input type="file" style="display:none" id="sourcefile3" name="SFILE" ></input>
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Create</label>
                              <div class="col-sm-10">
                              	  <input type="hidden" id="PNUM" name="PNUM" value="'.$pnum.'"></input>
                                 <button type="submit" id="submit" class="btn btn-default">Insert new problem</button>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>';
$jquery='<script>
$(document).ready(function(){
	$("#sourcefile").click(function(){
		$("#sourcefile3").click();
		return false;
	})
	$("#sourcefile3").change(function(){
		$("#sourcefile2").val($("#sourcefile3").val());
	})
	$("#submit").click(function(){

	})
})
</script>';
	}else{
			$submit_block='<div class="col-md-8">
                            <div class="panel panel-warning">
                              <div class="panel-heading">
                                <h3 class="panel-title">Please certify your e-mail</h3>
                              </div>
                              <div class="panel-body">
                                <p>
                                	이메일 인증은 대시보드 좌측 메뉴의 User에서 인증 받을수 있습니다.<br>
                                	인증을 하지 않으면 문제를 풀 수 없습니다.
                                </p>
                              </div>
                            </div>
                          </div>
                        </div>';
	}
}
###########RANKING#####################
my $rank='';
$state=$con->prepare("SELECT ui_id,uip_time,uip_language FROM userinfo_problem WHERE pr_optnum=\'$pnum\' and uip_status=\'accepted\' ORDER BY uip_time");
$state->execute;
my @ids;
my @times;
my @langs;
my $cnt=0;
while(my $row=$state->fetchrow_hashref){
	my $overlap=0;
	foreach my $elem(@ids){
		if($row->{ui_id} eq $elem){
			$overlap=1;
			last;	
		}	
	}
	if($overlap==0){
		push @ids,$row->{ui_id};
		push @times,$row->{uip_time};
		push @langs,$row->{uip_language};
		$cnt++;
		if($cnt==10){last;}
	}
}
foreach my $i(0..9){
	if($i<=$#ids){
	$rank.="<tr>
	<td><strong style=\"color:#B2EBF4\">$ids[$i]<strong></td>
	<td>$times[$i]</td>
	<td>$langs[$i]</td>
	</tr>";
	}else{
		$rank.="<tr>
	<td><strong style=\"color:#B2EBF4\">---<strong></td>
	<td>---</td>
	<td>---</td>
	</tr>";
	}
}
$state->finish;
#############################################
$content=~s/'/"/g;
print <<EOF
<div class="main">
          <div class="main__scroll scrollbar-macosx">
          	<form method="post" action="submit.pl" ENCTYPE="multipart/form-data">
            <div class="main__cont">
              <div class="main-heading">
                <div class="main-title">
                  <ol class="breadcrumb">
                    <li class="active">Problem [$pnum]</li>
                  </ol>
                </div>
              </div>
              <div class="container-fluid half-padding">
                <div class="pages pages_dashboard">
                  <div class="row">
                  	<div class="col-md-8">
                  		<div class="panel panel-danger" >
	                  		<div class="panel-heading">
	                          <h3 class="panel-title">Time Limit: [$tl], Memory Limit: [$ml]</h3>
	                        </div>
	                        <div class="panel-body" style="color:#eeeeee">
	                        	<style>mark{border-radius:5px;}</style>
                   				$content
                   			</div>
                   		</div>
                   	</div>
                   	
                   	 <div class="col-md-4">
                      <div class="panel panel-danger">
                        <div class="panel-heading">
                          <h3 class="panel-title">Ranking</h3>
                        </div>
                        <div class="panel-body">
                          <div class="template__table_static template__table_responsive">
                            <div class="scrollable scrollbar-macosx"><table id="" class="table table_sortable {sortlist: [[0,0]]}" cellspacing="0" width="100%">
    <thead>
        <tr>
            <th>Username</th>
            <th>Time</th>
            <th>Language</th>
        </tr>
    </thead>
    <tfoot>
        <tr>
            <th>Username</th>
            <th>Time</th>
            <th>Language</th>
        </tr>
    </tfoot>
    <tbody>
        $rank
    </tbody>
</table>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                   	
                   	
                  </div>
                  <div class="row">
                    	$submit_block
                  </div>
                </div>
              </div>
            </div></form>
          </div>
        </div>
EOF
;
##################################################################################
print '</div></div></div>';

 
print_js();
print $jquery;

print '<script src="libs/morris.js/morris.min.js"></script>';
###############################

###############################
print '</body></html>';
$con->disconnect;