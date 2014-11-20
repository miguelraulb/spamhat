#!/usr/bin/perl

use Modules::Utils::Base;
use Modules::Spampot::Urls;
use Modules::Spampot::Subjects;
use Modules::Spampot::IPs;
use Modules::Spampot::Domains;
use Modules::Spampot::Attachments;
use Modules::Spampot::Downloader;
use Modules::Db::Connection;

sub ParseMail{
	my $fcaller			= shift;
    my $fname			= BASE::getFunctionName($fcaller,(caller(0))[3]);
	my $file_name		= shift;
	my $source_ip		= shift;
	my $source_port		= shift;
	my $destination_ip	= shift;
	my $destination_port	= shift;
	my $time	 	= BASE::getTimestamp("localtime","Tdate");

	my $dbh = ConnectDatabase("ParseMail");
	URLS::GetUrls("ParseMail","$CONFIG_VARS::spam_directory/$file_name",$file_name);
	SUBJECTS::GetSubjects("ParseMail","$CONFIG_VARS::spam_directory/$file_name");
	IPS::GetIPs("ParseMail","$CONFIG_VARS::spam_directory/$file_name");
	DOMAINS::GetDomains("ParseMail","$CONFIG_VARS::spam_directory/$file_name");
	ATTACHMENTS::DecodeAttachments("ParseMail","$CONFIG_VARS::spam_directory/$file_name",$file_name);
	BINARIES::GetSignatureList("ParseMail") if $URLS::with_url;
	InsertEvent("ParseMail",$time,$source_ip,$source_port,$destination_ip,$destination_port);
}
1;
