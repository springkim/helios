#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use File::Copy qw(copy);
use Array::Utils qw(:all);

require '../login/aes.pl';	#must be require before info.pl
require '../login/info.pl';
require 'common_html.pl';

my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $c_id=GetCookieId($q);
if($c_id eq ''){
	print $q->redirect('main.pl');
}
#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");

print helios_html_head($q,$c_id);
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
#############
my $state=$con->prepare("SELECT * FROM userinfo WHERE ui_id=\'$c_id\'");
$state->execute;
my $row=$state->fetchrow_hashref;
$state->finish;
$name=$row->{ui_name};
$email=$row->{ui_email};
$id=$row->{ui_id};
$comment=$row->{ui_comment};
$state=$con->prepare("SELECT count(*) FROM nonemail_certification WHERE ui_id=\'$c_id\'");
$state->execute;
my @row=$state->fetchrow_array;
$state->finish;
$email_confirm=$row[0];
if($email_confirm==1){
	$email_confirm='<div id="emailbtn" style="display:inline"><button type="button" class="btn btn-danger" id="email_confirm">E-mail Confirm</button></div>';
}else{
	$email_confirm='';
}
my $c_confirm='';
if(is_email_confirm($id)==1){
		$c_confirm='<strong style="color:#6799FF">(인증완료)</strong>';
}else{
	$c_confirm='<strong style="color:#F15F5F">(인증안됨)</strong>';
}
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
                          <button type="button" class="btn btn-info" id="email_mbtn">E-mail Modify</button>
                                  <button type="button" class="btn btn-info" id="comment_mbtn">Comment Midify</button>
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
    ';
    
print '<script>
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
		}else{
			$("#comment_modify").css("display","none");
			$("#email_modify").css("display","block");
		}
	})
	$("#comment_mbtn").click(function(){
		if($("#comment_modify").css("display")=="block"){
			$("#comment_modify").css("display","none");
			$("#email_modify").css("display","none");
		}else{
			$("#email_modify").css("display","none");
			$("#comment_modify").css("display","block");
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
});
</script>';
###############################

###############################
print '</body></html>';
$con->disconnect;