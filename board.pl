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
if($c_id eq ''){
	print $q->redirect('login/login.pl');
}
my $reply=$q->param('reply');
my $optnum=$q->param('optnum');
my $redirect_script='';
if($reply ne '' and $optnum ne ''){
	$con->do("INSERT INTO board_comment VALUES('$optnum','$c_id','$reply')");
	$redirect_script='<script type="text/javascript">
			location.replace("board.pl");
			location.href("board.pl");
			history.go(-1);
			location.reload();
		</script>';
}
my $title=$q->param('title');
my $content=$q->param('content');
my $kind=$q->param('kind');
if($title ne '' and $content ne '' and $kind ne ''){
	my ($lsec,$lmin,$lhour,$mday,$lmon,$lyear,$wday,$yday) = localtime(time());
	my $locdate = sprintf("%04s-%02s-%02s",$lyear+1900,$lmon+1,$mday);
	$con->do("INSERT INTO board VALUES(default,'$c_id','$locdate','$title','$content')");
	$redirect_script='<script type="text/javascript">
			location.replace("board.pl");
			location.href("board.pl");
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
my $state=$con->prepare("SELECT * FROM board ORDER BY bd_date DESC");
$state->execute;
my $boards='';
while(my $row=$state->fetchrow_hashref){
	my $title=$row->{bd_title};
	my $id=$row->{ui_id};
	my $date=$row->{bd_date};
	my $content=$row->{bd_content};
	my $type=$row->{bd_type};
	my $num=$row->{bd_optnum};
	my $cls='info';
	if($type eq 'question'){
		$cls='danger';	
	}elsif($type eq 'suggest'){
		$cls='warning';
	}elsif($type eq 'talk'){
		$cls='success';
	}
	$boards.='<div class="col-md-4">
	<div class="panel panel-'.$cls.'">
      <div class="panel-heading">
        <h3 class="panel-title">'.$title.'('.$date.')</h3>
      </div>
      <div class="panel-body">
      	<strong>'.$id.'</strong>
        <p>'.$content.'</p>
         <div class="template__btns">
			<button type="button" class="btn btn-primary btn-sm" onclick="reply('.$num.',\''.$title.'\')">Reply</button>
		  </div>
      </div>';
     my $state2=$con->prepare("SELECT * FROM board_comment WHERE bd_optnum='$num'");
     $state2->execute;
     while(my $row2=$state2->fetchrow_hashref){
     	my $comment=$row2->{bd_comment};
     	my $bcid=$row2->{ui_id};
     	$boards.='
     	<div class="panel-body">
     		<p>'.$bcid.':'.$comment.'</p>
     	</div>
     	';	
     }
     $state2->finish;
    $boards.='</div></div>
	';
}
$state->finish;
print '
 <div class="main">
          <div class="main__scroll scrollbar-macosx">
            <div class="main__cont">
              <div class="main-heading">
                <div class="main-title">
                  <ol class="breadcrumb">
                    <li><a href="./">Main</a></li>
                    <li class="active">Board</li>
                  </ol>
                </div>
                <div class="main-filter">
                  
                </div>
              </div>
              <div class="container-fluid half-padding">
                <div class="template">
                
                <div class="row">
                    <div class="col-md-6"><form method="post" action="board.pl">
                      <div class="panel panel-info">
                        <div class="panel-heading">
                          <h3 class="panel-title">Question</h3>
                        </div>
                        <div class="panel-body">
                          <div class="form-horizontal" >
                            <div class="form-group" >
                              <label class="col-sm-2 control-label">Question Title</label>
                              <div class="col-sm-10">
                                <input type="text" id="title" placeholder="insert question title..." name="title" class="form-control" maxlength="128">
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Question content</label>
                              <div class="col-sm-10">
                                <textarea placeholder="insert question content...." id="content" name="content" rows="7" class="form-control" maxlength="512"></textarea>
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Kind</label>
                              <div class="col-sm-10">
                                <select placeholder="Select" id="kind" name="kind" class="selectpicker form-control">
                                  		<option>question</option>
                                  		<option>suggest</option>
                                  		<option>talk</option>
                                </select>
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Add Question</label>
                              <div class="col-sm-10">
                                 <button type="submit" id="submit" class="btn btn-default">Insert question</button>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div></form>
                    </div>
                    
                    <div class="col-md-6">
                      <div class="panel panel-danger">
                        <div class="panel-heading">
                          <h3 class="panel-title">Alerts</h3>
                        </div>
                        <div class="panel-body">
                          <div role="alert" class="alert alert-info alert-dismissible">
                            <button type="button" data-dismiss="alert" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button><i class="alert-ico fa fa-fw fa-info"></i><strong>질문은 간단히!!&thinsp;</strong>너무 긴 질문은 올릴 수가 없습니다.
                          </div>
                          <div role="alert" class="alert alert-success alert-dismissible">
                            <button type="button" data-dismiss="alert" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button><i class="alert-ico fa fa-fw fa-check"></i><strong>답변은 성실히!!&thinsp;</strong>깔끔하고 명료한 답변을 달아주세요.
                          </div>
                          <div role="alert" class="alert alert-warning alert-dismissible">
                            <button type="button" data-dismiss="alert" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button><i class="alert-ico fa fa-fw fa-exclamation"></i><strong>제발 소스코드는 올리지마세요!!&thinsp;</strong>소스코드를 올리면 아무도 답변 안해줍니다.
                          </div>
                          <div role="alert" class="alert alert-danger alert-dismissible">
                            <button type="button" data-dismiss="alert" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button><i class="alert-ico fa fa-fw fa-ban"></i><strong>질문하는법!!&thinsp;</strong>유투브 김포프 선배님의 질문하는법.<a href="https://www.youtube.com/watch?v=LjcMes6LJHs">영상 보러가기</a>
                          </div>
                        </div>
                      </div></div>
                    
                    </div>
                
                  <div class="row">
                    '.$boards.'
                  </div>
                  
                  <div class="template template__modals" style="display:none"><div class="template__modal" style="display:none">
                                
                              <button id="real_reply" type="button" data-toggle="modal" data-target="#modal1" class="btn btn-info" style="float:right">Check</button>
                  </div></div>
                  	<form id="reply_form" method="post" action="board.pl">
                   <div id="modal1" class="modal fade">
                          <div class="modal-dialog">
                            <div class="modal-content">
                              <div class="modal-header">
                                <button type="button" data-dismiss="modal" aria-label="Close" class="close"><span aria-hidden="true">&times;</span></button>
                                <h4 class="modal-title">Reply Question</h4>
                              </div>
                              
                              <div class="modal-body" style="margin-bottom:15px">
                              <h4><i class="alert-ico fa fa-fw fa-gift" id="REPLY_DIALOG"></i><strong id="REPLY_TITLE"><strong>Fail</strong></strong></h4>
	                                <div class="col-sm-12">
	                                <input type="text" id="reply" placeholder="reply here..." name="reply" class="form-control" maxlength="256">
	                                <input type="hidden" id="optnum" name="optnum" value=""></input>
	                                
	                              </div>
                              </div>
                              <div class="modal-footer">
                                <button  type="button" data-dismiss="modal" class="btn btn-default">Cancel</button>
                                <button id="submit_reply" type="button" class="btn btn-primary">Reply</button>
                              </div>
                            </div>
                          </div>
                        </div>
    					</form>
    
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
';

##################################################################################
print '</div></div></div>';
print_js();
print '<script>
function reply(num,title){
	$("#optnum").val(num);
	$("#REPLY_TITLE").html("<strong>"+"Reply to "+title+"</strong>");
	$("#real_reply").click();
}
</script>';
print '<script>
$(document).ready(function(){
	$("#submit_reply").click(function(){
		if($("#reply").val()!=""){
			$("#reply_form").submit();
		}else{
			alert("can`t submit blank reply");	
		}
	})
});
</script>';


print '<script src="libs/morris.js/morris.min.js"></script>';
###############################

###############################
print '</body></html>';
$con->disconnect;