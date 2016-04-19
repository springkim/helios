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
	my $str=' <div class="col-md-5">
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

my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $c_id=GetCookieId($q);
if($c_id eq ''){
	print $q->redirect('main.pl');
}
#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");

print helios_html_head($q,$c_id,'
<script src="login/sha/sha3.js"></script>
<script src="login/sha/pbkdf2.js"></script>

');
print '<body class="framed main-scrollable"><div class="wrapper">';

print_header($c_id);
print '<div class="dashboard">';
print_sidemenu($c_id);
###################################################################################
my $email_confirm='';
my $name='';
my $email;
my $id;
my $comment;
my $salt1;
#############
my $state=$con->prepare("SELECT * FROM userinfo WHERE ui_id=\'$c_id\'");
$state->execute;
my $row=$state->fetchrow_hashref;
$state->finish;
$name=$row->{ui_name};
$email=$row->{ui_email};
$id=$row->{ui_id};
$salt1=$row->{ui_salt1};
$comment=$row->{ui_comment};
$state=$con->prepare("SELECT count(*) FROM nonemail_certification WHERE ui_id=\'$c_id\'");
$state->execute;
my @row=$state->fetchrow_array;
$state->finish;
$email_confirm=$row[0];
if($email_confirm==1){
	$email_confirm='<div id="emailbtn" style="display:inline"><button type="button" class="btn btn-danger" id="email_confirm" style="margin:5px;">E-mail Confirm</button></div>';
}else{
	$email_confirm='';
}
my $c_confirm='';
if(is_email_confirm($id)==1){
		$c_confirm='<strong style="color:#6799FF">(OK)</strong>';
}else{
	$c_confirm='<strong style="color:#F15F5F">(non OK)</strong>';
}

my @level_percent=(0,0,0,0);
my @level_name=("easy","normal","hard","crazy");
foreach my $i(0..$#level_name){
		$state=$con->prepare("SELECT count(DISTINCT problem.pr_optnum) FROM userinfo_problem NATURAL JOIN problem WHERE ui_id='$c_id' AND uip_status='accepted' AND pr_level='$level_name[$i]'");
		$state->execute;
		my @row=$state->fetchrow_array;
		my $solve=$row[0];
		$state->finish;
		
		$state=$con->prepare("SELECT count(pr_optnum) FROM problem WHERE pr_level='$level_name[$i]'");
		$state->execute;
		@row=$state->fetchrow_array;
		my $total=$row[0];
		$state->finish;
		
		$level_percent[$i]='0%';
		if($total!=0){
			$level_percent[$i]=($solve/$total)*100;
			$level_percent[$i].='%';
		}
}
my $submit_result=print_submit_result($c_id);
print <<EOF
<div class="main">
          <div class="main__scroll scrollbar-macosx">
            <div class="main__cont">
              <div class="main-heading">
                <div class="main-title">
                  <ol class="breadcrumb">
                    <li><a href="main.pl">Main</a></li>
                    <li class="active">Users</li>
                  </ol>
                </div>
                <div class="main-filter">
                </div>
              </div>
              <div class="container-fluid half-padding">
                <div class="datalist page page_users users float-left">
                  <div class="row">
                    <div class="col-md-6">
                      <div class="panel panel-danger">
                        <div class="users-preview__cont">
                          <div title="Name" class="users-preview__name">$id</div>
                          <div class="users-preview__data">
                            <div class="users-preview__photo">
                              <div style=""></div>
                            </div>
                          </div>
                          			<button type="button" class="btn btn-info" id="passwd_mbtn" style="margin:5px;">Password Modify</button>
                          			<button type="button" class="btn btn-info" id="email_mbtn" style="margin:5px;">E-mail Modify</button>
                                  <button type="button" class="btn btn-info" id="comment_mbtn" style="margin:5px;">Comment Midify</button>
                                  $email_confirm
                          <div class="users-preview__props" style="margin-top:5px">
                            <div class="users-preview__prop">
                            	<i class="fa fa-info"></i><span class="users-preview__date"><strong>id : </strong>$id</span>
                            </div>
                            <div class="users-preview__prop">
                            	<i class="fa fa-info"></i><span class="users-preview__date"><strong>Name : </strong>$name</span>
                            </div>
								<div title="Contact" class="users-preview__prop"><i class="fa fa-envelope"></i><span class="users-preview__contact"><strong>E-mail : </strong>$email$c_confirm</span></div>
								                 
                            <div class="users-preview__prop">
                            	<i class="fa fa-heartbeat"></i><span class="users-preview__status"><strong>Comment : </strong>$comment</span>
                            </div>
                            
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <div id="email_modify" class="col-md-6" style="display:none">
                      <div class="panel panel-warning">
                        <div class="panel-heading">
                          <h3 class="panel-title">E-Mail Modify</h3>
                        </div>
                        <div class="panel-body">
                          <div class="form-horizontal">
                            <div class="form-group">
                            <div class="row"><div class="panel-body">
	                            <div role="alert" class="alert alert-warning alert-dismissible">
	                            <button type="button" data-dismiss="alert" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button><i class="alert-ico fa fa-fw fa-check"></i><strong>Warn!&thinsp;</strong>if modify email, you will confirm email again.
	                          	</div>
                            </div></div>
                              <label class="col-sm-2 control-label">E-Mail</label>
                              <div class="col-sm-10">
                                <input id="email_val" type="email" placeholder="$email" class="form-control">
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Modify</label>
                              <div class="col-sm-10">
                                <button id="email_sbtn" type="submit" class="btn btn-default">Modify Button</button>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <div id="comment_modify" class="col-md-6" style="display:none">
                      <div class="panel panel-success">
                        <div class="panel-heading">
                          <h3 class="panel-title">Comment Modify</h3>
                        </div>
                        <div class="panel-body">
                          <div class="form-horizontal">
                            <div class="form-group">
                            
                              <label class="col-sm-2 control-label">Comment</label>
                              <div class="col-sm-10">
                                <input id="comment_val" type="email" placeholder="$comment" class="form-control" maxlength="64">
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Modify</label>
                              <div class="col-sm-10">
                                <button id="comment_sbtn" type="submit" class="btn btn-default">Modify Button</button>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    	<div id="passwd_modify" class="col-md-6" style="display:none">
                      <div class="panel panel-danger">
                        <div class="panel-heading">
                          <h3 class="panel-title">Password Modify</h3>
                        </div>
                        <div class="panel-body">
                          <div class="form-horizontal">
                            <div class="form-group">
                            <div class="row"><div class="panel-body">
	                            <div role="alert" class="alert alert-danger alert-dismissible">
	                            <button type="button" data-dismiss="alert" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button><i class="alert-ico fa fa-fw fa-check"></i><strong>Warn!&thinsp;</strong>password is allow digits[0~9], alphabet[a~z,A~Z], underbar[_] only.
	                          	</div>
                            </div></div>
                             <div class="row"><div class="col-md-12">
                              <label class="col-sm-2 control-label">Current password</label>
                              <div class="col-sm-10" style="margin-bottom:10px">
                                <input id="cpasswd_val" type="password"  class="form-control">
                              </div></div>
                              </div>
                              	<div class="row"><div class="col-md-12">	
                              <label class="col-sm-2 control-label">New password</label>
                              <div class="col-sm-10" style="margin-bottom:10px">
                                <input id="passwd_val" type="password"  class="form-control">
                              </div>
                              </div></div>
                              <div class="row"><div class="col-md-12">	
                              <label class="col-sm-2 control-label">Confirm password</label>
                              <div class="col-sm-10">
                                <input id="fpasswd_val" type="password"  class="form-control">
                              </div>
                               </div></div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Modify</label>
                              <div class="col-sm-10">
                                <button id="passwd_sbtn" type="submit" class="btn btn-default">Modify Button</button>
                              </div>
                            </div>
                            	<input type="hidden" id="CPW" name="CPW">
                            	<input type="hidden" id="NPW" name="NPW">
                            	<input type="hidden" id="SALT1" name="SALT1">
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <div class="template template__modals" style="display:none"><div class="template__modal" style="display:none">                      
                             <button id="ERRORMSG" type="button" data-toggle="modal" data-target="#modal1" class="btn btn-info" style="float:right">Check</button>
                    </div></div>
                    	<div id="modal1" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header">
					    <button type="button" data-dismiss="modal" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button>
					    <h4 class="modal-title" id="ERRMSG_TITLE">TEMPLATE</h4></div>
					    <div class="modal-body">
					    <div role="alert" class="alert alert-danger" id="ERRMSG_DIALOG_COLOR">
					    <h4><i class="alert-ico fa fa-fw fa-ban" id="ERRMSG_DIALOG"></i><strong id="ERRMSG_SUBTITLE"><strong>Fail</strong></strong></h4>
					    <strong id="ERRMSG_COMMENT"><h5>Hello, World</h5></strong>
					    </div>
					    </div>
					    <div class="modal-footer">
					    <button type="button" data-dismiss="modal" class="btn btn-default">Close</button>
					    </div></div></div></div>
                  </div>
                  
                <div class="container-fluid half-padding">
                <div class="template template__charts">
                  <div class="row">
                  	<div class="col-md-12" style="padding:0px">
                      <div class="panel panel-danger">
                        <div class="panel-heading">
                          <h3 class="panel-title">Graphs</h3>
                        </div>
                        <div class="panel-body">
                          <div class="template__morris">
                            <div class="container-fluid half-padding">
                              <div class="row">
                                <div class="col-md-8">
                                  <div class="chart">
                                    <div class="chart__tabs">
                                      <ul role="tablist" class="nav nav-tabs">
                                        
                                      </ul>
                                    </div>
                                    <div class="chart__cont">
                                      <div id="area" class="tab-pane active">
                                        <div class="chart__title">Area Chart</div>
                                        <div data-chart="morris-area" class="chart__chart"></div>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                                <div class="col-md-4">
                                  <div class="chart">
                                    <div class="chart__tabs">
                                      <ul role="tablist" class="nav nav-tabs">
                                        
                                      </ul>
                                    </div>
                                    <div class="chart__cont">
                                      <div id="donut" class="tab-pane active">
                                        <div class="chart__title">Submit Status</div>
                                        <div data-chart="morris-donut" class="chart__chart"></div>
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
                  </div></div></div>
                  	
                  <div class="row"><div class="col-md-7">
                  	<div class="panel panel-danger">
                        <div class="panel-heading">
                          <h3 class="panel-title">Percent</h3>
                        </div>
                        <div class="panel-body">
                        	 <span><strong>Easy</strong></span>
                       	 <div class="progress">
                            <div role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: $level_percent[0]" class="progress-bar progress-bar-success progress-bar-striped active"></div>
                          </div>
                          <span><strong>Normal</strong></span>
                          <div class="progress">
                            <div role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: $level_percent[1]" class="progress-bar progress-bar-danger progress-bar-striped active"></div>
                          </div>
                          <span><strong>Hard</strong></span>
                          <div class="progress">
                            <div role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: $level_percent[2]" class="progress-bar progress-bar-info progress-bar-striped active"></div>
                          </div>
                          <span><strong>Crazy</strong></span>
                          <div class="progress">
                            <div role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: $level_percent[3]" class="progress-bar progress-bar-warning progress-bar-striped active"></div>
                          </div>
                          
                        </div>
                      </div>
                    </div>
                  
                  	$submit_result
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
    <script src="libs/raphael/raphael-min.js"></script>
    <script src="libs/morris.js/morris.min.js"></script>
    ';
print '

<script>
$(document).ready(function(){
	$("#email_confirm").click(function(){
		alert("email 전송요청!");
		$("#emailbtn").css("display","none");
		$.ajax({
       url:"ajax/email_confirm.pl",
       data:{"ID":"'.$id.'"},
       success:function(){
           alert("이메일을 확인해 주세요.");
        },
       error:function(){
          alert("전송실패!");
        }
            
		})	
	})
	$("#email_mbtn").click(function(){
		if($("#email_modify").css("display")=="block"){
			$("#comment_modify").css("display","none");
			$("#email_modify").css("display","none");
			$("#passwd_modify").css("display","none");
		}else{
			$("#comment_modify").css("display","none");
			$("#passwd_modify").css("display","none");
			$("#email_modify").css("display","block");
		}
	})
	$("#comment_mbtn").click(function(){
		if($("#comment_modify").css("display")=="block"){
			$("#comment_modify").css("display","none");
			$("#email_modify").css("display","none");
			$("#passwd_modify").css("display","none");
		}else{
			$("#email_modify").css("display","none");
			$("#passwd_modify").css("display","none");
			$("#comment_modify").css("display","block");
		}
		
	})
	$("#passwd_mbtn").click(function(){
		if($("#passwd_modify").css("display")=="block"){
			$("#comment_modify").css("display","none");
			$("#email_modify").css("display","none");
			$("#passwd_modify").css("display","none");
		}else{
			$("#email_modify").css("display","none");
			$("#comment_modify").css("display","none");
			$("#passwd_modify").css("display","block");
		}
		
	})
	$("#email_sbtn").click(function(){
		var regex=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
		if(regex.test($("#email_val").val())==false){
			alert("올바른 이메일 형식이 아닙니다.");
		}else{
			var email=$("#email_val").val();
			$.ajax({
	       url:"ajax/email_modify.pl",
	       data:{"ID":"'.$id.'","EMAIL":email},
	       success:function(){
	           window.location.replace("user.pl");
	        },
	       error:function(){
	          alert("변경실패.");
	        }
	            
			})
		}
	})
	$("#comment_val").keyup(function(){
		$("#comment_val").val($("#comment_val").val().replace(/[^a-z| |A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]+/g,""));
	})
	$("#comment_val").blur(function(){
		$("#comment_val").val($("#comment_val").val().replace(/[^a-z| |A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]+/g,""));
	})
	$("#comment_sbtn").click(function(){
			var comment=$("#comment_val").val();
			$.ajax({
		       url:"ajax/comment_modify.pl",
		       data:{"ID":"'.$id.'","COMMENT":comment},
		       success:function(){
		           window.location.replace("user.pl");
		        },
		       error:function(){
		          alert("변경실패.");
		        }
			})
	})
	$("#cpasswd_val").keyup(function(){
		$("#cpasswd_val").val($("#cpasswd_val").val().replace(/[^\d|a-z|A-Z|_]+/g,""));
	})
	$("#passwd_sbtn").click(function(){
		if($("#passwd_val").val()==$("#fpasswd_val").val() && $("#passwd_val").val()!=""){
			var salt1="'.$salt1.'";
			$("#CPW").val($("#cpasswd_val").val());
			for(var i=0;i<=777;i++){
				$("#CPW").val(CryptoJS.SHA3(salt1+$("#CPW").val()));
			}
			var nsalt=CryptoJS.lib.WordArray.random(32);
			$("#NPW").val($("#passwd_val").val());
			for(var i=0;i<=777;i++){
				$("#NPW").val(CryptoJS.SHA3(nsalt+$("#NPW").val()));
			}
			var cpw=$("#CPW").val();
			var npw=$("#NPW").val();
			var usalt=nsalt.toString();
			$.ajax({
		       url:"ajax/passwd_modify.pl",
		       data:{"ID":"'.$id.'","CPW":cpw,"SALT":usalt,"NPW":npw},
		       success:function(e){
		           if(e=="success"){
		           		window.location.replace("login/logout.pl");
		           }else{
		           		alert("비밀번호 변경 실패.");
		           		alert(e);
		           }
		        },
		       error:function(e){
		          alert(e);
		        }
			})	
		}else{
			$("#ERRMSG_TITLE").html("<strong>Modify Error!!</strong>");
			$("#ERRMSG_SUBTITLE").html("<strong>Check Password</strong>");
			$("#ERRMSG_COMMENT").html("<h5>Please check the new password<br>and confirm password.</h5>");
			$("#ERRORMSG").click();	
		}
	})
});
</script>';
###############################GRAPH JQUERY##########################################
my @uipst=("accepted","wrong answer","time limit","memory limit","runtime error","compile error","unable function use");
my $donut_str='';
foreach my $elem(@uipst){
	$state=$con->prepare("SELECT count(ui_id) FROM userinfo_problem WHERE ui_id=\'$c_id\' and uip_status LIKE \'$elem\%\'");
	$state->execute;
	my @row=$state->fetchrow_array;
	$donut_str.="{label: \"$elem\", value: $row[0]},";
	$state->finish;
}
$donut_str=substr($donut_str,0,length($donut_str)-1);
my $area_str='';
foreach my $idx(0..7){
	my ($lsec,$lmin,$lhour,$mday,$lmon,$lyear,$wday,$yday) = localtime(time() - ((60*60*24)*$idx));
	my $locdate = sprintf("%04s.%02s.%02s",$lyear+1900,$lmon+1,$mday);
	my $locdate2 = sprintf("%04s-%02s-%02s",$lyear+1900,$lmon+1,$mday);
	$area_str.='{ y: "'.$locdate2.'"';

		my $query="SELECT count(pr_optnum) FROM userinfo_problem WHERE ui_id=\'$c_id\' and uip_status=\'accepted\' and SUBSTR(uip_date,0,11)<='$locdate'";
		$state=$con->prepare($query);
		$state->execute;
		my @row=$state->fetchrow_array;
		$area_str.=",a : $row[0] ";
		my $acc=$row[0];
		$state->finish;
		
		$query="SELECT count(pr_optnum) FROM userinfo_problem WHERE ui_id=\'$c_id\' and SUBSTR(uip_date,0,11)<='$locdate'";
		$state=$con->prepare($query);
		$state->execute;
		@row=$state->fetchrow_array;
		my $fail=$row[0]-$acc;
		$area_str.=",b : $fail ";
		$state->finish;
	
	$area_str.='},
	';
}
$area_str=substr($area_str,0,length($area_str)-3);
print '
<script>
$(document).ready(function() {
	if ($(".template__charts").length) {
		function morrisChart(el) {
			var type = el.data("chart");
			switch (type) {
				case "morris-donut":
					Morris.Donut({
						element: el[0],
						data: [
							'.$donut_str.'
						],
						colors: ["#6799FF", "#F15F5F", "#F2CB61", "#BCE55C","#D9418C","#F29661","#FFA7A7"],
						backgroundColor: "#30363c",
						labelColor: "#88939C",
						resize: true
					});
					break;
				case "morris-area":
					Morris.Area.prototype.fillForSeries = function(i) {
						var color_original = this.colorFor(this.data[i], i, "line");
						return color_original;
					};

					Morris.Area.prototype.drawFilledPath = function(path, fill) {
						return this.raphael.path(path).attr("fill", fill).attr("opacity", this.options.fillOpacity).attr("stroke", "none");
					};

					Morris.Area({
						element: el[0],
						data: [
							'.$area_str.'
						],
						xkey: "y",
						ykeys: ["a", "b"],
						labels: ["accepted","fail"],
						lineColors: ["#6799FF", "#F15F5F"],
						pointStrokeColors: ["#6799FF", "#F15F5F"],
						pointSize: 0,
						fillOpacity: "0.6",
						resize: true
					});
					break;
			}
		}

		$(".chart__chart").each(function() {
			if ($(this).width() > 0) {
				morrisChart($(this));
			}
		});

		$(\'.chart__tabs a[data-toggle="tab"]\').on(\'shown.bs.tab\', function (e){
			var tab = $($(this).attr("href")),
				chart = tab.find(".chart__chart");
			if (chart.height() == 0) {
				morrisChart(chart);
			}
		})
	}
});
</script>
';
###############################
print '</body></html>';
$con->disconnect;