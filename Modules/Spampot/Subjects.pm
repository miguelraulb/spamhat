#!/usr/bin/perl
use strict;
use Modules::Utils::Base;
use Modules::Spampot::Regex;

package SUBJECTS;
	our %subject;
	our $with_subject=0;
	
sub GetSubjects{
	my $fcaller	= shift;
	my $fname	= BASE::getFunctionName($fcaller,(caller(0))[3]);
	my $file_name 	= shift;
	my %pattern;
	my %domain;
	
	#Subject REGEX Comparison
	BASE::logMsgT($fcaller,"Getting Subjects",2,$GLOBAL_VARS::LOG_FH);
	open(FH,$file_name) || BASE::logMsgT($fcaller,"Error opening mail file: $file_name",-1,$GLOBAL_VARS::LOG_FH);
	while(<FH>){
		chomp($_);
		if($_ =~ m/($REGEX::subject)/i){
			print "Matched Subject: $'\n" if $CONFIG_VARS::debug == 1;
			BASE::logMsgT($fcaller,"Matched Subject: $'",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
			$SUBJECTS::subject{$'}++;
			$SUBJECTS::with_subject=1;
		}
	}
	close(FH);
	
	#Check if there was only one Subject, instead do nothing
	if($SUBJECTS::with_subject){
	
		open(FH_BP,$CONFIG_VARS::blacklist_pattern) || BASE::logMsgT($fcaller,"Error opening blacklist pattern file: $file_name",-1,$GLOBAL_VARS::LOG_FH);
		open(FH_BD,$CONFIG_VARS::blacklist_domain) || BASE::logMsgT($fcaller,"Error opening blacklist pattern file: $file_name",-1,$GLOBAL_VARS::LOG_FH);
	    BASE::logMsgT($fcaller,"Looking blacklist patterns on Subjects",2,$GLOBAL_VARS::LOG_FH);
	    foreach my $index (sort { $subject{$b} <=> $subject{$a} || $a cmp $b } keys %subject){
	        #Pattern Comparison
	        while(<FH_BP>){
		        chomp($_);
		        if($index =~ /$_/){
		            print "Matched Pattern: $&\n" if $CONFIG_VARS::debug == 1;
		            BASE::logMsgT($fcaller,"Matched Pattern: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
		            $pattern{$&}++;
		        }
	        }
	        close(FH_BP);
	        #Domain Comparison
	        while(<FH_BD>){
	            chomp($_);
	            if($index =~ /$_/){
	                print "Matched Domain: $&\n" if $CONFIG_VARS::debug == 1;
	                BASE::logMsgT($fcaller,"Matched Domain: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
	                $domain{$&}++;
	            }
	        }
	        close(FH_BD);
	    }
	}
} 
1;
