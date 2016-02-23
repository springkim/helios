#!/usr/bin/perl
#
#	@Project : Helios
#	@Architecture : KimBom
#	@engeneer : HwangDaeHyeon
#	problem.pl
#
#	@Created by On 2016. 01. 23...
#	@Copyright (C) 2016 HwangDaeHyun. All rights reserved.
#
use strict;
use warnings;
use CGI;
use DBI;
use File::Copy;
use Time::Stamp 'gmstamp', 'parsegm';
require "../login/info.pl";
require "../login/aes.pl";
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $submit_file = $q->param('FILE');
my $pr_path=$q->param('PR_PATH');
my $query="";
my $state;
my $style="";
my $problem="";
#=======left side print 요소
my $time_limit;
my $mem_limit;
my $tried_count;
my $solved_count;
my $rate;
my $rank_html=""; 
my @rank_name;
my @rank_id;
my @rank_lang;
my @rank_time;
#===========================login check(get id)
my $enc_name=AES_Encrypt("bluecandle_helios_cookie_id");
chop($enc_name);
chop($enc_name);
chop($enc_name);
my $c=$q->cookie($enc_name);	#cookie
if($c){
	$c=AES_Decrypt($c);
}
#===========================file check and execute 
if ($submit_file && $c){ #로그인 되어있고 제출파일이 있다면
	 if (!-d $c) { #아이뒤로 된 디렉토리가 없다면 ., 
        mkdir("user_submit/user_id/id-$c",0777); #디렉토리를 생성 
    }
    $submit_file =~ m<.+\.(\w+)?$>; #확장자 추출.
	my $user_source = parsegm gmstamp;
    $user_source=$user_source.".".$1;
	copy( $submit_file, "user_submit/user_id/id-$c/$user_source" );	#파일을 저장합니다.
    my $src= "user_id/id-$c/$user_source";
    my $curr_date= parsegm gmstamp;
   $query="INSERT INTO userinfo_problem VALUES(
     \'$pr_path\'
    ,\'$c\'
    ,\'$1\'
    ,\'0.00\'
    ,\'WAIT\'
    ,\'$curr_date\'
    ,\'$src\')";
    $con->do($query);
    
	print $q->redirect('result.pl');
}
#========================
my $problem_html;
if(!$pr_path){
	$pr_path="NULL";	
}else{
	#get database data
	$query="SELECT * from problem WHERE pr_path=\'$pr_path\'";
	$state=$con->prepare($query);
	$state->execute;

	my $row=$state->fetchrow_hashref;
	$time_limit=$row->{pr_timelimit};
	$mem_limit=$row->{pr_memlimit};
	#get tried count
	$query="SELECT COUNT(pr_path) FROM userinfo_problem WHERE pr_path=\'$pr_path\'";
	$state = $con->prepare($query);
	$state ->execute;
	my @arr = $state->fetchrow_array;
	$tried_count = $arr[0];
	#get solve count
	$query="SELECT COUNT(ui_id) FROM userinfo_problem WHERE pr_path=\'$pr_path\' AND uip_status = \'accepted\'";
	$state = $con->prepare($query);
	$state ->execute;
	@arr = $state->fetchrow_array;
	$solved_count = $arr[0];
	$rate =0;
	if(!($tried_count==0 && $tried_count eq "0")){
		$rate =$solved_count/$tried_count*100;
	}
	#get rank
	$query="SELECT * FROM userinfo_problem WHERE pr_path=\'$pr_path\' AND uip_status = \'Accepted\' ORDER BY uip_time";
	$state = $con->prepare($query);
	$state -> execute;
	
	my $state_temp;
	my $rank_temp;
	my $loop_cnt=0;
	while($row = $state->fetchrow_hashref){
		$state_temp= $con->prepare("SELECT ui_name FROM userinfo WHERE ui_id=\'$row->{ui_id}\'");
		$state_temp->execute;
		my @rank = $state_temp->fetchrow_array;
		push @rank_name ,$rank[0];
		push @rank_id , $row->{ui_id};
		push @rank_lang , $row->{uip_language};
		push @rank_time , $row->{uip_time};
		$state_temp->finish;
		$loop_cnt++;
		if($loop_cnt==9){
			last;
		}
		
	}
	$state->finish;
		
#########################################read selected problem

	$pr_path =~ /problem\/(.*)/;
	open(FIN,"<$1") or die $!;
	$/=undef;
	$problem_html=<FIN>;
	$problem_html =~ /<style>(.*)<\/style>/;
	$style=$1;
	$problem_html =~ /<\/head>(.*)<\/html>/s;
	$problem=$1;
	$problem =~ s/<body/<div style="background-color:rgba(0,0,0,0);color:#ffffff"/;
	$problem =~ s/<\/body>/<\/div>/;
	
	$problem_html=~ /HIDDEN:::(.*):::/;
	$problem=~ s/HIDDEN:::$1::://;
	
	close(FIN);	
}
################################# print rank html ####################
	for(my $i = 0 ; $i<=$#rank_id; $i++){
		my $font_size =12;
		my $font_color = "#EAEAEA";
		if($i==0){
			$font_color ="#FFD6EC";
		}
		elsif($i==1){
			$font_color ="#D4F4FA";
		}
		elsif($i==2){
			$font_color ="#DAD9FF";
		}
		$rank_html= $rank_html."<tr style=\"color:".$font_color."\">"."<th>".($i+1)."</th>"."<td>".$rank_id[$i]."</td>"."<td>".$rank_name[$i]."</td>"."<td>".$rank_lang[$i]."</td>"."<td>".$rank_time[$i]."</td>"."</tr>";
	}
#################################	
print $q->header(-charset=>"UTF-8");
print <<EOF
<html>
<head>
	<title>BlueCandle</title>
	<link rel="stylesheet" type="text/css" href="css/problem.css" />
	<script src="javascript/problem.js" type="text/javascript"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<style>$style</style>
	<style>
		input{ 
			background-color: rgba(22, 255, 150, 0);
			color: #babdb6;
			border:1px solid rgba(96, 190, 204, 0.5);
			width : 70%;
			}
		input[type=text] {}
		input[type=button] {
			background-color: rgba(40, 81, 88, 0.5);
			border-radius: .2em;
			top:10px;
		}
	</style>
</head>
<body>
	<div class="left_side">
		<div class=left_side_1>
			<div class=left_side_1_1>
			<p>PROBLEM</p>
			</div>
			<div class=left_side_1_2>
				<img src="../image/problem.png" width="40px", height="40px" style="position:absolute;top:-10px; left:-50px;">
				<div class=left_side_1_2_1>
				</div>
			</div>
		</div>
		<div class=left_side_2>
			<p>Time Limit : $time_limit sec Space Limit : $mem_limit Mb</p>
		</div>
		<div class=left_side_3>
			<p>Tried : $tried_count Solved : $solved_count (Rate: $rate %)</p>
		</div>
		<div class=left_side_4>
			<p>RANKING</p>
				<table class="type07">  
	          		<tbody>
	          			<tr style="background-color: rgba(96, 190, 204, 0.5);font-size: 15px;"><th>Rank</th><td>ID</td><td>Name</td><td>Language</td><td>Time</td></tr>
	          			$rank_html
	              </tbody>
              </table>		
		</div>
		<form action="problem.pl" method="post" ENCTYPE="multipart/form-data">
            <input type="hidden" id="USER_SRC" name="USER_SRC"/>
            <input type="hidden" id="PR_PATH" name="PR_PATH" value="$pr_path"/>
			<div class=left_side_5>
				<input type="file" style="display:none" id="FILE" name="FILE" onchange="filesizechk(this)" accept="*" ></input>
					<div class="button" onclick="goFile()">
						Select Your Problem
					</div>
				<div class=left_side_5_1>
					<input type="text" style="" id="fakeFile" value="" readonly="readonly"></input>
					<input type="submit" value="Submit" style="width:90px; position : absolute; height: 20px;  top: 0px;right : 0px;" onclick="return CheckSubmit();">
					
					</input>
				</div>
			</div>
			<div class=left_side_6>
				<div class="button"  onclick="location.href='problem_list.pl';">
						Click This -> Go to problem_list
				</div>
			</div>
		</form>
	</div>
EOF
;
print <<EOF
	<div class=main_side>
		<div class=main_top>
		</div>
		<div class=main_problem>
		$problem
		</div>
	</div>
</body>
</html>
EOF
;

