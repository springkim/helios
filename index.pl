#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
require 'css_helper.pl';
require 'login/info.pl';
require 'login/aes.pl';
require 'emblem.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );

my $level=1;
my $status="OFFLINE";
my $photo="image/personImage.png";
my $song="mp3/rhrn.mp3";
my $mission = "&nbsp&nbsp&nbspTODAY MISSION";
my $log_select="LOGIN";
my $log_href="login/login.pl";
my $log_info="login/user_info.pl";
my $log_text="WELCOME";
#======
my $total_problem="256";
my $solve_problem = "200";
my $solve_percent = $solve_problem/$total_problem*100;
$solve_percent=$solve_percent."%";

#=======database 
my @emblem_image;


my $solve_hard = "102";
my $solve_mid = "6";
my $solve_easy = "2";
my @log_data;
my $log_count=0;

#======

my $enc_name=AES_Encrypt("bluecandle_helios_cookie_id");
chop($enc_name);
chop($enc_name);
chop($enc_name);
my $c=$q->cookie($enc_name);	#cookie
if($c){
	$c=AES_Decrypt($c);
}
#============================================로그인이 되어 있다면==========================================
if($c){
	my $query="SELECT * FROM userinfo WHERE ui_id=\'$c\'";
	my $state=$con->prepare($query);
	$state->execute();
	my $row=$state->fetchrow_hashref;
	$level=int($row->{ui_level}) + 1;
	$status="ONLINE";
	$photo="login/photo/".$row->{ui_photo};
	$log_select="LOGOUT";
	$log_href="login/logout.pl";
	$log_text="BYE";
	
	$query="SELECT eb_path FROM userinfo_emblem,emblem 
			WHERE ui_id=\'$c\' and userinfo_emblem.eb_name=emblem.eb_name";
	$state=$con->prepare($query);
	$state->execute();
	while(my @arr = $state->fetchrow_array){
		push @emblem_image,$arr[0];
	}
	@emblem_image=sort @emblem_image;
	
	
	$query ="SELECT ul_ip, ul_env, ul_date FROM userlog WHERE ui_id=\'$c\'";
	$state=$con->prepare($query);
	$state->execute();
	#sorted
	while(my $row = $state->fetchrow_hashref){
		my $extra=$row->{ul_date}." ".$row->{ul_env}." ".$row->{ul_ip};
		push @log_data ,$extra; 
	}
	$log_count=$#log_data+1;
}else{
	$c="NO LOGIN";
}

#==============================CGI DOT 프린팅 요소==============================
my $dot_1_1=PrintBigDot("0","0","100","20").PrintSmallDot("0","0","100","20");
my $dot_1_2=PrintBigDot("0","0","100","30").PrintSmallDot("0","0","100","30");
my $dot_2_2=PrintBigDot("0","0","130","39").PrintSmallDot("0","0","130","39");
my $dot_2=PrintBigDot("0","0","130","100").PrintSmallDot("0","0","130","100");
my $dot_3=PrintBigDot("0","0","100","100").PrintSmallDot("0","0","100","100");
my $dot_3_1=PrintBigDot("0","0","100","30").PrintSmallDot("0","0","100","30");
my $dot_4=PrintBigDot("-1","0","130","100").PrintSmallDot("-1","0","130","100");
my $eqz="";
for(my $i=0;$i<20;$i++){
	$eqz=$eqz."<div class=\"bar1\"></div><div class=\"bar2\"></div><div class=\"bar3\"></div>";
}
my $audio="<audio id=\"songaudio\" src=\"$song\"></audio>";
my $dot_us=PrintBigDot("0","0","230","400").PrintSmallDot("0","0","230","400");
my $dot_us_1=PrintBigDot("0","0","230","41").PrintSmallDot("0","0","230","41");
my $dot_us_2_1=PrintBigDot("0","0","100","80").PrintSmallDot("0","0","100","80");
my $dot_us_2_2=PrintBigDot("0","0","70","80").PrintSmallDot("0","0","70","80");
my $dot_us_2_2_m=PrintBigDot("0","0","70","40").PrintSmallDot("0","0","70","40");
my $dot_r_1=PrintBigDot("0","0","200","60").PrintSmallDot("0","0","200","60");
my $dot_r_2_2=PrintBigDot("0","0","130","10").PrintSmallDot("0","0","130","10");
my $dot_r_2_3=PrintBigDot("0","0","70","10").PrintSmallDot("0","0","70","10");
my $dot_r_3_1=PrintBigDot("0","0","130","30").PrintSmallDot("0","0","130","30");
my $dot_r_3_2=PrintBigDot("0","0","70","30").PrintSmallDot("0","0","70","30");
my $dot_log_tag=PrintBigDot("0","0","230","40").PrintSmallDot("0","0","230","40");
my $dot_log=PrintBigDot("0","0","230","150").PrintSmallDot("0","0","230","150");
#==============================LEFT DIV 프린팅 요소==============================
my $emblem_box=PrintEmblemBox(\@emblem_image);
my $key_image="image/key.png";
my $ip_address= $q->remote_host();
my $log_string="<p style=\"color:#FDFDD5\">$log_data[$#log_data]</p>";
for(my $i=$#log_data-1,my $cnt=0;$cnt<4 && $i>=0;$i--,$cnt++){
	$log_string=$log_string."<p>$log_data[$i]</p>";
}

#==============================RIGHT DIV 프린팅 요소==============================
my $query="SELECT count(ui_id) FROM userinfo";
my $state=$con->prepare($query);
$state->execute();
my @row=$state->fetchrow_array;
my $family_cnt=$row[0];		#가입자 수를 가져온다.	
$state->finish();
$con->disconnect();

#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");


print <<EOF
<html>
<head>
	<title>BlueCandle</title>
	<link rel="stylesheet" type="text/css" href="css/index.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<script src="javascript/index.js" type="text/javascript"></script>
	<script>
		history.pushState(null,null,location.href);
		window.onpopstate = function(event){
			history.go(1);	
		}
	</script>
</head>
<body onload="startClock()">
<div class="left_side">
	<div class="user_info">
		<div class="user_info_1">
			<img src="image/level$level.png" width="100px" height="100px">
			<div class="user_info_1_1">
				$dot_1_1
			</div>
			<div class="user_info_1_2">
				$dot_1_2	
			</div>
			<div class="user_info_2">
				<div class="user_info_2_1">
					<p>$status<p>
				</div>
				<div class="user_info_2_2">
					<div class="user_info_2_2_1" id="clock">
					</div>
					$dot_2_2
				</div>
				$dot_2
			</div>
			<div class="user_info_3">
				<img src="$photo" width="100px", height="100px">
				$dot_3
				<div class="user_info_3_1">
					$dot_3_1
				</div>
			</div>
			<div class="user_info_4">
				<a href="#" class="button small default_color song_button_position_play" onclick="SongBtn();return false;">
					PLAY / STOP
				</a>
				<div class="container">
					$eqz
					$audio
				</div>
				$dot_4
			</div>
		</div>
		<div class="user_state">
      		<div class=user_state_1>
            	<a href="problem/problem_list.pl" class="button small default_color mission_button_select">
               		SELECT
            	</a>
            	<p>$mission</p>
            	$dot_us_1
         	</div>
         	<div class="user_state_2">
            	<div class="user_state_2_1">
            		<p>solve problem</p>
            		<p style="color : white; font-size : 20"> $solve_problem/$total_problem</p>               
               		<ul class = "bargraph">
                  		<li class ="blue" style="width :$solve_percent"></li>
               		</ul>
               		$dot_us_2_1
            	</div>
           		<div class="user_state_2_2">
               		<table class="type07">                    
                  		<tbody>
                  			<tr>
                     			<th scope="row">Hard</th>
                     			<td>$solve_hard </td>
                  			</tr>
                  			<tr>
                    			<th scope="row">Normal</th>
                     			<td>$solve_mid</td>
                  			</tr>
                  			<tr>
                     			<th scope="row">Easy</th>
                     			<td>$solve_easy</td>
                  			</tr>
                   		</tbody>
               		</table>
               		$dot_us_2_2
               		$dot_us_2_2_m
            	</div>
            	<div class="user_state_2_3">  
            		<img src="$key_image" style="position:absolute;left:10px" width="70px" height="70px">          
            	</div>
         	</div>
         	$emblem_box
         	
         	<div class=user_state_4>
            	<a href="#" class="button small default_color emblem_button_prev" onclick="return emblem_prev()">
               		PREV
            	</a>
          		 <a href="#" class="button small default_color emblem_button_next" onclick="return emblem_next()">
               		NEXT
            	</a>
            	<p>Emblem</p>
            	$dot_us_1
         </div>
      	</div>
      	<div class=user_log_tag>
      		$dot_log_tag
      		 <a href="http://www.naver.com" class="button small default_color emblem_button_prev">
               		VIEW ALL
            </a>
            <p>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbspSignin log - </p>
            <p style="color:#FDFDD5;position:absolute;left:180px;top:1px">$log_count</p>
      	</div>
      	<div class=user_log>
      		$dot_log
      		$log_string
      	</div>
   	</div>
</div>
EOF
;
print <<EOF
<div class="main">
	<img src="image/fake_bkgnd.jpg" width="100%", height="100%">
</div>
EOF
;
print <<EOF
<div class="right_side">
	<div class="right_side_1">
		<p>HELIOS<p>
		$dot_r_1
	</div>
	<div class="right_side_2">
		<p>&nbsp&nbsp&nbspFAMILY</p>
		<div class="right_side_2_1">
			<div class="right_side_2_1_p">
				<p>$family_cnt</p>
			</div>
		</div>
	</div>
	<div class="right_side_2_2">$dot_r_2_2</div>
	<div class="right_side_2_3">$dot_r_2_3</div>
	<div class="right_side_2_4">
		<li><p>Architecture : Kim Bom</p>
		<li><p>Engeneer : Hwang Dae Hyeon</p>
	</div>
	<div class="right_side_3_1">
		<a href="$log_href" class="button small log_what_select">
			$log_select
		</a>
		$dot_r_3_1
	</div>
	<div class="right_side_3_2">
		<p>$log_text</p>
		$dot_r_3_2
	</div>
    <div class="right_side_4">
        <figure>
            <div class="face front"></div>
            <div class="face top"></div>
            <div class="face right"></div>
            <div class="face left"></div>
            <div class="face bottom"></div>
            <div class="face back"></div>
        </figure>
        <figure>
            <div class="face front"></div>
            <div class="face top"></div>
            <div class="face right"></div>
            <div class="face left"></div>
            <div class="face bottom"></div>
            <div class="face back"></div>
        </figure>
        <figure>
            <div class="face front"></div>
            <div class="face top"></div>
            <div class="face right"></div>
            <div class="face left"></div>
            <div class="face bottom"></div>
            <div class="face back"></div>
        </figure>
    </div>
    <div class="right_side_5_1">
		<a href="$log_info" class="button small default_color log_info">
			USER INFO
		</a>
		$dot_r_3_1
	</div>
	<div class="right_side_5_2">
		<p>CONFIG</p>
		$dot_r_3_2
	</div>
</div>

</body>
</html>
EOF
;
