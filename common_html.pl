use strict;
use warnings;
use DBI;
use HTTP::BrowserDetect qw( );
require 'library/info.pl';
require 'global_require.pl';
require 'global_head.pl';
my $title='Helios';	#page title

my @side_menu;
my @side_menu_href;
$side_menu[0][0]="Dash Board";$side_menu_href[0][0]="main.pl";
$side_menu[1][0]="MailBox";$side_menu_href[1][0]="";
	$side_menu[1][1]="Inbox";$side_menu_href[1][1]="mail/inbox.pl";
	$side_menu[1][2]="Sent";$side_menu_href[1][2]="mail/sent.pl";
	$side_menu[1][3]="Compose Mail";$side_menu_href[1][3]="mail/compose.pl";
$side_menu[2][0]="Question";$side_menu_href[2][0]="question.pl";
$side_menu[3][0]="User";$side_menu_href[3][0]="user.pl";


my $login_page="login/login.pl";
my $logout_page="login/logout.pl";
my $signup_page="login/signup.pl";
my $problem_page="";
my $contest_page="http://www.naver.com";
my $submit_page="submit.pl";
my $ranking_page="ranking.pl";
my $board_page="http://www.youtube.com";
my $knowledge_page="http://www.daum.net";

my $mobile_title="Helios";
sub print_header($$){
	my $id=shift;
	my $href=$login_page;
	my $text="Log In";
	if($id){
		$text="Log Out";
		$href=$logout_page;
	}
	my $admin_html='';
	if(is_admin($id)>0){
    	$admin_html='
    	<li class="dropdown active"><a href="#" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" class="dropdown-toggle"><span style="color:#A566FF">Admin&nbsp;<i class="caret"></i></span></a>
              <ul class="dropdown-menu">
                <li><span style="color:#FFB2D9">&nbsp;&nbsp;For admin</span></li>
                <li role="separator" class="divider"></li>
                <li><a href="admin_new_problem.pl"><span style="color:#A566FF">Problem Insert</span></a></li>
                <li><a href="admin_view_submit.pl"><span style="color:#A566FF">All Submits</span></a></li>
                <li role="separator" class="divider"></li>
                <li><span style="color:#FFB2D9">&nbsp;&nbsp;For superadmin</span></li>
                <li role="separator" class="divider"></li>
             ';
       if(is_admin($id)==2){
    		$admin_html.='<li><a href="admin_erase_problem.pl"><span style="color:#A566FF">Problem Erase</span></a></li>';
    		$admin_html.='';
    	} 
       $admin_html.=' </ul></li>';
    }
   
	print <<EOF
	<nav class="navbar navbar-static-top header-navbar">
        <div class="header-navbar-mobile">
          <div class="header-navbar-mobile__menu">
            <button type="button" class="btn"><i class="fa fa-bars"></i></button>
          </div>
          <div class="header-navbar-mobile__title"><span>$mobile_title</span></div>
          <div class="header-navbar-mobile__settings dropdown"><a href="" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" class="btn dropdown-toggle"><i class="fa fa-power-off"></i></a>
            <ul class="dropdown-menu dropdown-menu-right">
            	<li><a href="$signup_page">Sign Up</a></li>
              <li><a href="$href">$text</a></li>
            </ul>
          </div>
        </div>
        <div class="navbar-header"><a href="main.pl" class="navbar-brand">
            <div class="logo text-nowrap">
              <div class="logo__img"><i class="fa fa-chevron-right"></i></div><span class="logo__text">$title</span>
            </div></a></div>
        <div class="topnavbar">
          <ul class="nav navbar-nav navbar-left">
           <li class="dropdown active"><a href="#" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" class="dropdown-toggle"><span>Problem&nbsp;<i class="caret"></i></span></a>
              <ul class="dropdown-menu">
                <li><a href="problem_list.pl?show_type=all"><span>All</span></a></li>
                <li role="separator" class="divider"></li>
                <li><a href="problem_list.pl?show_type=easy"><span>Easy</span></a></li>
                <li><a href="problem_list.pl?show_type=normal"><span>Normal</span></a></li>
                <li><a href="problem_list.pl?show_type=hard"><span>Hard</span></a></li>
                <li><a href="problem_list.pl?show_type=crazy"><span>Crazy</span></a></li>
                <li role="separator" class="divider"></li>
                <li><a href="problem_list.pl?show_type=solve"><span>Solve</span></a></li>
                <li><a href="problem_list.pl?show_type=nonsolve"><span>NonSolve</span></a></li>
                <li><a href="problem_list.pl?show_type=try"><span>Try</span></a></li>
                <li role="separator" class="divider"></li>
                <li><a href="problem_list.pl?show_type=algorithm"><span>Algorithm</span></a></li>
                <li><a href="problem_list.pl?show_type=datastructure"><span>DataStructure</span></a></li>
              </ul>
            </li>
            <li><a href="$submit_page"><span>Submit Result</span></a></li>
            <li><a href="$ranking_page"><span>Ranking</span></a></li>
             $admin_html
          </ul>
          <ul class="userbar nav navbar-nav">
            <li class="dropdown"><a href="" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false" class="userbar__settings dropdown-toggle"><i class="fa fa-power-off"></i></a>
              <ul class="dropdown-menu dropdown-menu-right">
                <li><a href="$signup_page">Sign Up</a></li>
                <li><a href="$href">$text</a></li>
              </ul>
            </li>
          </ul>
        </div>
      </nav>

EOF
	;
}
my $detail_view_href="";
sub print_sidemenu($){
	my $id=shift;
	my $question_count=0;
	my $favorite_link;
	my $algorithm_total=0;
	my $algorithm_solve=0;
	my $ds_total=0;
	my $ds_solve=0;
	my @level_count;
	my $friends;
	my $user_log;
	my $theme_select;
	my $auto_login="";
	my $save_log="";
	my $visit_cnt=0;
	my $visit_graph='0';
	my $solve_cnt=0;
	my $solve_graph='0';
	my $rank_cnt=0;
	my $rank_graph='0';
	foreach my $i(0..3){
		push @level_count,0;
	}
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	if($id){
			#get non watch count
			my $state=$con->prepare("SELECT count(qe_watch) FROM question WHERE ui_id=\'$id\' and qe_watch=FALSE");
			$state->execute();
			my @row=$state->fetchrow_array;
			$question_count=$row[0];
			$state->finish();
			#get favorite link list
			$state=$con->prepare("SELECT fa_title,fa_link FROM favorite WHERE ui_id=\'$id\'");
			$state->execute();
			while ( my $row = $state->fetchrow_hashref ){
					$favorite_link.="<li><a href=\"$row->{fa_link}\">$row->{fa_title}</a></li>";
			}
			$state->finish;
			#get Algorithm problem count
			$state=$con->prepare("SELECT count(DISTINCT problem.pr_optnum) FROM userinfo_problem NATURAL JOIN problem WHERE pr_group LIKE 'algorithm%' and ui_id=\'$id\' and uip_status=\'accepted\'");
			$state->execute;
			@row=$state->fetchrow_array;
			$algorithm_solve=$row[0];
			$state->finish;
			#get DataStructure problem count
			$state=$con->prepare("SELECT count(DISTINCT problem.pr_optnum) FROM userinfo_problem NATURAL JOIN problem WHERE pr_group LIKE 'datastructure%' and ui_id=\'$id\' and uip_status=\'accepted\'");
			$state->execute;
			@row=$state->fetchrow_array;
			$ds_solve=$row[0];
			$state->finish;
			#get level solve count
			my @level_name=("easy","normal","hard","crazy");
			my $i=0;
			foreach my $elem(@level_name){
				$state=$con->prepare("SELECT count(DISTINCT problem.pr_optnum) FROM userinfo_problem NATURAL JOIN problem WHERE pr_level=\'$elem\' and ui_id=\'$id\' and uip_status=\'accepted\'");
				$state->execute;
				@row=$state->fetchrow_array;
				$level_count[$i]=$row[0];
				$i++;
				$state->finish;
			}
			$state=$con->prepare("SELECT ui_comment,ui_level,ui_name FROM userinfo,friend WHERE ui_id1=\'$id\' and ui_id2=ui_id");
			$state->execute;
			while(my $row=$state->fetchrow_hashref){
					my $tag;
					if($row->{ui_level}==1){
						$tag="tag_support";
					}elsif($row->{ui_level}==2){
						$tag="tag_social";
					}elsif($row->{ui_level}==3){
						$tag="tag_clients";	
					}elsif($row->{ui_level}==4){
						$tag="tag_crazy";	
					}
					$friends.="<div class=\"lm-widget__item new\">
                      <div class=\"lm-widget__title\"><i class=\"fa fa-fw fa-tag $tag\"></i><span>$row->{ui_name}</span></div>
                      <div class=\"lm-widget__text\">$row->{ui_comment}</div><a href=\"#\" class=\"lm-widget__link\"></a>
                    </div>";
			}
			$state->finish;
			$state=$con->prepare("SELECT ul_ip,ul_env,ul_date FROM userlog WHERE ui_id=\'$id\' ORDER BY ul_date DESC");
			$state->execute;
			while(my $row=$state->fetchrow_hashref){
				my $ip=$row->{ul_ip};
				my $env=$row->{ul_env};
				my $date=$row->{ul_date};
				my $icon="fa-spinner";
				if($env=~/chrome/i){
					$icon="fa-chrome";
				}elsif($env=~/firefox/i){
					$icon="fa-firefox";
				}elsif($env=~/MSIE/i){
					$icon="fa-internet-explorer";
				}elsif($env=~/Edge/i){
					$icon="fa-edge";
				}elsif($env=~/Opera/i){
					$icon="fa-opera";
				}elsif($env=~/Safari/i){
					$icon="fa-apple";
				}
				$user_log.="<div class=\"ra-widget__item\">
                      		<div class=\"nav-menu__ico\"><i class=\"fa fa-fw $icon\"></i></div>
                      		<div class=\"nav-menu__text\"><span><b>$env</b></br>$ip</br>$date</span></div>
                      	</div>";
			}
			$state->finish;
			$state=$con->prepare("SELECT ui_autologin,ui_savelog FROM userinfo WHERE ui_id=\'$id\'");
			$state->execute;
			my $row=$state->fetchrow_hashref;
			if($row->{ui_autologin} eq '1'){
				$auto_login='checked="checked"';
			}
			if($row->{ui_savelog} eq '1'){
				$save_log='checked="checked"';
			}
			$state->finish;
			$state=$con->prepare("SELECT udi_visit,udi_solve,udi_rank FROM userdateinfo WHERE ui_id=\'$id\' OREDR BY udi_optday DESC");
			$state->execute;
			while(my $row=$state->fetchrow_hashref){
					$visit_cnt=($visit_cnt,$row->{udi_visit})[$visit_cnt<$row->{udi_visit}];
					$solve_cnt=($solve_cnt,$row->{udi_solve})[$solve_cnt<$row->{udi_solve}];
					$rank_cnt=($rank_cnt,$row->{udi_rank})[$rank_cnt<$row->{udi_rank}];
					$visit_graph.=",$row->{udi_visit}";
					$solve_graph.=",$row->{udi_solve}";
					$rank_graph.=",$row->{udi_rank}";
			}
			$state->finish;
	}
	#get Algorithm problem count
	my $state=$con->prepare("SELECT count(pr_optnum) FROM problem WHERE pr_group=\'algorithm\'");
	$state->execute;
	my @row=$state->fetchrow_array;
	$algorithm_total=$row[0];
	$state->finish;
	#get DataStructure problem count
	$state=$con->prepare("SELECT count(pr_optnum) FROM problem WHERE pr_group=\'datastructure\'");
	$state->execute;
	@row=$state->fetchrow_array;
	$ds_total=$row[0];
	$state->finish;
	$con->disconnect;
	my $mail_submenu;
	foreach my $i(1..3){
		$mail_submenu.="<li><a href=\"$side_menu_href[1][$i]\">$side_menu[1][$i]</a></li>";	
	}
	my @theme_active=(0,0);
	$theme_select=GetTheme($id);
	if($theme_select =~ /dark/i){
		$theme_active[0]='demo__theme_active';
	}elsif($theme_select =~ /lilac/i){
		$theme_active[1]='demo__theme_active';
	}
	$theme_select="<div class=\"demo__themes\">
              	<div data-css=\"css/right.dark.css\" title=\"Dark\" class=\"demo__theme $theme_active[0] demo__theme_dark\"></div>
              	<div data-css=\"css/right.lilac.css\" title=\"Lilac\" class=\"demo__theme $theme_active[1] demo__theme_lilac\"></div>
            	  </div>";
   
	print <<EOF
	<div style="display:none">
	<form method="post">
		<input type="hidden" id="userid" value="$id"/>
	</form>
	</div>
		<div class="sidebar">
          <div class="quickmenu">
            <div class="quickmenu__cont">
              <div class="quickmenu__list">
                <div class="quickmenu__item active">
                  <div class="fa fa-fw fa-home"></div>
                </div>
                <div class="quickmenu__item">
                  <div class="fa fa-fw fa-desktop"></div>
                </div>
                <div class="quickmenu__item">
                  <div class="fa fa-fw fa-user-plus"></div>
                </div>
                <div class="quickmenu__item">
                  <div class="fa fa-fw fa-heart"></div>
                </div>
                <div class="quickmenu__item">
                  <div class="fa fa-fw fa-cog"></div>
                </div>
              </div>
            </div>
          </div>
          <div class="scrollable scrollbar-macosx">
            <div class="sidebar__cont">
              <div class="sidebar__menu">
                <div class="sidebar__title">User Menu</div>
                <ul class="nav nav-menu">
                  <li><a href="$side_menu_href[0][0]">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-dashboard"></i></div>
                      <div class="nav-menu__text"><span>$side_menu[0][0]</span></div></a></li>          
                 
                  
                  <li><a href="$side_menu_href[2][0]">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-eye"></i></div>
                      <div class="nav-menu__text"><span>$side_menu[2][0]</span></div>
                      <div class="nav-menu__right"><i class="badge badge-default">$question_count</i></div></a></li>
                  <li><a href="$side_menu_href[3][0]">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-user"></i></div>
                      <div class="nav-menu__text"><span>$side_menu[3][0]</span></div></a></li>
                  <li><a href="notice.pl">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-bookmark"></i></div>
                      <div class="nav-menu__text"><span>Notice</span></div></a></li>
                  
                </ul>
                
                <div class="sidebar__title">Page</div>
                <ul class="nav nav-menu">
                  <li><a href="#">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-th-large"></i></div>
                      <div class="nav-menu__text"><span>Problem</span></div>
                      <div class="nav-menu__right"><i class="fa fa-fw fa-angle-right arrow"></i></div></a>
                    <ul class="nav nav-menu__second collapse">
                      <li><a href="problem_list.pl?show_type=all"><span>All</span></a></li>		               
		               <li><a href="problem_list.pl?show_type=easy"><span>Easy</span></a></li>
		               <li><a href="problem_list.pl?show_type=normal"><span>Normal</span></a></li>
		               <li><a href="problem_list.pl?show_type=hard"><span>Hard</span></a></li>
		               <li><a href="problem_list.pl?show_type=crazy"><span>Crazy</span></a></li>		               
		               <li><a href="problem_list.pl?show_type=solve"><span>Solve</span></a></li>
		               <li><a href="problem_list.pl?show_type=nonsolve"><span>NonSolve</span></a></li>
		               <li><a href="problem_list.pl?show_type=try"><span>Try</span></a></li>
		               <li><a href="problem_list.pl?show_type=algorithm"><span>Algorithm</span></a></li>
		               <li><a href="problem_list.pl?show_type=datastructure"><span>DataStructure</span></a></li>
                    </ul>
                  </li>
             
                  <li><a href="$ranking_page">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-trophy"></i></div>
                      <div class="nav-menu__text"><span>Ranking</span></div></a></li>
                  <li><a href="$submit_page">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-table"></i></div>
                      <div class="nav-menu__text"><span>Submit Result</span></div></a></li>
                  <li><a href="$board_page">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-dashboard"></i></div>
                      <div class="nav-menu__text"><span>Board</span></div></a></li>
                  <li><a href="$knowledge_page">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-pencil"></i></div>
                      <div class="nav-menu__text"><span>Knowledge</span></div></a></li>
                  
                  <li><a href="#">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-columns"></i></div>
                      <div class="nav-menu__text"><span>Reference</span></div>
                      <div class="nav-menu__right"><i class="fa fa-fw fa-angle-right arrow"></i></div></a>
                    <ul class="nav nav-menu__second collapse">
                      <li><a href="https://www-s.acm.illinois.edu/webmonkeys/book/c_guide/"><span>C Reference</span></a></li>
              	 	 <li><a href="http://www.cplusplus.com/reference/algorithm/"><span>C++ Reference</span></a></li>
                		 <li><a href="http://perldoc.perl.org/perlref.html"><span>Perl Reference</span></a></li>
                    </ul>
                  </li>
                  
                </ul>
                 <div class="sidebar__title">Yonsei University</div>
                <ul class="nav nav-menu">
                  <li><a href="http://yscec.yonsei.ac.kr">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-graduation-cap"></i></div>
                      <div class="nav-menu__text"><span>Yscec</span></div></a></li>          
                     <li><a href="http://portal.yonsei.ac.kr">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-bank"></i></div>
                      <div class="nav-menu__text"><span>Yonsei Portal</span></div></a></li>        
                  <li><a href="http://it.yonsei.ac.kr/">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-code"></i></div>
                      <div class="nav-menu__text"><span>Yonsei CTE</span></div></a></li>  
      
                 
                </ul>
              </div>
              
              <div class="sidebar__menu">
                <div class="sidebar__btn"><a href="$detail_view_href" class="btn btn-block btn-default">Detail View</a></div>
                
                <div class="sidebar__title">Classify</div>
                <ul class="nav nav-menu">
                  <li><a href="#">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-inbox"></i></div>
                      <div class="nav-menu__text"><span>Algorithm</span></div>
                      <div class="nav-menu__right"><i class="badge badge-default"><b>$algorithm_solve</b> / $algorithm_total</i></div></a></li>
                  <li><a href="#">
                      <div class="nav-menu__ico"><i class="fa fa-fw fa-upload"></i></div>
                      <div class="nav-menu__text"><span>Data Structure</span></div>
                      <div class="nav-menu__right"><i class="badge badge-default"><b>$ds_solve</b> / $ds_total</i></div></a></li>
                </ul>
                <div class="sidebar__title">Level</div>
                <div class="ul nav nav-menu">
                	<li><a href="inbox.html">
                      <div class="nav-menu__ico tag_crazy"><i class="fa fa-fw fa-tag"></i></div>
                      <div class="nav-menu__text"><span>Crazy</span></div>
                      	<div class="nav-menu__right"><i class="badge badge-default"><b>$level_count[3]</b></i></div></a></li></a></li>
                  <li><a href="inbox.html">
                      <div class="nav-menu__ico tag_clients"><i class="fa fa-fw fa-tag"></i></div>
                      <div class="nav-menu__text"><span>Hard</span></div><div class="nav-menu__right"><i class="badge badge-default"><b>$level_count[2]</b></i></div></a></li>
                  <li><a href="inbox.html">
                      <div class="nav-menu__ico tag_social"><i class="fa fa-fw fa-tag"></i></div>
                      <div class="nav-menu__text"><span>Normal</span></div><div class="nav-menu__right"><i class="badge badge-default"><b>$level_count[1]</b></i></div></a></li>
                  <li><a href="inbox.html">
                      <div class="nav-menu__ico tag_support"><i class="fa fa-fw fa-tag"></i></div>
                      <div class="nav-menu__text"><span>Easy</span></div><div class="nav-menu__right"><i class="badge badge-default"><b>$level_count[0]</b></i></div></a></li>
               
                </div>
              </div>
              <div class="sidebar__menu">
                <div class="sidebar__title">Friends</div>
                <div class="lm-widget">
                  <div class="lm-widget__list">
                    $friends
                  </div>
                </div>
                
              </div>
              <div class="sidebar__menu">
                <div class="sidebar__title">Recent Log</div>
                <div class="ra-widget">
                  <div class="ra-widget__cont">
                    <div class="ra-widget__list">
                      $user_log
                    </div>
                  </div>
                </div>
              </div>
              <div class="sidebar__menu">
                <div class="sidebar__title">Chart</div>
                
                <div class="ss-widget">
                
                  <div class="ss-widget__cont">
                    
                    
                </div>
                <div class="sidestat">
                  <div class="sidestat__cont">
                    <div class="sidestat__item">
                      <div class="sidestat__value">$visit_cnt</div>
                      <div class="sidestat__text">visits</div>
                      <div class="sidestat__chart sparkline bar">$visit_graph</div>
                    </div>
                    
                   
                    <div class="sidestat__item">
                      <div class="sidestat__value">$solve_cnt</div>
                      <div class="sidestat__text">solved problem</div>
                      <div class="sidestat__chart sparkline line">$solve_graph</div>
                    </div>
                    <div class="sidestat__item">
                      <div class="sidestat__value">$rank_cnt</div>
                      <div class="sidestat__text">your rank</div>
                      <div class="sidestat__chart sparkline area">$rank_graph</div>
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
}

# <li><a href="#">
##                      <div class="nav-menu__ico"><i class="fa fa-fw fa-envelope"></i></div>
 #                     <div class="nav-menu__text"><span>$side_menu[1][0]</span></div>
 #                     <div class="nav-menu__right"><i class="fa fa-fw fa-angle-right arrow"></i></div></a>
 #                   <ul class="nav nav-menu__second collapse">
 ##                     $mail_submenu
  #                  </ul>
  #                </li>









sub print_demo(){
print <<EOF
<div class="demo">
      <div class="demo__ico"></div>
      <div class="demo__cont">
        <div class="demo__settings">
          <div class="demo__group">
            <div class="demo__label">Color theme:</div>
            <div class="demo__themes">
              <div data-css="css/right.dark.css" title="Dark" class="demo__theme demo__theme_active demo__theme_dark"></div>
              <div data-css="css/right.lilac.css" title="Lilac" class="demo__theme demo__theme_lilac"></div>
              <div data-css="css/right.light.css" title="Light" class="demo__theme demo__theme_light"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
EOF
;	
}
sub print_js(){
	print <<EOF
	<script src="libs/jquery/jquery.min.js"></script>
    <script src="libs/bootstrap/js/bootstrap.min.js"></script>
    <script src="libs/jquery.scrollbar/jquery.scrollbar.min.js"></script>
    <script src="libs/bootstrap-tabdrop/bootstrap-tabdrop.min.js"></script>
    <script src="libs/sparkline/jquery.sparkline.min.js"></script>
    <script src="libs/ionrangeslider/js/ion.rangeSlider.min.js"></script>
    <script src="libs/inputNumber/js/inputNumber.js"></script>
    <script src="libs/bootstrap-switch/dist/js/bootstrap-switch.min.js"></script>
    <script src="libs/raphael/raphael-min.js"></script>
    <script src="libs/morris.js/morris.min.js"></script>
    <script src="libs/bootstrap-select/dist/js/bootstrap-select.min.js"></script>
    
    <script src="js/main.js"></script>
    <script src="js/demo.js"></script>
    
    
    <script src="common_html.js"></script>
EOF
;	
}
1;