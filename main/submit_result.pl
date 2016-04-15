#!/usr/bin/perl
use strict;
use warnings;
use DBI;
sub print_submit_result($){
	my $id=shift;
	my $show_all_href="problem_status.pl";
	my $msg_cnt='0';
	my $submit_data='';
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	if($id){
		my $state=$con->prepare("SELECT count(*) FROM userinfo_problem WHERE ui_id=\'$id\' and uip_status=\'wait\'");
		$state->execute;
		my @row=$state->fetchrow_array;
		$state->finish;
		$msg_cnt=$row[0];
		$state=$con->prepare("SELECT * FROM userinfo_problem WHERE ui_id=\'$id\' ORDER BY uip_date DESC");
		$state->execute;
		my $i=0;
		while(my $row=$state->fetchrow_hashref){
			my $path=$row->{pr_path};
			my $state2=$con->prepare("SELECT pr_title FROM problem WHERE pr_path=\'$path\'");
			$state2->execute;
			my @row2=$state2->fetchrow_array;
			my $problem=$row2[0];
			my $date=$row->{uip_date};
			my $text=$row->{uip_status};
			$submit_data.="<div class=\"sp-widget__item\">
                                  <div class=\"sp-widget__user\">
                                  <a href=\"#\"><strong>$problem</strong></a>
                                  <span class=\"sp-widget__date\">, $date</span></div>
                                  <div class=\"sp-widget__text\">$text</div>
                                </div>";
				$i++;
				if($i==10){last;}
		}
		$state->finish;
	}else{
		$show_all_href='#';	
	}
	my $str=' <div class="col-md-4">
                      <div class="panel panel-danger">
                        <div class="panel-heading panel-heading_label">
                          <h3 class="panel-title">Submit result</h3>
                          <div class="label label-danger">'.$msg_cnt.'</div>
                        </div>
                        <div class="sp-widget">
                          <div class="sp-widget__wrap scrollable scrollbar-macosx">
                            <div class="sp-widget__cont">
                              <div class="sp-widget__top">
                                <div class="sp-widget__info">
                                  <div class="sp-widget__title"><i class="fa fa-envelope-o"></i><span>'.$msg_cnt.' Receved</span></div>
                                </div>
                                <div class="sp-widget__all"><a href="'.$show_all_href.'" class="btn btn-default btn-block">Show All</a></div>
                              </div>
                              <div class="sp-widget__list">
                                '.$submit_data.'
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>';
                    return $str;
}
'Money Honey';