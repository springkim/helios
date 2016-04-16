#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;
require '../../login/info.pl';
my $q=new CGI;
my $con = DBI->connect( GetDB(), GetID(), GetPW() );
my $id=$q->param('ID');
my $salt=$q->param('SALT');


my $state=$con->prepare("SELECT count(*) FROM nonemail_certification WHERE ui_id=\'$id\' and nec_str=\'$salt\'");
$state->execute;
my @row=$state->fetchrow_array;
$state->finish;
if($row[0]==1){
	$con->do("DELETE FROM nonemail_certification WHERE ui_id=\'$id\'");
}

print $q->header(-charset=>"UTF-8");
print '
<html>
	<head>
		<script type="text/javascript">
			location.replace("../user.pl");
			location.href("../user.pl");
			history.go(-1);
			location.reload();
		</script>
	<head>
	<body>
	</body>
</html>
';
$con->disconnect();