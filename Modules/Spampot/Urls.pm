#!/usr/bin/perl
use strict;
use Modules::Utils::Base;
use Modules::Spampot::Regex;
use Modules::Spampot::Downloader;
use IPC::System::Simple qw(system systemx capture capturex);

package URLS;
	our %url;
	our $with_url=0;

sub GetUrls{
	my $fcaller		= shift;
	my $fname		= BASE::getFunctionName($fcaller,(caller(0))[3]);
	my $file_name 	= shift;
	my $name_folder	= shift;
	my $dl_code;
	my %pattern;
	my %domain;
	
	#URL REGEX Comparison
	BASE::logMsgT($fcaller,"Getting URLs",2,$GLOBAL_VARS::LOG_FH);
	open(FH,$file_name) || BASE::logMsgT($fcaller,"Error opening mail file: $file_name",-1,$GLOBAL_VARS::LOG_FH);
	while(<FH>){
		chomp($_);
		if($_ =~ /($REGEX::url)/){
			print "Matched URL: $&\n" if $CONFIG_VARS::debug == 1;
			BASE::logMsgT($fcaller,"Matched URL: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
			$URLS::url{$&}++;
			$URLS::with_url=1;
		}
	}
	close(FH);
	
	#Check if there was only one URL, instead do nothing
	if ($URLS::with_url){
	
		open(FH_BP,$CONFIG_VARS::blacklist_pattern) || BASE::logMsgT($fcaller,"Error opening blacklist pattern file: $CONFIG_VARS::blacklist_pattern",-1,$GLOBAL_VARS::LOG_FH);
		open(FH_BD,$CONFIG_VARS::blacklist_domain) || BASE::logMsgT($fcaller,"Error opening blacklist pattern file: $CONFIG_VARS::blacklist_pattern",-1,$GLOBAL_VARS::LOG_FH);
		BASE::logMsgT($fcaller,"Looking blacklist patterns on URLs",2,$GLOBAL_VARS::LOG_FH);
		foreach my $index (sort { $URLS::url{$b} <=> $URLS::url{$a} || $a cmp $b } keys %URLS::url){
			#Pattern Comparison
			while(<FH_BP>){
				chomp($_);
				if($index =~ /$_/){
					print "Matched Pattern: $&\n" if $CONFIG_VARS::debug == 1;
					BASE::logMsgT($fcaller,"Matched Pattern: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
					$pattern{$&}++;
				}
			}
			#Domain Comparison
			while(<FH_BD>){
				chomp($_);
				if($index =~ /$_/){
					print "Matched Domain: $&\n" if $CONFIG_VARS::debug == 1;
					BASE::logMsgT($fcaller,"Matched Domain: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
					$domain{$&}++;
				}
			}
		}
		close(FH_BP);
		close(FH_BD);
	
		if($CONFIG_VARS::enable_url_dl and $URLS::with_url){
			foreach my $var (keys %url){
				$dl_code = DOWNLOADS::DownloadURL("GetUrls",$var,$name_folder);
				if($dl_code == "1"){
					print "Error downloading URL: $var\n" if $CONFIG_VARS::debug == 1;
					BASE::logMsgT($fcaller,"Error downloading URL: $var",1,$GLOBAL_VARS::LOG_FH);
				}
			}
		}
	
		
		if($CONFIG_VARS::phoneyc){
			print "Calling PhoneyC\n" if $CONFIG_VARS::debug == 1;
			BASE::logMsgT($fcaller,"Calling PhoneyC",2,$GLOBAL_VARS::LOG_FH);
			BASE::logMsgT($fcaller,"Calling PhoneyC",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
			foreach my $index (keys %url){
				PhoneyC("GetUrls",$index);
			}
		}
	}
}

sub PhoneyC{
        my $fcaller     = shift;
        my $fname       = BASE::getFunctionName($fcaller,(caller(0))[3]);
        my $url   	= shift;

	print "Analyzing URL: $url\n" if $CONFIG_VARS::debug == 1;
	BASE::logMsgT($fcaller,"Analyzing URL: $url",2,$GLOBAL_VARS::LOG_FH);
	BASE::logMsgT($fcaller,"Analyzing URL: $url",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
	my $output 	= capturex($CONFIG_VARS::phoneyc_path, $url);
	print "PhoneyC output: $output\n" if $CONFIG_VARS::debug == 1;
	BASE::logMsgT($fcaller,"PhoneyC output: $output",2,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
	BASE::logMsgT($fcaller,"PhoneyC output: $output",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
	open(FH_PhC,">>$CONFIG_VARS::phoneyc_log") || BASE::logMsgT($fcaller,"Error opening PhoneyC log file",-1,$GLOBAL_VARS::LOG_FH);
	print FH_PhC "Analysis of URL [$url] by PhoneyC: $output\n";
	close(FH_PhC);
}
1;
