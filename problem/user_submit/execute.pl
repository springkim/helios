#!/usr/bin/perl
use strict;
use warnings;
use DBI;
require "../../login/info.pl";
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $state;
my $state2;
my @values;
my @elem;
my $query = "SELECT * FROM userinfo_problem WHERE uip_status=\'WAIT\' ORDER BY uip_date DESC";
while(1){
	$state=$con->prepare($query);
	$state->execute;
	while(my $row = $state->fetchrow_hashref){
		print $row->{pr_path}."\n";
		$state2= $con->prepare("SELECT * FROM problem WHERE pr_path=\'$row->{pr_path}\' ");	#tl ,ml
		$state2->execute;
		my $row2 = $state2->fetchrow_hashref;
		my $tl = $row2->{pr_timelimit};
		my $ml = $row2->{pr_memlimit};
		$state2->finish;
		$state->finish;
		#get problem number
		my @pnum = split( '/', $row->{pr_path});
		$pnum[2] =~ /(\w+).html/;
		
		my $cmd="./sandbox $row->{uip_srcpath}  $tl $ml $row->{ui_id} $1 |";
		print $cmd."\n";
		my $p = open(RUN,$cmd)||die $!;
		my $real_tl;
		$/=undef;
		my $out = <RUN>;
		close RUN;
		$out =~ /([a-z|A-Z]+)/;
		my $result= $1;
		print $out;
		###########################
		if($result eq "Accepted"){
			$real_tl = substr($out,9,14);  
			$out = "Accepted";
		}else{
			$real_tl = $tl;
		}
		$con->do("UPDATE userinfo_problem SET uip_status=\'$out\' ,uip_time=\'$real_tl\' WHERE uip_srcpath=\'$row->{uip_srcpath}\' and uip_date=\'$row->{uip_date}\'");
		#$con->do("INSERT INTO userinfo_problem VALUES(\'$row->{pr_path}\', \'$row->{ui_id}\',\'$row->{uip_language}\',\'$real_tl\', \'$out[0]\', \'$row->{uip_date}\',\'$row->{uip_srcpath}\' ");
	}
}



$con->disconnect;
