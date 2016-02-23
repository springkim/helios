#!/usr/bin/perl
#
#	@Project : Helios
#	@Architecture : KimBom
#	problem_list.pl
#
#	@Created by On 2016. 01. 22...
#	@Copyright (C) 2016 KimBom. All rights reserved.
#
use strict;
use warnings;
use CGI;
use DBI;
require "../login/info.pl";
require "../login/aes.pl";
my $q             = new CGI;
my $con           = DBI->connect( GetDB(), GetID(), GetPW() );
my $state;
my $query;

my @problem_level = ( "None", "Easy", "Normal", "Hard" );
my $group = $q->param('GROUP');    #algorithm , datastructure , math , language , contest
my $subgroup = $q->param('SUBGROUP');
my $other_param=$q->param('OTHER_PARAM');
my $pr_path = $q->param("PR_PATH");
#####################left##################
my $total_problem=0;     ###########################################################################################
my $solved_problem=-0;      ###########################################################################################
my $id_hidden="";
$query = "SELECT COUNT(pr_path) FROM problem";
$state = $con->prepare($query);
$state->execute;
my @arr = $state->fetchrow_array;
$total_problem = $arr[0];
$state->finish;
#####login check#####
my $enc_name=AES_Encrypt("bluecandle_helios_cookie_id");
chop($enc_name);
chop($enc_name);
chop($enc_name);
my $c=$q->cookie($enc_name);	#cookie
if($c){
	$c=AES_Decrypt($c);
}
if($c){
	$query = "SELECT COUNT(pr_path) FROM  userinfo_problem 	WHERE ui_id=\'$c\' AND uip_status =\'success\'";
	$state = $con->prepare($query);
	$state->execute;
	@arr = $state->fetchrow_array;
	$solved_problem=$arr[0];
	$state->finish;
	$id_hidden="<input type=\"hidden\" id=\"HID\" value=\"$c\"/>";
}else{
    print $q->redirect("../index.pl");
}

my $tree_html="";
$query = "SELECT DISTINCT pr_group FROM problem ORDER BY pr_group";
$state = $con->prepare($query);
$state->execute;
my @all_group;
while(my @row = $state->fetchrow_array){
	push  @all_group, $row[0];
}
$state->finish;
for(my $i=0; $i<=$#all_group; $i++){
	my $id='c'.$i;
	my $temp="<ul class=\"tree\">
 		<input type=\"checkbox\" checked=\"checked\" id=\"$id\" />
   		<label class=\"tree_label\" for=\"$id\">$all_group[$i]</label>";
   	$query ="SELECT DISTINCT pr_subgroup FROM problem WHERE pr_group=\'$all_group[$i]\' ORDER BY pr_subgroup";
   	$state = $con->prepare($query);
   	$state->execute;
   	my @all_subgroup;
   	while(my @row = $state->fetchrow_array){
   		push @all_subgroup, $row[0];
   	}
   	$state->finish;
   	for(my $j=0; $j<= $#all_subgroup; $j++){
   		$temp= $temp."<ul><li> 
	       <span class=\"tree_label\"><a href=\"#\" style=\"color:#719599\" onclick=\"return group_select(\'$all_group[$i]\',\'$all_subgroup[$j]\');\">$all_subgroup[$j]</a></label></li></ul>";
   	}
   	$temp=$temp."</ul>";
   	
   	$tree_html=$tree_html.$temp;
}
########################execute#####################

#파일경로, 아이디 , 언어, 런타임, 결과, 제출날짜, 저장파일 경로
#$con->do("INSERT INTO userinfo_problem VALUES(\'$pr_path\', \'$c\',\'$lang\',\'$tl\', \'$out[0]\', \'$time\',\'$dir\'");
#################problem group selected
my @problems;
my $table_html = '<div class="p_list"><table><tr>
<td>Problem number</td>
<td>Title</td>
<td>Verdict</td>
<td>Language</td>
<td>Runtime</td>
<td>Submisson Date</td>
</tr>';
$query="SELECT * FROM userinfo_problem WHERE ui_id = \'$c\'ORDER BY uip_subdate";
if($other_param){
	$query=$other_param;
}elsif ( $group && $subgroup ) {
	$query ="SELECT * FROM problem WHERE pr_group=\'$group\' and pr_subgroup=\'$subgroup\'";
}
#문제 번호 , 제목 , 채 , 언어, 런타임 , 제출 날자.
$state = $con->prepare($query);
$state->execute;
while ( my $row = $state->fetchrow_hashref ) {
	my $extra =
	  $row->{uip_subdate}."-".$row->{pr_path};
	
	push @problems, $extra;
}

$state->finish;
@problems = sort @problems;
for ( my $i = $#problems ; $i >=0 ; $i-- ) {
	$table_html = $table_html . '<tr>';
	my @elem = split( '-', $problems[$i] );
	#get verdict
	$query ="SELECT uip_status FROM userinfo_problem WHERE ui_id = \'$c\' AND uip_subdate = \'$elem[0]\'";
	$state = $con->prepare($query);
	$state->execute;
	my $verdict = $state->fetchrow_array;
	$state->finish;
	#get language
	$query ="SELECT uip_language FROM userinfo_problem WHERE ui_id = \'$c\' AND uip_subdate = \'$elem[0]\'";
	$state = $con->prepare($query);
	$state->execute;
	my $language = $state->fetchrow_array;
	$state->finish;
	#get runtime
	$query ="SELECT uip_time FROM userinfo_problem WHERE ui_id = \'$c\'AND uip_subdate = \'$elem[0]\'";
	$state = $con->prepare($query);
	$state->execute;
	my $runtime = $state->fetchrow_array;
	$state->finish;
	#get Submission Date 
	$query ="SELECT uip_subdate FROM userinfo_problem WHERE ui_id = \'$c\' ";
	$state = $con->prepare($query);
	$state->execute;
	my $date = $state->fetchrow_array;
	$state->finish;
	#get problem Title
	$query ="SELECT pr_title FROM problem WHERE pr_path = \'$elem[1]\'";
	$state = $con->prepare($query);
	$state -> execute;
	my $title = $state->fetchrow_array;
	#get problem number
	my @pnum = split( '/', $elem[1] );
	$pnum[2] =~ /(\w+).html/;
	
	#make html
	my $temp = "<td>$1</td>
		<td><a href=\"problem.pl\" onclick=\"return problem_go(\'$elem[1]\')\">$elem[1]</a></td>
		<td>$verdict</td>
		<td>$language</td>
		<td>$runtime</td>
		<td>$elem[0]</td>";
	$table_html = $table_html . $temp . '</tr>';
}
$table_html = $table_html . '</table></div>';



#################################

print $q->header(-charset=>"UTF-8");
print <<EOF
<html>
<head>
<title>BlueCandle</title>
<link rel="stylesheet" type="text/css" href="css/result.css" />
<script src="javascript/result.js" type="text/javascript"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	<div class=left_side>
		<form action="result.pl" method="post" name="PROBLEM_LIST_VIEW">
			<input type="hidden" id="GROUP" name="GROUP"/>
			<input type="hidden" id="SUBGROUP" name="SUBGROUP"/>
			<input type="hidden" id="OTHER_PARAM" name="OTHER_PARAM"/>
			<div class = redpoint style = "position:absolute;width:10px;height:10px;top:33px;left:-5px"></div>
			$id_hidden
			<div class=left_side_1>
				<p>Result</p>
				<img src="../image/problem_list.png" width="50px", height="50px" style="position:absolute;top:0px;right:0px">
				<div class = redpoint style = "position:absolute;width:5px;height:5px;top:57px;left:278px"></div>
			</div>
			<div class=left_side_2>
				<p>The Number of Problem</p>
				<p style="color : #C3D7DB; font-size : 30px; text-align:right">$total_problem</p>
			</div>
			<div class=left_side_3>
				<p>The Number of Problem which solved by Me</p>
				<p style="color : #C3D7DB; font-size : 30px; text-align:right">$solved_problem</p>
			</div>
			<div class=left_side_4>
				<section class="webdesigntuts-workshop">
					<input type="text" id="SEARCH" name="SEARCH" placeholder="key" onkeyup="search_keyup()" onblur="search_keyup()" maxlength="64"></input>
					<input type="button" value="Search" onclick="search_problem()" style="width:60px;position:absolute;left:200px;top:-164px"></input>
				</section>
			</div>
			<div class=left_side_5>
				<ul class="tree">
	 				<input type="checkbox" checked="checked" id="c"/>
	   				<label class="tree_label" for="c">problem</label>
	   				<ul><li> 
		       		<span class="tree_label"><a href="#" style="color:#719599" onclick="return all_problem()">all</a></label>
		       	</li></ul>
		       	<ul><li> 
		       		<span class="tree_label"><a href="#" style="color:#719599" onclick="return level_problem('1');">easy</a></label>
		       	</li></ul>
		       	<ul><li> 
		       		<span class="tree_label"><a href="#" style="color:#719599" onclick="return level_problem('2');">normal</a></label>
		       	</li></ul>
		       	<ul><li> 
		       		<span class="tree_label"><a href="#" style="color:#719599" onclick="return level_problem('3');">hard</a></label>
		       	</li></ul>
		       	<ul><li> 
		       		<span class="tree_label"><a href="#" style="color:#719599" onclick="return solve_problem()">solve</a></label>
		       	</li></ul>
		       	<ul><li> 
		       		<span class="tree_label"><a href="#" style="color:#719599" onclick="return try_problem()">try</a></label>
		       	</li></ul>
		       	<ul><li> 
		       		<span class="tree_label"><a href="#" style="color:#719599" onclick="return non_solve_problem()">non solve</a></label>
		       	</li></ul>
	   			</ul>
				$tree_html
	  			
			</div>
			<div class = redpoint style = "position:absolute;width:50px;height:10px;top:850px;left:-5px"></div>
		</form>
	</div>
EOF
;

print <<EOF
	<div class=main_side>
		<form action="problem.pl" method="post" name="PROBLEM_VIEW">
			<input type="hidden" id="PR_PATH" name="PR_PATH"/>
			<div class=main_up>
				
				<p>Copyright (C) 2016 KimBom,HwangDaeHyeon. All rights reserved.</p>
				<section class="webdesigntuts-workshop">
					<input type="button" value="main" onclick="location.href='../index.pl';" style="width:80px;position:absolute;left:-1300px;top:-230px"></input>
				</section>
			</div>
			<div class=p_div>
				$table_html
			</div>
		</form>
	</div>
</body>
</html>
EOF
  ;