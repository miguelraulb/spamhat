#!/usr/bin/perl
###############################################################################
## This file is free software; as a special exception the author gives       ##
## unlimited permission to copy and/or distribute it, with or without        ##
## modifications, as long as this notice is preserved.                       ##
##                                                                           ##
## This program is distributed in the hope that it will be useful, but       ##
## WITHOUT ANY WARRANTY, to the extent permitted by law; without even the    ##
## implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  ##
##                                                                           ##
###############################################################################
## Honeynet Project UNAM-Chapter                                             ##
## SSI/UNAM-CERT                                                             ##
## honeynet@seguridad.unam.mx                                                ##
## www.seguridad.unam.mx/www.cert.org.mx/www.honeynet.unam.mx                ##
##                                                                           ##
###############################################################################
## Spampot Tool and Spam Processor V1.0                                      ##
## By [Miguel Bautista] [mbautista@seguridad.unam.mx, miguelraulb@gmail.com] ##
## Date [2013-02-23]                                                         ##
## ------------------------------------------------------------------------- ##
## Abstract:                                                                 ##
###############################################################################
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
	my $time	 			= BASE::getTimestamp("localtime","Tdate");

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
