#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
use MIME::Lite;
require '../../login/info.pl';
require '../../login/aes.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );

my $id=$q->param('ID');
if($id ne ''){
	my $state=$con->prepare("SELECT ui_email FROM userinfo WHERE ui_id=\'$id\'");
	$state->execute;
	my @row=$state->fetchrow_array;
	my $email=$row[0];
	$state->finish;
	my $salt='';
	$state=$con->prepare("SELECT nec_str FROM nonemail_certification WHERE ui_id=\'$id\'");
	$state->execute;
	@row=$state->fetchrow_array;
	$state->finish;
	$salt=$row[0];
	my $link="localhost/main/ajax/email_certification.pl?ID=$id&SALT=$salt";
	my $data='
	반갑습니다. Helios는 E-Mail을 인증해야 문제를 풀 수 있습니다.
	아래의 링크를 클릭하시면 자동으로 E-Mail인증이 완료 됩니다.
	';
	$data.=$link;
	$data.='
	감사합니다.
	';
	
	print $data."\n";
	my $msg = MIME::Lite->new(
	    'Return-Path' => '---',   #바꿔도 의미없음 왜있는지 모름
	    'From'        => 'helioscandle@gmail.com',
	    'To'          => $email,
	    'Subject'    =>  "Helios 이메일 인증입니다.",
	    'Charset'     => 'utf-8',
	    'Encoding'    => '8bit',
	    'Data'        => $data
	    );
	$msg->send;
}
$con->disconnect();