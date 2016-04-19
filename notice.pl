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
#==============================WRITE PERL CGI==============================
print $q->header(-charset=>"UTF-8");
print helios_html_head($q,$c_id);
print '<body class="framed main-scrollable"><div class="wrapper">';

print_header($c_id);
print '<div class="dashboard">';
print_sidemenu($c_id);
	
###################################################################################
my $state=$con->prepare("SELECT * FROM notice ORDER BY nt_date DESC");
$state->execute;
my $notice_str='';
my $notice_detail='';
my $idx=0;
my $jquery='<script>
	$(document).ready(function(){
		$("#nts0").css("display","block");
';
while(my $row=$state->fetchrow_hashref){
	my $title=$row->{nt_title};
	my $nid=$row->{ui_id};
	my $content=$row->{nt_content};
	my $simple_content=$content;
	$content=~s/\n/<br>/g;
	my $date=$row->{nt_date};
	my @sp=split /-/,$date;
	$date="$sp[1]/$sp[2]";
	$notice_str.='<div class="mailbox-item new" id="ntc'.$idx.'">
                          <div class="mailbox-item__head">
                           <div class="mailbox-item__tag tag_clients"><i class="fa fa-fw fa-tag"></i></div>
                            <div class="mailbox-item__name"><span>'.$title.'</span></div>
                            <div class="mailbox-item__date"><span>'.$date.'</span></div>
                          </div>
                          <div class="mailbox-item__body">
                            <div class="mailbox-item__text">'.$simple_content.'</div>
                          </div>
                        </div>';
     $notice_detail.='
     <div class="mailbox-mail" style="display:none" id="nts'.$idx.'">
                        <div class="mailbox-mail__head">
                          <div class="mailbox-mail__tag"><i class="fa fa-fw fa-tag"></i></div>
                          <div class="mailbox-mail__title">Notice contents.</div>
                        </div>
                        <div class="mailbox-mail__info">
                          <div class="mailbox-mail__photo"></div>
                          <div class="mailbox-mail__name"><span>작성자 : </span><span>'.$nid.'</span></div>
                          <div class="mailbox-mail__date">'.$date.'</div>
                        </div>
                        <div class="mailbox-mail__body">
                          <div class="mailbox-mail__text">
                          		'.$content.'
                          </div>
                        </div>
                      </div>
     ';
     $jquery.='
     $("#ntc'.$idx.'").click(function(){
     		$(".mailbox-mail").css("display","none");
			$("#nts'.$idx.'").css("display","block");
		})
     ';
     $idx++;
}
$jquery.='		
	});
</script>';
$state->finish;
##################################################################################
print '
<div class="main">
          <div class="main__scroll scrollbar-macosx">
            <div class="main__cont">
              <div class="mailbox">
                <div class="container-fluid half-padding">
                  <div class="row">
                    <div class="col-md-4">
                      <div class="mailbox__head">
                        <div class="mailbox__title"><span>Notice</span></div>
                        
                      </div>
                      <div class="panel-body">
                          <ol class="breadcrumb">
                            <li class="active">프로그래밍을 잘하자!!!</li>
                          </ol>
                        </div>
                      <div class="mailbox__list scrollable scrollbar-macosx">
                        	'.$notice_str.'
                        	</div>
                    </div>
                    <div class="col-md-8">
                      '.$notice_detail.'
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>';

##################################################################################
print '</div></div></div>';
print_js();
print $jquery;



print '<script src="libs/morris.js/morris.min.js"></script>';
###############################

###############################
print '</body></html>';
$con->disconnect;