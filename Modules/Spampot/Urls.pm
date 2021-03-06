#!/usr/bin/perl
use strict;
use Modules::Utils::Base;
use Modules::Spampot::Regex;
use Modules::Spampot::Downloader;

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
	BASE::logMsgT($fname,"Getting URLs",2,$GLOBAL_VARS::LOG_FH);
	open(FH,$file_name) || BASE::logMsgT($fname,"Error opening mail file: $file_name",-1,$GLOBAL_VARS::LOG_FH);
	while(<FH>){
		chomp($_);
		if($_ =~ /($REGEX::url)/){
			print "Matched URL: $&\n" if $CONFIG_VARS::debug == 1;
			BASE::logMsgT($fname,"Matched URL: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
			$URLS::url{$&}++;
			$URLS::with_url=1;
		}
	}
	close(FH);
	
	#Check if there was only one URL, instead do nothing
	if ($URLS::with_url){
	
		open(FH_BP,$CONFIG_VARS::blacklist_pattern) || BASE::logMsgT($fname,"Error opening blacklist pattern file: $CONFIG_VARS::blacklist_pattern",-1,$GLOBAL_VARS::LOG_FH);
		open(FH_BD,$CONFIG_VARS::blacklist_domain) || BASE::logMsgT($fname,"Error opening blacklist pattern file: $CONFIG_VARS::blacklist_pattern",-1,$GLOBAL_VARS::LOG_FH);
		BASE::logMsgT($fname,"Looking blacklist patterns on URLs",2,$GLOBAL_VARS::LOG_FH);
		foreach my $index (sort { $URLS::url{$b} <=> $URLS::url{$a} || $a cmp $b } keys %URLS::url){
			#Pattern Comparison
			while(<FH_BP>){
				chomp($_);
				if($index =~ /$_/){
					print "Matched Pattern: $&\n" if $CONFIG_VARS::debug == 1;
					BASE::logMsgT($fname,"Matched Pattern: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
					$pattern{$&}++;
				}
			}
			#Domain Comparison
			while(<FH_BD>){
				chomp($_);
				if($index =~ /$_/){
					print "Matched Domain: $&\n" if $CONFIG_VARS::debug == 1;
					BASE::logMsgT($fname,"Matched Domain: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
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
					BASE::logMsgT($fname,"Error downloading URL: $var",1,$GLOBAL_VARS::LOG_FH);
				}
			}
		}
	}
}
1;
