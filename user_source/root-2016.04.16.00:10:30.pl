$s=<>;
@a=split / /,<>;
@a=sort @a;
foreach my $e(@a){
	chomp($e);
	print $e," ";
}
