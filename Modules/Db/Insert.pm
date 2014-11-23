#!/usr/bin/perl

use strict;

use DBI;
use Modules::Utils::Base;
use Modules::Spampot::Binaries;

sub InsertEvent{
	my $fcaller		= shift;
	my $fname		= BASE::getFunctionName($fcaller,(caller(0))[3]);
	my $id;
	my $list="";
	my $timestamp			= shift;
	my $source_ip			= shift;
	my $source_port			= shift;
	my $destination_ip		= shift;
	my $destination_port		= shift;
	# ##############################################################################
	# # Insert Event
	my $sql = "INSERT INTO Events (timestamp,sensor,source_ip,destination_ip,source_port,destination_port) VALUES ('$timestamp','$CONFIG_VARS::sensor_name','$source_ip','$destination_ip','$source_port','$destination_port');";
	my $sth = $CONFIG_VARS::DB_H->prepare($sql);
	$sth->execute || die "SQL Insert Error: $DBI::errstr\n";
	$id=$sth->{mysql_insertid};
	print "Inserted Event with ID: $id\n" if $CONFIG_VARS::debug == 1;
	BASE::logMsgT($fname,"Inserted event with ID: $id",2,$GLOBAL_VARS::LOG_FH);
	##############################################################################
	# Retrieve and Insert URLs
	if($URLS::with_url){
		foreach my $var (keys %URLS::url){
			$list.="$var|$URLS::url{$var},";
		}
		$list=substr($list,0,-1); # Get rid of the last comma
		$sql = "INSERT INTO Urls (url_list,id_event) VALUES ('$list','$id');";
		$sth = $CONFIG_VARS::DB_H->prepare($sql);
		$sth->execute || die "SQL Insert Error: $DBI::errstr\n";
		print "Inserted Urls for event [$id]\n" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fname,"Inserted Urls for event [$id]",2,$GLOBAL_VARS::LOG_FH);
		$list="";
	}
	###############################################################################
	# Retrieve and Insert Subjects
	if($SUBJECTS::with_subject){
		foreach my $var (keys %SUBJECTS::subject){
			$list.="$var|$SUBJECTS::subject{$var},";
		}
		$list=substr($list,0,-1); # Get rid of the last comma
		$sql = "INSERT INTO Subjects (subject_list,id_event) VALUES ('$list','$id');";
		$sth = $CONFIG_VARS::DB_H->prepare($sql);
		$sth->execute || die "SQL Insert Error: $DBI::errstr\n";
		print "Inserted Subjects for event [$id]\n" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fname,"Inserted Subjects for event [$id]",2,$GLOBAL_VARS::LOG_FH);
		$list="";
	}
	###############################################################################
	# Retrieve and Insert IPs
	if($IPS::with_ip){
		foreach my $var (keys %IPS::ip){
			$list.="$var|$IPS::ip{$var},";
		}
		$list=substr($list,0,-1); # Get rid of the last comma
		$sql = "INSERT INTO IPs (ip_list,id_event) VALUES ('$list','$id');";
		$sth = $CONFIG_VARS::DB_H->prepare($sql);
		$sth->execute || die "SQL Insert Error: $DBI::errstr\n";
		print "Inserted IPs for event [$id]\n" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fname,"Inserted IPs for event [$id]",2,$GLOBAL_VARS::LOG_FH);
		$list="";
	}
	###############################################################################
	# Retrieve and Insert Domains
	if($DOMAINS::with_domain){
		foreach my $var (keys %DOMAINS::source){
			$list.="$var|$DOMAINS::source{$var},";
		}
		my $list2="";
		foreach my $var (keys %DOMAINS::destination){
			$list2.="$var|$DOMAINS::destination{$var},";
		}
		$list=substr($list,0,-1); # Get rid of the last comma
		$list2=substr($list2,0,-1); # Get rid of the last comma
		$sql = "INSERT INTO Domains (source_domain_list,destination_domain_list,id_event) VALUES ('$list','$list2','$id');";
		$sth = $CONFIG_VARS::DB_H->prepare($sql);
		$sth->execute || die "SQL Insert Error: $DBI::errstr\n";
		print "Inserted Domains for event [$id]\n" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fname,"Inserted Domains for event [$id]",2,$GLOBAL_VARS::LOG_FH);
		$list="";
		$list2="";
	}
	###############################################################################
	# Retrieve and Insert Mails
	if($DOMAINS::with_mail){
		foreach my $var (keys %DOMAINS::mails){
			$list.="$var|$DOMAINS::mails{$var},";
		}
		$list=substr($list,0,-1); # Get rid of the last comma
		$sql = "INSERT INTO Usernames (user_list,id_event) VALUES ('$list','$id');";
		$sth = $CONFIG_VARS::DB_H->prepare($sql);
		$sth->execute || die "SQL Insert Error: $DBI::errstr\n";
		print "Inserted Usernames for event [$id]\n" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fname,"Inserted Usernames for event [$id]",2,$GLOBAL_VARS::LOG_FH);
		$list="";
	}
	#############################################################################
	# Retrieve and Insert Binaries
	if($BINARIES::attachment or $BINARIES::downloaded){
		foreach my $var (keys %BINARIES::binary){
			$list.="$var|$BINARIES::binary{$var},";
		}
		$list=substr($list,0,-1); # Get rid of the last comma
		$sql = "INSERT INTO Binaries (md5_list,id_event) VALUES ('$list','$id');";
		$sth = $CONFIG_VARS::DB_H->prepare($sql);
		$sth->execute || die "SQL Insert Error: $DBI::errstr\n";
		print "Inserted Binaries for event [$id]\n" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fname,"Inserted Binaries for event [$id]",2,$GLOBAL_VARS::LOG_FH);
		$list="";
	}
	###############################################################################
}

1;
