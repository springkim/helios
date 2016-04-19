system 'git add -A';
print 'commit : ';
$s=<>;
system "git commit -m \"$s\"";
system "git push origin master";
