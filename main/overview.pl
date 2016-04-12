#!/usr/bin/perl
use strict;
use warnings;
use DBI;
sub print_overview(){
	my $con = DBI->connect( GetDB(), GetID(), GetPW() );
	my $state=$con->prepare("SELECT count(ui_id) FROM userinfo");
	$state->execute;
	my @row=$state->fetchrow_array;
	my $total_user=$row[0];
	$state->finish;
	$state=$con->prepare("SELECT count(*) FROM userlog");
	$state->execute;
	@row=$state->fetchrow_array;
	my $visit=$row[0];
	$state->finish;
	$state=$con->prepare("SELECT count(*) FROM problem");
	$state->execute;
	@row=$state->fetchrow_array;
	my $problem=$row[0];
	$state->finish;
	$state=$con->prepare("SELECT count(*) FROM userinfo_problem");
	$state->execute;
	@row=$state->fetchrow_array;
	my $submited=$row[0];
	$state->finish;
	$state=$con->prepare("SELECT count(DISTINCT pr_path) FROM userinfo_problem WHERE uip_status=\'accepted\'");
	$state->execute;
	@row=$state->fetchrow_array;
	my $conquest=($row[0]/$problem)*100;
	$state->finish;
	my $str='<div class="col-md-3">
                      <div class="panel panel-success">
                        <div class="panel-heading">
                          <h3 class="panel-title">Overview</h3>
                        </div>
                        <div class="panel-body">
                          <div class="ov-widget">
                            <div class="ov-widget__list">
                              <div class="ov-widget__item ov-widget__item_inc">
                                <div class="ov-widget__value">'.$total_user.'</div>
                                <div class="ov-widget__info">
                                  <div class="ov-widget__title">Total users</div>
                                  <div class="ov-widget__item"><i class="fa fa-user" style="float:right"></i></div>
                                </div>
                              </div>
                              <div class="ov-widget__item ov-widget__item_warn">
                                <div class="ov-widget__value">'.$visit.'</div>
                                <div class="ov-widget__info">
                                  <div class="ov-widget__title">Visits</div>
                                  		<div class="ov-widget__item"><i class="fa fa-thumbs-up" style="float:right"></i></div>
                                </div>
                              </div>
                              <div class="ov-widget__item ov-widget__item_dec">
                                <div class="ov-widget__value">'.$problem.'</div>
                                <div class="ov-widget__info">
                                  <div class="ov-widget__title">Problems</div>
                               <div class="ov-widget__item"><i class="fa fa-key" style="float:right"></i></div>
                                </div>
                              </div>
                              
                              <div class="ov-widget__item ov-widget__item_tack">
                                <div class="ov-widget__value">'.$submited.'</div>
                                <div class="ov-widget__info">
                                  <div class="ov-widget__title">Submited</div>
                                  <div class="ov-widget__item"><i class="fa fa-paper-plane" style="float:right"></i></div>
                                </div>
                              </div>
                              
                              <div class="ov-widget__bar"><span>The conquest problem</span>
                                <div class="progress">
                                  <div role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: '.$conquest.'%" class="progress-bar progress-bar-info"></div>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>';
                    return $str;
}
1;