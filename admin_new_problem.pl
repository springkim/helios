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
if(isAdmin($c_id)){
	
	my $title=$q->param("title");
	my $class=$q->param("class");
	my $level=$q->param("level");
	my $tl=$q->param("timelimit");
	my $ml=$q->param("memorylimit");
	my $content=$q->param("content");
	my $infile=$q->param('IFILE');
	my $outfile=$q->param('OFILE');
	my $type=$q->param('stype');
	if($title ne '' && $class ne '' && $level ne '' && $tl ne '' && $ml ne '' && $content ne ''){
		my $state=$con->prepare("SELECT count(*) FROM problem WHERE pr_title=\'$title\'");
		$state->execute;
		my @row=$state->fetchrow_array;
		$state->finish;
		if($row[0]==0){
				my $path="problem_repository/$class/$title";
				mkdir $path;
				chmod 0733,$path;
				$content=~s/'/''/g;	#데이터 베이스에 '를 삽입하려면 ''를  써야한다.
				open FP,'>',"$path/problem";
				print FP $title,"\n";
				print FP $class,"\n";
				print FP $level,"\n";
				print FP $tl,"\n";
				print FP $ml,"\n";
				print FP $type,"\n";
				print FP $content,"\n";
				close FP;
				copy($infile,"$path/in.txt");
				copy($outfile,"$path/out.txt");
				if($type eq 'topcoder'){
					my $mfile=$q->param("MAINFILE");
					copy($outfile,"$path/main.c");
				}
				$con->do("INSERT INTO problem VALUES(default,\'$title\',\'$level\',\'$class\',\'$tl\',\'$ml\',\'$content\',\'$type\')");	
						
		}else{
			print $q->redirect('main.pl');
		}
	}
#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print helios_html_head($q,$c_id);
print '<body class="framed main-scrollable"><div class="wrapper">';


print_header($c_id);
print '<div class="dashboard">';
print_sidemenu($c_id);
	
###################################################################################
my @comboarr='';
opendir(DH,"./problem_repository");
my @lists=readdir(DH);
foreach my $elem(@lists){
	if($elem ne '.' and $elem ne '..'){
		opendir(DH2,"./problem_repository/$elem");
		my @child_lists=readdir(DH2);
		foreach my $celem(@child_lists){
			if($celem ne '.' and $celem ne '..'){
				push @comboarr,"<option>$elem/$celem</option>";	
			}
		}
		closedir(DH2);
	}
}
closedir(DH);
@comboarr=sort @comboarr;
my $combostr='';
foreach my $elem(@comboarr){
	$combostr.=$elem;
}
print <<EOF
<div class="main">

          <div class="main__scroll scrollbar-macosx">
            <div class="main__cont">
              <div class="main-heading">
                <div class="main-title">
                  <ol class="breadcrumb">
                    <li><a href="#">Admin</a></li>
                    <li class="active">New problem</li>
                  </ol>
                </div>
                
              </div>
              <form method="post" action="admin_new_problem.pl" ENCTYPE="multipart/form-data">
              <div class="container-fluid half-padding">
                <div class="template template__controls">
                  <div class="row">
                    <div class="col-md-6">
                      <div class="panel panel-danger">
                        <div class="panel-heading">
                          <h3 class="panel-title">Problem</h3>
                        </div>
                        <div class="panel-body">
                          <div class="form-horizontal" >
                            <div class="form-group" >
                              <label class="col-sm-2 control-label">Title</label>
                              <div class="col-sm-10">
                                <input type="text" id="title" name="title" placeholder="title" class="form-control">
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Class</label>
                              <div class="col-sm-10">
                                <select placeholder="Select" id="class" name="class" class="selectpicker form-control">
                                  $combostr
                                </select>
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Level</label>
                              <div class="col-sm-10">
                                <select placeholder="Select" id="level" name="level" class="selectpicker form-control">
                                  		<option>easy</option>
                                  		<option>normal</option>
                                  		<option>hard</option>
                                  		<option>crazy</option>
                                </select>
                              </div>
                            </div>
                             <div class="form-group">
                              <label class="col-sm-2 control-label">Time Limit</label>
                              <div class="col-sm-10">
                                <select placeholder="Select" id="timelimit" name="timelimit" class="selectpicker form-control">
                                  		<option>1sec</option>
                                  		<option>3sec</option>
                                  		<option>5sec</option>
                                  		<option>10sec</option>
                                </select>
                              </div>
                            </div>
                             <div class="form-group">
                              <label class="col-sm-2 control-label">memory Limit</label>
                              <div class="col-sm-10">
                                <select placeholder="Select" id="memorylimit" name="memorylimit" class="selectpicker form-control">
                                  		<option>32MB</option>
                                  		<option>64MB</option>
                                  		<option>128MB</option>
                                  		<option>256MB</option>
                                </select>
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Problem style html</label>
                              <div class="col-sm-10">
                                <textarea placeholder="haroopad-style-html" id="content" name="content" rows="7" class="form-control"></textarea>
                              </div>
                            </div>
                           
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Input file</label>
                              <div class="col-sm-10">
                                <button type="submit" id="inputfile" class="btn btn-default">Upload input file</button>
                                <input type="text" readonly="readonly" id="inputfile2" name="inputfile2" placeholder="--" class="form-control">
                                <input type="file" style="display:none" id="inputfile3" name="IFILE" ></input>
                              </div>
                            </div>
                            	<div class="form-group">
                              <label class="col-sm-2 control-label">Output file</label>
                              <div class="col-sm-10">
                                <button type="submit" id="outputfile" class="btn btn-default">Upload output file</button>
                                <input type="text" readonly="readonly" id="outputfile2" name="outputfile2" placeholder="--" class="form-control">
                                <input type="file" style="display:none" id="outputfile3" name="OFILE" ></input>
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Submit Type</label>
                              <div class="col-sm-10">
                                <select placeholder="Select" id="stype" name="stype" class="selectpicker form-control">
                                  		<option>acm</option>
                                  		<option>topcoder</option>
                                </select>
                              </div>
                            </div>
                            <div class="form-group" id="MFILE" style="display:none">
                              <label class="col-sm-2 control-label">Output file</label>
                              <div class="col-sm-10">
                                <button type="submit" id="mfile" class="btn btn-default">Upload main file</button>
                                <input type="text" readonly="readonly" id="mfile2" name="mfile2" placeholder="--" class="form-control">
                                <input type="file" style="display:none" id="mfile3" name="MAINFILE" ></input>
                              </div>
                            </div>
                            <div class="form-group">
                              <label class="col-sm-2 control-label">Create</label>
                              <div class="col-sm-10">
                                 <button type="submit" id="submit" class="btn btn-default">Insert new problem</button>
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
	$("#title").keyup(function(){
		$("#title").val($("#title").val().replace(/[^a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣| ]+/g,""));
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