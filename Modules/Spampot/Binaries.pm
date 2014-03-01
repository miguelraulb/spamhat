#!/usr/bin/perl
use strict;
use Modules::Utils::Base;
use Digest::MD5::File qw( file_md5_hex );

package BINARIES;
	our $binary;
	our $attachment=0;
	our $downloaded=0;

sub GetSignatureList{
	my $fcaller		= shift;
	my $fname		= BASE::getFunctionName($fcaller,(caller(0))[3]);
	
	if($URLS::with_url){
		BASE::logMsgT($fcaller,"Getting signatures of downloaded files",2,$GLOBAL_VARS::LOG_FH);
		opendir(DIR,"$CONFIG_VARS::binaries_output/$ATTACHMENTS::name_folder/") || BASE::logMsgT($fcaller,"Error opening directory: $CONFIG_VARS::binaries_output",-1,$GLOBAL_VARS::LOG_FH);
		while(my $file = readdir(DIR)){
			# Ignore files beginning with . or ..
			next if ($file =~ m/^\./);
			my $md5 = Digest::MD5::File::file_md5_hex("$CONFIG_VARS::binaries_output/$ATTACHMENTS::name_folder/$file");
			print "Signed file: $file - $md5\n" if $CONFIG_VARS::debug == 1;
			BASE::logMsgT($fcaller,"Signed file: $file - $md5",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
			$BINARIES::binary{$md5}++;
			$BINARIES::downloaded=1;
		}
		close(DIR);
	}
	
	if($ATTACHMENTS::with_attachment){
		BASE::logMsgT($fcaller,"Getting signatures of decoded files",2,$GLOBAL_VARS::LOG_FH);
		opendir(DIR,"$CONFIG_VARS::attachments_output/$ATTACHMENTS::name_folder/") || BASE::logMsgT($fcaller,"Error opening directory: $CONFIG_VARS::attachments_output",-1,$GLOBAL_VARS::LOG_FH);
		while(my $file = readdir(DIR)){
			# Ignore files beginning with . or ..
			next if ($file =~ m/^\./);
			my $md5 = Digest::MD5::File::file_md5_hex("$CONFIG_VARS::attachments_output/$ATTACHMENTS::name_folder/$file");
			print "Signed file: $file - $md5\n" if $CONFIG_VARS::debug == 1;
			BASE::logMsgT($fcaller,"Signed file: $file - $md5",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
			$BINARIES::binary{$md5}++;
			$BINARIES::attachment=1;
		}
		close(DIR);
	}
}
1;
