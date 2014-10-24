#!/usr/bin/perl

use strict;

use DBI;
use DBD::mysql;
use Modules::Utils::Base;

sub ConnectDatabase{
	my $fcaller		= shift;
	my $fname		= BASE::getFunctionName($fcaller,(caller(0))[3]);
	$CONFIG_VARS::DB_H = DBI->connect("DBI:$CONFIG_VARS::db_connector:dbname=$CONFIG_VARS::db_name;host=$CONFIG_VARS::db_host;port=$CONFIG_VARS::db_port","$CONFIG_VARS::db_user","$CONFIG_VARS::db_passwd", {mysql_no_autocommit_cmd => 1}) or die "Error: $DBI::errstr\n";
	print "Connected to database:"."DBI:$CONFIG_VARS::db_connector:dbname=$CONFIG_VARS::db_name;host=$CONFIG_VARS::db_host;port=$CONFIG_VARS::db_port"."\n" if $CONFIG_VARS::debug == 1;
	BASE::logMsgT($fcaller,"Connected to database:$CONFIG_VARS::db_connector:$CONFIG_VARS::db_name",2,$GLOBAL_VARS::LOG_FH);
}
1;
