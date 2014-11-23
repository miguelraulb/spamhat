#!/usr/bin/perl

use strict;
use Modules::Db::Connection;
use Modules::Utils::Base;

sub CheckTables{
	my $fcaller			= shift;
	my $fname			= BASE::getFunctionName($fcaller,(caller(0))[3]);
	my $total;
	my $sql = "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '".$CONFIG_VARS::db_name."';";
	my $sth = $GLOBAL_VARS::DB_H->prepare($sql);
	$sth->execute or die "SQL Error: $DBI::errstr\n";
	
	while (my @row = $sth->fetchrow_array){
		$total=$row[0];
	}
	print "Checking the total of tables on DB: $total\n" if $GLOBAL_VARS::debug == 1;
	BASE::logMsgT($fname,"Checking the total of tables on DB: $total\n",2,$GLOBAL_VARS::LOG_FH);
	return $total;
}

sub CreateTables{
	my $fcaller			= shift;
	my $fname			= BASE::getFunctionName($fcaller,(caller(0))[3]);
	my $sql = "CREATE TABLE IF NOT EXISTS `Binaries` (`id_binary` int(11) not null auto_increment,`md5_list` varchar(1000),`id_event` int(11),PRIMARY KEY (`id_binary`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1; ";
	$GLOBAL_VARS::DB_H->do($sql);
	print "Created table Binaries\n" if $GLOBAL_VARS::debug == 1;
	BASE::logMsgT($fname,"Created table Binaries",2,$GLOBAL_VARS::LOG_FH);
	##################################################################
	$sql = "CREATE TABLE IF NOT EXISTS `Domains` (`id_domain` int(11) not null auto_increment,   `source_domain_list` varchar(500),`destination_domain_list`varchar(500),   `id_event` int(11),PRIMARY KEY (`id_domain`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;";
	$GLOBAL_VARS::DB_H->do($sql);
	print "Created table Domains\n" if $GLOBAL_VARS::debug == 1;
	BASE::logMsgT($fname,"Created table Domains",2,$GLOBAL_VARS::LOG_FH);
	##################################################################
	$sql = "CREATE TABLE IF NOT EXISTS `Events` (`id_event` int(11) not null auto_increment,`timestamp` varchar(30),`sensor` varchar(30),`source_ip` varchar(16),  `destination_ip` varchar(16),`source_port` int(11),`destination_port` int(11),PRIMARY KEY (`id_event`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;";
	$GLOBAL_VARS::DB_H->do($sql);
	print "Created table Events\n" if $GLOBAL_VARS::debug == 1;
	BASE::logMsgT($fname,"Created table Events",2,$GLOBAL_VARS::LOG_FH);   
	##################################################################
	$sql = "CREATE TABLE IF NOT EXISTS `IPs` (`id_ip` int(11) not null auto_increment,`ip_list` varchar(500),`id_event` int(11), PRIMARY KEY (`id_ip`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;";
	$GLOBAL_VARS::DB_H->do($sql);
	print "Created table IPs\n" if $GLOBAL_VARS::debug == 1;
	BASE::logMsgT($fname,"Created table IPs",2,$GLOBAL_VARS::LOG_FH);   
	##################################################################
	$sql = "CREATE TABLE IF NOT EXISTS `Subjects` (`id_subject` int(11) not null auto_increment,`subject_list` varchar(500),`id_event` int(11), PRIMARY KEY (`id_subject`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;";
	$GLOBAL_VARS::DB_H->do($sql);
	print "Created table Subjects\n" if $GLOBAL_VARS::debug == 1;
	BASE::logMsgT($fname,"Created table Subjects",2,$GLOBAL_VARS::LOG_FH);    
	##################################################################
	$sql = "CREATE TABLE IF NOT EXISTS `Urls` (`id_url` int(11) not null auto_increment,`url_list` varchar(500),`id_event` int(11), PRIMARY KEY (`id_url`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;";
	$GLOBAL_VARS::DB_H->do($sql);
	print "Created table Urls\n" if $GLOBAL_VARS::debug == 1;
	BASE::logMsgT($fname,"Created table Urls",2,$GLOBAL_VARS::LOG_FH);
	##################################################################
	$sql = "CREATE TABLE IF NOT EXISTS `Usernames` (`id_username` int(11) not null auto_increment,`user_list` varchar(500),`id_event` int(11), PRIMARY KEY (`id_username`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;";
	$GLOBAL_VARS::DB_H->do($sql);
	print "Created table Usernames\n" if $GLOBAL_VARS::debug == 1;
	BASE::logMsgT($fname,"Created table Usernames",2,$GLOBAL_VARS::LOG_FH);
}
1;
