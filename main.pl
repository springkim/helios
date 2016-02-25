#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Array::Utils qw(:all);
require 'login/aes.pl';	#must be require before info.pl
require 'login/info.pl';
my $q=new CGI;
my $c_id=GetCookieId($q);
#======================================================================
#						set headline menu
#======================================================================
my $headline_css_file;
my $webmenu="";
if($c_id){	#login
	$webmenu.='<a href="login/user_info.pl"><img src="css/information.jpg"/></a>';
	$webmenu.='<a href="login/user_info.pl"><img src="css/setting.jpg"/></a>';
	$webmenu.='<a href="login/logout.pl"><img src="css/logout.jpg"/></a>';
	$headline_css_file='css/headline_login.css';
}else{		
	$webmenu.='<a href="login/login.pl"><img src="css/signin.jpg"/></a>';
	$webmenu.='<a href="login/signup.pl"><img src="css/joinus.jpg"/></a>';
	$headline_css_file='css/headline_logout.css';
}
#======================================================================
#						set main notice
#======================================================================
my $notice="";
opendir(DIR,"image/notice") || die print $!;
my @notice_imgs=readdir(DIR);
my @delete_dir=qw/. ../;
@notice_imgs=array_minus(@notice_imgs,@delete_dir);
@notice_imgs=sort @notice_imgs;
foreach my $i(0..$#notice_imgs){
	$notice.="<div class=\"notice_box\" id=\"notice$i\"><img src=\"image/notice/$notice_imgs[$i]\" /></div>";	
}
#======================================================================
#						set item box
#======================================================================
sub InsertItemBox($$$$$){
	#image , title , comment , color , link
	my $image=shift;
	my $title=shift;
	my $comment=shift;
	my $color=shift;
	my $link=shift;
	my $str="<div class=\"box\"><div class=\"content\" style=\"background:$color\">";
	$str.="<div class=\"content_img\"><img src=\"$image\"/></div>";
	$str.="<div class=\"content_title\"><h1>$title</h1></div>";
	$str.="<div class=\"content_comment\"><p>$comment</p></div>";
	$str.="<div class=\"content_itemgo\"><a href=\"$link\"><img src=\"image/itembox/item_go.png\"/></a></div>";
	$str.='</div></div>';
	
	return $str;
}
my $itembox="";
$itembox.=InsertItemBox("image/itembox/problem_list.png","problem list","프로그래밍 문제를 풀어 보아요","#4374D9","problem/problem.pl");
$itembox.=InsertItemBox("image/itembox/score_board.png","score board","여러분의 순위를 확인해 보세요","#F15F5F","main.pl");
$itembox.=InsertItemBox("image/itembox/notice.png","notice","공지사항을 확인하세요","#F29661","main.pl");
$itembox.=InsertItemBox("image/itembox/knowledge.png","knowledge","지식을 공유하세요","#2F9D27","main.pl");




#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print <<EOF
<html>
<head>
<link rel="stylesheet" type="text/css" href="$headline_css_file">
<link rel="stylesheet" type="text/css" href="css/main.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script src="javascript/main.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<center>
	<div class="headline">
		<a href="main.pl"><img src="css/title.jpg"/></a>
		<div class="webmenu">
			$webmenu
  		</div>
  	</div>
</center>
  <center>
  	<div class="main">
      <div class="notice">
      		$notice
      	</div>
      	<div class="progress">
  			<div class="progress_bar" id="progress_bar"></div>
		</div>
			$itembox

  </center>
</body>
</html>
EOF
;