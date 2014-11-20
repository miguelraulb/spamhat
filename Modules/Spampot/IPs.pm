#!/usr/bin/perl
use strict;
use Modules::Utils::Base;
use Modules::Spampot::Regex;

package IPS;
	our %ip;
	our $with_ip=0;
	
sub GetIPs{
	my $fcaller	= shift;
	my $fname	= BASE::getFunctionName($fcaller,(caller(0))[3]);
	my $file_name 	= shift;

	BASE::logMsgT($fcaller,"Getting IPs",2,$GLOBAL_VARS::LOG_FH);
	open(FH,$file_name) || BASE::logMsgT($fcaller,"Error opening mail file: $file_name",-1,$GLOBAL_VARS::LOG_FH);
	while(<FH>){
		chomp($_);
		#while($_=~/($REGEX::ip)/ && $_=~/^Received: from/){
		if($_ =~ /($REGEX::ip)/){
			print "Matched IP: $&\n" if $CONFIG_VARS::debug == 1;
            BASE::logMsgT($fcaller,"Matched IP: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
			$IPS::ip{$&}++;
			$IPS::with_ip=1;
		}
	}
	close(FH);
}
1;
