#!/usr/bin/perl
use strict;
use warnings;
use DBI;
sub print_notice(){
	my $notice_href="main.pl";
	my $notice_list='';
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	my $state=$con->prepare("SELECT * FROM notice ORDER BY nt_optday DESC");
	$state->execute;
	my $i=0;
	while(my $row=$state->fetchrow_hashref){
			my $ntc='<div class="feed-widget__item feed-widget__item_product"><div class="feed-widget__ico"><i class="fa fa-fw"></i></div><div class="feed-widget__info">
			<div class="feed-widget__text"><b><a href="'.$notice_href.'">'.$row->{nt_title}.'</a></b><br>
			'.$row->{nt_content}.'</div><div class="feed-widget__date">'.$row->{nt_date}.'</div></div></div>';
			$notice_list.=$ntc;
			$i++;
			if($i>10){last;}
	}
	my $str='<div class="col-md-5">
                      <div class="panel panel-info">
                        <div class="panel-heading">
                          <h3 class="panel-title">Notice</h3>
                        </div>
                        <div class="feed-widget">
                          <div class="feed-widget__wrap scrollable scrollbar-macosx">
                            <div class="feed-widget__cont">
                              <div class="feed-widget__list">
                                '.$notice_list.'
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>';
                    return $str;
}
'드 넓은 하늘을 자유로이 나는 새처럼';