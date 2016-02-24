#!/usr/bin/perl
use strict;
use warnings;
open FP,"<test.html";
$/=undef;
my $str=<FP>;
print $str;
close FP;
