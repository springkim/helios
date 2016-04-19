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
if(isAdmin($c_id)){
	my $title=$q->param('title');
	my $content=$q->param('content');
	if($title ne '' and $content ne ''){
		$content=~s/'/"/g;
		my ($lsec,$lmin,$lhour,$mday,$lmon,$lyear,$wday,$yday) = localtime(time());
		my $locdate = sprintf("%04s-%02s-%02s",$lyear+1900,$lmon+1,$mday);
		$con->do("INSERT INTO notice VALUES(default,'$c_id','$locdate','$title','$content')");
		$redirect_script='<script type="text/javascript">
			location.replace("notice.pl");
			location.href("notice.pl");
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
<div class="main">

          <div class="main__scroll scrollbar-macosx">
            <div class="main__cont">
              <div class="main-heading">
                <div class="main-title">
                  <ol class="breadcrumb">
                    <li><a href="#">Admin</a></li>
                    <li class="active">New notice</li>
                  </ol>
                </div>
                
              </div>
              <form method="post" action="admin_new_notice.pl" ENCTYPE="multipart/form-data">
              <div class="container-fluid half-padding">
                <div class="template template__controls">
                  <div class="row">
                    <div class="col-md-6">
                      <div class="panel panel-danger">
                        <div class="panel-heading">
                          <h3 class="panel-title">Notice</h3>
                        </div>
                        <div class="panel-body">
                          <div class="form-horizontal" >
                            <div class="form-group" >
                              <label class="col-sm-2 control-label">Notice title</label>
                              <div class="col-sm-10">
                                <input type="text" id="title" placeholder="insert notice title..." name="title" class="form-control">
                              </div>
                            </div>
                            
                            
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Notice content</label>
                              <div class="col-sm-10">
                                <textarea placeholder="insert notice content...." id="content" name="content" rows="7" class="form-control"></textarea>
                              </div>
                            </div>
                           
                            
                           
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Add notice</label>
                              <div class="col-sm-10">
                                 <button type="submit" id="submit" class="btn btn-default">Insert notice</button>
                              </div>
                            </div>
                           
                          </div>
                        </div>
                      </div>
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
EOF
;
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
###############################
print '<script>
$(document).ready(function(){
	$("#submit").click(function(){
		if($("#title").val()==""){
			alert("제목을 입력하십시오");
			return false;	
		}
		if($("#content").val()==""){
			alert("내용을 입력하십시오");
			return false;	
		}	
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