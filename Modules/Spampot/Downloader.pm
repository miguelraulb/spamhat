#!/usr/bin/perl 

use strict;
use Modules::Utils::Base;

package DOWNLOADS;

sub DownloadURL{
	my $fcaller		= shift;
	my $fname		= BASE::getFunctionName($fcaller,(caller(0))[3]);
	my $url			= shift;
	my $name_folder	= shift;
	my $ua			= LWP::UserAgent->new();
	my $response;
	my $file;
	my $filename = $url;
	$filename =~ m/.*\/(.*)$/;
	$filename = $1;
		
	$response = $ua->get($url);
	return "1" if !$response->is_success;
	#die $response->status_line if !$response->is_success;
	$file = $response->decoded_content( charset => 'none' );
	print "Downloading File: $filename\n" if $CONFIG_VARS::debug == 1;
	BASE::logMsgT($fcaller,"Downloading File: $filename",2,$GLOBAL_VARS::LOG_FH);
	print "Path: $CONFIG_VARS::binaries_output/$name_folder/$filename\n" if $CONFIG_VARS::debug == 1;
	BASE::logMsgT($fcaller,"Downloading URLs",2,$GLOBAL_VARS::LOG_FH);
	unless(-d "$CONFIG_VARS::binaries_output/$name_folder"){
		mkdir "$CONFIG_VARS::binaries_output/$name_folder";
		print "Created directory $CONFIG_VARS::binaries_output/$name_folder\n" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fcaller,"Created directory $CONFIG_VARS::binaries_output/$name_folder",2,$GLOBAL_VARS::LOG_FH);	
	}
	LWP::Simple::getstore($url,"$CONFIG_VARS::binaries_output/$name_folder/$filename");
	return 0;
}
1;
