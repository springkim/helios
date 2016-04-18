#!/usr/bin/perl
use strict;
use warnings;
use DBI;
require "library/info.pl";
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $state;
my $state2;
my @values;
my @elem;
my $query = "SELECT * FROM userinfo_problem WHERE uip_status=\'wait\' ORDER BY uip_date DESC";
while(1){
	$state=$con->prepare($query);
	$state->execute;
	while(my $row = $state->fetchrow_hashref){
		print $row->{pr_optnum}."번 채점 시작합니다.\n";
		$state2= $con->prepare("SELECT * FROM problem WHERE pr_optnum=\'$row->{pr_optnum}\' ");	#tl ,ml
		$state2->execute;
		my $row2 = $state2->fetchrow_hashref;
		my $tl = $row2->{pr_timelimit};
		my $ml = $row2->{pr_memlimit};
		$state2->finish;
		$state->finish;
		#get problem number
		my $inout="problem_repository/$row2->{pr_group}/$row2->{pr_title}";
		$inout=~s/ /\\ /g;
		my $language=$row->{uip_language};
		if($language eq 'C'){
			$language='c';	
		}elsif($language eq 'C++'){
			$language='cpp';
		}elsif($language eq 'Perl'){
			$language='pl';
		}elsif($language eq 'Pascal'){
			$language='pas';
		}
		my $cmd="./sandbox $row->{uip_srcpath}  $tl $ml $inout/in.txt $inout/out.txt $row->{ui_id} $language ";
		if($row2->{pr_type} eq 'acm'){
			$cmd.='0';	
		}elsif($row2->{pr_type} eq 'topcoder'){
			$cmd.="$inout/main.c";
		}
		
		print $cmd."\n";
		system("$cmd > robot1");
		open(RUN,"robot1")||die $!;
		$/="\n";
		my $result = <RUN>;
		chomp($result);
		print $result,"\n";
		my $time="0";
		if($result eq 'accepted' or $result eq 'wrong answer'){
			$time=<RUN>;
			chomp($time);
			$time=sprintf("%.3f",$time);
			
		}elsif($result eq 'compile error'){
			$/=undef;
			my $msg=<RUN>;
			chomp($msg);
			$result.="\n$msg";	
		}
		close RUN;
		unlink "robot1";
		$con->do("UPDATE userinfo_problem SET uip_status=\'$result\' ,uip_time=\'$time\' WHERE uip_srcpath=\'$row->{uip_srcpath}\' and uip_date=\'$row->{uip_date}\'");
	}
}
$con->disconnect;
