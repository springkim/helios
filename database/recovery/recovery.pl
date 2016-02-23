#!/usr/bin/perl
use strict;
use warnings;
use DBI;
use MIME::Lite;
require 'info.pl';
my $file_str="";
my $database_table;
if($<!=0){print "you must execute in sudo\n";die;}
system "service apache2 stop";
system "./photo_upload.pl";
sub print_header() {
	$file_str=$file_str.'#!/usr/bin/perl' . "\n";
	$file_str=$file_str.'use strict;' . "\n";
	$file_str=$file_str.'use warnings;' . "\n";
	$file_str=$file_str.'use DBI;' . "\n";
	$file_str=$file_str.'if($<!=0){print "you must execute in sudo\n";die;}';
	$file_str=$file_str.'require \'info.pl\';' . "\n";
	
	$file_str=$file_str.'my $con = DBI->connect( GetDB(), GetUserName(), GetPassword() );'
	  . "\n";
}

sub print_end() {
	$file_str=$file_str.'$con->disconnect;' . "\n";
}

sub execute($$) {
	my $con   = DBI->connect( GetDB(), GetUserName(), GetPassword() );
	my $query = shift;
	my $table = shift;
	my $state = $con->prepare($query);
	$state->execute();
	while ( my @row = $state->fetchrow_array ) {
		$file_str=$file_str.'$con->do("INSERT INTO ' . $table . " VALUES(";
		my $str = "";
		foreach my $i (@row) {
			$str = $str . "\'" . $i . "\',";
		}
		chop $str;
		$str =~ s/\@/\\@/g;
		$file_str=$file_str.$str;
		$file_str=$file_str.")\");\n";
	}
	$state->finish();
	$con->disconnect;
}

sub SaveDatabase() {
	open( TEXT, "../table.txt" ) || die $!;
	$/ = undef;
	$database_table = <TEXT>;
	my @table = $database_table =~ /create table ([[:alpha:]|_|\d]*)/g;
	my $in;
	foreach $in (@table) {
		my $query = "SELECT * FROM $in";
		execute( $query, $in );
	}
}

sub SaveFile() {
	my $max_date = 3;
	opendir( DIR, "../recovery_src" ) || die print $!;
	my @files = readdir(DIR);
	@files=sort @files;
	shift @files;	#remove .
	shift @files;	#remove ..
	shift @files;	#remove drive_linux-x64
	shift @files;	#remove info.pl
	if($#files>=3-1){
		system "rm ../recovery_src/".$files[0];
	}
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime;
	my $date=($year+1900)."_".($mon+1)."_".$mday."_".$hour."_".$min."_".$sec;
	my $file_name="../recovery_src/r".$date.".pl";
	open FP,">",$file_name;
	print FP $file_str;
	close FP;
	system("chmod 755 $file_name");
	my $msg = MIME::Lite->new(
    'Return-Path' => 'bluecandle@bluecandle.me',
    'From'        => 'bluecandle@bluecandle.me',
    'To'          => 'helioscandle@gmail.com',
    'Subject'     => $date,
    'Charset'     => 'utf-8',
    'Encoding'    => '8bit',
    'Data'        => 'helios database recovery file'
    );
	$msg->attach(
        Type     => 'file',
        Path     => $file_name,
        Filename => $file_name,
        Disposition => 'attachment'
    );
	$msg->send;
}
sub print__data__(){
	$file_str=$file_str."__DATA__\n";
	$file_str=$file_str.$database_table;
}
sub ResetDataBase(){
	$file_str=$file_str.'
system "./drive-linux-x64 list -n> drivelist";
open FP,"<drivelist";
$/=undef;
my $file_data=<FP>;
close FP;
system "rm drivelist";
$file_data =~ s/\n/,/g;
my @ids= $file_data =~ /([^\s]+)(?:[\s]+)(?:[^\s]+)(?:[^,]+)(?:,)/g;
my @arr= $file_data =~ /(?:[^\s]+)(?:[\s]+)([^\s]+)(?:[^,]+)(?:,)/g;
sub GetPhotoFileId($$){
	my @arr=@{$_[0]};   #file list
    my @arr2=@{$_[1]};  #id list 
	my @ret;
	for(my $i=0;$i<=$#arr;$i++){
		$arr[$i]=~ m<.+\.(\w+)?$>;
		#".jpg", ".gif", ".bmp", ".png",".jpeg");
		if($1 eq "jpg" || $1 eq "gif" || $1 eq "bmp" || $1 eq "png" || $1 eq "jpeg"){
			push @ret,$arr2[$i];	
		} 
	}	
	return @ret;
}
my @gdrive=GetPhotoFileId(\@arr,\@ids);
if(-f "temp_photo"){
    system "rm -r temp_photo";
}
mkdir "temp_photo";
system "cp drive-linux-x64 temp_photo/";
chdir "temp_photo";
for(my $i=0;$i<=$#gdrive;$i++){
    system "./drive-linux-x64 download --id $gdrive[$i]";
}
system "rm drive-linux-x64";

sub DropTable($){
	my $data=shift;
	my @table= $data=~/create table ([[:alpha:]|_|\d]*)/g;
	my $query="drop table ";
	my $in;
	for(my $i=$#table;$i>=0;$i--){
		$con->do($query.$table[$i]);
	}
}
sub DeleteUserPhoto(){
	system("rm ../../../login/photo/*");
}
sub CreateTable($){
	my $data=shift;
	my @query=$data =~/([^;]*)/g;
	my $in;
	foreach $in(@query){
		chomp($in);
		if(length $in >3){
			$con->do($in);
		}
	}
}
$/=undef;
my $data=<DATA>;
DropTable($data);
DeleteUserPhoto();
system "mv * ../../../login/photo/";
system "rm -r ../temp_photo";
CreateTable($data);';
}
#===============
if($>){
	print "Use in root permission\n";
	die;	
}
print_header;
ResetDataBase;
SaveDatabase();
print_end;
print__data__;

SaveFile();
system "service apache2 start";