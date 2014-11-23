use strict;
use Modules::Utils::Base;
use Modules::Spampot::Regex;

package DOMAINS;
	our %mails;
	our %source;
	our %destination;
	our %domain;
	our $with_domain=0;
	our $with_mail=0;
	
sub GetDomains{
	my $fcaller	= shift;
	my $fname	= BASE::getFunctionName($fcaller,(caller(0))[3]);
	my $file_name 	= shift;

	#Domain REGEX Comparison
	BASE::logMsgT($fname,"Starting to parse domains",2,$GLOBAL_VARS::LOG_FH);
	open(FH,$file_name) || BASE::logMsgT($fname,"Error opening mail file: $file_name",-1,$GLOBAL_VARS::LOG_FH);
	
	# Source domains
	BASE::logMsgT($fname,"Getting Source Domains",2,$GLOBAL_VARS::LOG_FH);
	while(<FH>){
		chomp($_);
		if($_ =~ m/(MAIL FROM\:? )($REGEX::email)/i){
			print "Matched Source Mail: $2\n" if $CONFIG_VARS::debug == 1;
			BASE::logMsgT($fname,"Matched Source Mail: $2",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
			# $mails{$2}++;
			my $tmp = $2;
			if($tmp =~ /($REGEX::domain)/){
				print "Matched Source Domain: $&\n" if $CONFIG_VARS::debug == 1;
				BASE::logMsgT($fname,"Matched Source Domain: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
				$DOMAINS::source{$&}++;
				$DOMAINS::with_domain=1;
			}
		}
	}
	seek FH,0,0; # Re-read the file
	
	# Destination domains
	BASE::logMsgT($fname,"Getting Destination Domains",2,$GLOBAL_VARS::LOG_FH);
	while(<FH>){
		if($_ =~ m/(RCPT TO\:? )($REGEX::email)/i){
			print "Matched Domain Mail: $2\n" if $CONFIG_VARS::debug == 1;
			BASE::logMsgT($fname,"Matched Destination Mail: $2",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
			# $mails{$2}++;
			my $tmp = $2;
			if($tmp =~ /($REGEX::domain)/){
				print "Matched Destination Domain: $&\n" if $CONFIG_VARS::debug == 1;
				BASE::logMsgT($fname,"Matched Destination Domain: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
				$DOMAINS::destination{$&}++;
				$DOMAINS::with_domain=1;
			}
		}
	}
	seek FH,0,0; # Re-read the file
	
	# Email domains
	BASE::logMsgT($fname,"Getting Emails",2,$GLOBAL_VARS::LOG_FH);
	while(<FH>){
		if($_ =~ m/$REGEX::email/i){
			
			print "Matched Mail: $&\n" if $CONFIG_VARS::debug == 1;
			BASE::logMsgT($fname,"Matched Mail: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
			$mails{$&}++;
			my $tmp = $&;
			if($tmp =~ /($REGEX::domain)/){
				print "Matched Email Domain: $&\n" if $CONFIG_VARS::debug == 1;
				BASE::logMsgT($fname,"Matched Email Domain: $&",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
				$DOMAINS::domain{$&}++;
				$DOMAINS::with_mail=1;
			}
		}
	}
	
	close(FH); 
}
1;
