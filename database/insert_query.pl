#!/usr/bin/perl
use strict;
use warnings;
use DBI;
require 'info.pl';



my $con = DBI->connect( GetDB(), GetUserName(), GetPassword() );
if(undef){
$con->do("INSERT INTO userinfo_emblem VALUES(\'c\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
$con->do("INSERT INTO userinfo_emblem VALUES(\'cpp\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
$con->do("INSERT INTO userinfo_emblem VALUES(\'perl\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
$con->do("INSERT INTO userinfo_emblem VALUES(\'java\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
$con->do("INSERT INTO userinfo_emblem VALUES(\'pascal\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
$con->do("INSERT INTO userinfo_emblem VALUES(\'python\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
$con->do("INSERT INTO userinfo_emblem VALUES(\'fortran\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
$con->do("INSERT INTO userinfo_emblem VALUES(\'r\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
$con->do("INSERT INTO userinfo_emblem VALUES(\'lisp\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");

$con->do("INSERT INTO userinfo_emblem VALUES(\'list\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
$con->do("INSERT INTO userinfo_emblem VALUES(\'tree\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
$con->do("INSERT INTO userinfo_emblem VALUES(\'graph\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\')");
}

$con->do("INSERT INTO userinfo_problem VALUES(\'problem/problem_list/e0004.html\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\',\'c\',\'0.00\',\'accepted\')");
$con->do("INSERT INTO userinfo_problem VALUES(\'problem/problem_list/e0002.html\',\'a9c39dc9078d3b9b8dc32f716ceba51aaada9c569cb8b02754ebeb02723b2a822dfeb212b563af5d2ff704dcc4d02228770b66c6ea39df3680b771d89d84af99\',\'c\',\'0.58\',\'time limit\')");	
	
$con->disconnect;
	
