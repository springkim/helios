#!/usr/bin/perl
use strict;
use warnings;
use Array::Utils qw(:all);
sub GetPhotoFile($){
	my @arr=@{$_[0]};
	my @ret;
	for(my $i=0;$i<=$#arr;$i++){
		$arr[$i]=~ m<.+\.(\w+)?$>;
		#".jpg", ".gif", ".bmp", ".png",".jpeg");
		if($1 eq "jpg" || $1 eq "gif" || $1 eq "bmp" || $1 eq "png" || $1 eq "jpeg"){
			push @ret,$arr[$i];	
		} 
	}	
	return @ret;
}

system "./drive-linux-x64 list -n> drivelist";
open FP,"<drivelist";
$/=undef;
my $data=<FP>;
close FP;
$data =~ s/\n/,/g;
my @arr= $data =~ /(?:[^\s]+)(?:[\s]+)([^\s]+)(?:[^,]+)(?:,)/g;

my @gdrive=GetPhotoFile(\@arr);
my @localdrive;

opendir( DIR, "../../login/photo" ) || die print $!;
my @files = readdir(DIR);
foreach my $elem ( 0 .. $#files ) {
	if ( $files[$elem] ne '.' and $files[$elem] ne '..' ) {
		push @localdrive,$files[$elem];
	}
}
my @result=array_minus(@localdrive,@gdrive);

for(my $i=0;$i<=$#result;$i++){
	system "./drive-linux-x64 upload -f ../../login/photo/$result[$i] -p 0B0Gdoyw_P6rRWWRtRzlJYW1xYlk";	
}

