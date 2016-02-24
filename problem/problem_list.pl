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
#####################left##################
my $total_problem=9999;
my $solved_problem=-1;
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
	$query = "SELECT COUNT(pr_path) FROM  userinfo_problem 	WHERE ui_id=\'$c\' AND uip_status =\'Accepted\'";
	$state = $con->prepare($query);
	$state->execute;
	@arr = $state->fetchrow_array;
	$solved_problem=$arr[0];
	$state->finish;
	$id_hidden="<input type=\"hidden\" id=\"HID\" value=\"$c\"/>";
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


#################problem group selected
my @problems;
my $table_html = '<div class="p_list"><table><tr>
<td>Problem number</td>
<td>Title</td>
<td>Problem level</td>
<td>Tried</td>
<td>Success</td>
<td>Rate</td>
</tr>';
$query="SELECT * FROM problem";
if($other_param){
	$query=$other_param;
}elsif ( $group && $subgroup ) {
	$query ="SELECT * FROM problem WHERE pr_group=\'$group\' and pr_subgroup=\'$subgroup\'";
}
#문제 번호 , 제목 , 정보 , 시도한 사람 , 성공한 사람, 비율..
$state = $con->prepare($query);
$state->execute;
while ( my $row = $state->fetchrow_hashref ) {
	my $extra =
	  $row->{pr_path} . "-" . $row->{pr_title} . "-" . $row->{pr_level};
	push @problems, $extra;
}
$state->finish;
@problems = sort @problems;
for ( my $i = 0 ; $i <= $#problems ; $i++ ) {
	$table_html = $table_html . '<tr>';
	my @elem = split( '-', $problems[$i] );

	#get tryed
	$query ="SELECT count(pr_path) FROM userinfo_problem WHERE pr_path=\'$elem[0]\'";
	$state = $con->prepare($query);
	$state->execute;
	my $try = $state->fetchrow_array;
	$state->finish;

	#get successed;
	$query ="SELECT count(pr_path) FROM userinfo_problem WHERE pr_path=\'$elem[0]\' and uip_status=\'Accepted\'";
	$state = $con->prepare($query);
	$state->execute;
	my $succ =  $state->fetchrow_array;
	$state->finish;

	#get rate
	my $rate = 0;
	if ( !( $try == 0 && $try eq "0" ) ) {
		$rate = $succ / $try * 100;
	}

	#get problem number
	my @pnum = split( '/', $elem[0] );
	$pnum[2] =~ /(\w+).html/;

	#make html
	my $temp = "<td>$1</td>
		<td><a href=\"problem.pl\" onclick=\"return problem_go(\'$elem[0]\')\">$elem[1]</a></td>
		<td>$problem_level[$elem[2]]</td>
		<td>$try tried</td>
		<td>$succ solved</td>
		<td>$rate %</td>";
	$table_html = $table_html . $temp . '</tr>';
}
$table_html = $table_html . '</table></div>';
#################################

print $q->header(-charset=>"UTF-8");
print <<EOF
<html>
<head>
<title>BlueCandle</title>
<link rel="stylesheet" type="text/css" href="css/problem_list.css" />
<script src="javascript/problem_list.js" type="text/javascript"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	<div class=left_side>
		<form action="problem_list.pl" method="post" name="PROBLEM_LIST_VIEW">
			<input type="hidden" id="GROUP" name="GROUP"/>
			<input type="hidden" id="SUBGROUP" name="SUBGROUP"/>
			<input type="hidden" id="OTHER_PARAM" name="OTHER_PARAM"/>
			<div class = redpoint style = "position:absolute;width:10px;height:10px;top:33px;left:-5px"></div>
			$id_hidden
			<div class=left_side_1>
				<p>Problem List</p>
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
		<form action="problem.pl" method="get" name="PROBLEM_VIEW">
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