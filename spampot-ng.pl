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
################################################################################
## Spam Honeypot and Analysis Tool (SpamHAT) V1.0                            ##
## By [Miguel Bautista 'mkrul']						     ##
## [mkrul <at> outlook <dot> com]			   		     ##
## [miguelraulb <at> gmail <dot> com] 					     ##
###############################################################################

##############################################################################
use strict;
use v5.10.1;
use experimental 'smartmatch';
use threads;
use threads::shared;
use Cwd;
use Config;
use IO::Socket;
use Digest::MD5 qw(md5_hex);
use Errno qw(ETIMEDOUT);
use LWP::Simple qw(getstore);
use LWP::UserAgent;
use lib Cwd::cwd().'/Modules/';
use Modules::Utils::Base;
use Modules::Spampot::Parser;
use Modules::Db::Connection;
use Modules::Db::Initialize;
use Modules::Db::Insert;
###############################################################################
package GLOBAL_VARS;
	our $VERSION			= "1.0";
	our $CONFIG_FILE		= Cwd::cwd()."/spampot-ng.conf";
	our $LOG_FH;
	our $DB_H;
###############################################################################
package main;
	$Config{useithreads} or die('Recompile Perl with threads in order to run this tool.');
	require $GLOBAL_VARS::CONFIG_FILE;
	open($GLOBAL_VARS::LOG_FH,"+>>$CONFIG_VARS::LOG") || die "[main] Error opening the log file: $CONFIG_VARS::LOG\n";
	CheckConfig("main");
	BASE::showBannerPHU("main",0,"Spampot Tool v$GLOBAL_VARS::VERSION",);
	BASE::logMsgT("main","Starting Spampot Tool v$GLOBAL_VARS::VERSION",2,$GLOBAL_VARS::LOG_FH);
	StartServer("main");
	close($GLOBAL_VARS::LOG_FH);
###############################################################################
sub CheckConfig {
	my $fcaller 	= shift;
	my $fname 	= BASE::getFunctionName($fcaller,(caller(0))[3]);
	BASE::logMsgT($fname,"Checking Spampot config...",2,$GLOBAL_VARS::LOG_FH);
	print "Standard output debug mode on\n" if $CONFIG_VARS::debug == 1;
	print "Log file debug mode on\n" if $CONFIG_VARS::debug == 2;
	unless(-d $CONFIG_VARS::spam_directory){
		mkdir $CONFIG_VARS::spam_directory;
		print "Created spam directory $CONFIG_VARS::spam_directory\n" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fname,"Created spam directory $CONFIG_VARS::spam_directory",2,$GLOBAL_VARS::LOG_FH);
	}
	unless(-d $CONFIG_VARS::output_directory){
		mkdir $CONFIG_VARS::output_directory;
	}
	unless(-d $CONFIG_VARS::binaries_output){
		mkdir $CONFIG_VARS::binaries_output;
	}
	unless(-d $CONFIG_VARS::attachments_output){
		mkdir $CONFIG_VARS::attachments_output;
		print "Created output directory $CONFIG_VARS::output_directory and subdirectories\n" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fname,"Created output directory $CONFIG_VARS::output_directory and subdirectories",2,$GLOBAL_VARS::LOG_FH);
	}
	unless(-d $CONFIG_VARS::log_directory){
		mkdir $CONFIG_VARS::log_directory;
		print "Created log directory $CONFIG_VARS::log_directory\n" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fname,"Created log directory $CONFIG_VARS::log_directory",2,$GLOBAL_VARS::LOG_FH);
	}
	print "Writing info to $CONFIG_VARS::LOG\n" if $CONFIG_VARS::debug == 1;
	BASE::logMsgT($fname,"Writing info to $CONFIG_VARS::LOG",2,$GLOBAL_VARS::LOG_FH);
	ConnectDatabase("CheckConfig");
	# Check the total of tables required to store info on the DB
	CreateTables("CheckConfig") if CheckTables("CheckConfig") != '7';
}
###############################################################################
sub StartServer {
	my $fcaller 	= shift;
	my $fname 	= BASE::getFunctionName($fcaller,(caller(0))[3]);
	# my $buffer;	# Buffer for incoming socket
	#my $connection_thread; # Accepted connection thread handler
	threads->yield();
	my $smtp_socket = IO::Socket::INET->new(
					Listen		=> '4096',
					LocalAddr	=> $CONFIG_VARS::address,
					LocalPort	=> $CONFIG_VARS::port,
					Proto		=> 'tcp',
					ReuseAddr 	=> 1
					# ReadTimeout => 5 # experimental
				) or BASE::logMsgT($fname,"Error binding on $CONFIG_VARS::address:$CONFIG_VARS::port",-1,$GLOBAL_VARS::LOG_FH);
	print "Binding on $CONFIG_VARS::address:$CONFIG_VARS::port\n" if $CONFIG_VARS::debug == 1;
	BASE::showBannerPHU("main",1,"Spampot Tool v$GLOBAL_VARS::VERSION",$GLOBAL_VARS::LOG_FH);
	BASE::logMsgT($fname,"Started SMTP Server binded on $GLOBAL_VARS::address:$CONFIG_VARS::port",2,$GLOBAL_VARS::LOG_FH);
	# Enable r/w timeouts on the socket (experimental)
	# IO::Socket::Timeout->enable_timeouts_on($smtp_socket);
	# $smtp_socket->read_timeout(5);
	# $smtp_socket->write_timeout(5);
	while ( my $client_socket = $smtp_socket->accept() ) { 
			async { Collector("StartServer",$client_socket) }->detach();
	}
	print "Closing SMTP Server...\n" if $CONFIG_VARS::debug == 1;
	BASE::logMsgT($fname,"Spampot stopped receiving connections",1,$GLOBAL_VARS::LOG_FH);
}
###############################################################################
sub Collector {
	my $fcaller 		= shift;
	my $fname 		= BASE::getFunctionName($fcaller,(caller(0))[3]);
	my $client_socket	= shift;
	my $fileno		= $client_socket->fileno();
	my %info	= ();	# Stores socket info
	my $buffer;		# Data buffer variable
	my $msg_id;		# Fake message ID
	my $FH;			# Log file handler
	my $message_flag	= 0; # Becomes 1 when gets in a non-empty message
	my $file_name;	# Output file name
	$| 			= 1;
	print "Handler[$fileno]: Waiting for message\n" if $CONFIG_VARS::debug == 3;
	BASE::logMsgT($fname,"Handler[$fileno]: Waiting for message",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
	$client_socket->send("220 $CONFIG_VARS::banner\r\n");
	#### Generate random message ID ####
	$msg_id = md5_hex(rand);
	if($msg_id =~ /(.{10})/sg){
		$msg_id=$1;
	}
	##### Get Remote Info ####
	my $remote_point = getpeername($client_socket);
	(my $remote_port, my $remote_iaddr) = unpack_sockaddr_in(	$remote_point);
	my $remote_name = gethostbyaddr($remote_iaddr, AF_INET);
	$info{'remote_ip'} = inet_ntoa($remote_iaddr);
	$info{'remote_port'} = $remote_port;
	#### Get Local Info ####
	my $local_point = getsockname($client_socket);
	(my $local_port, my $local_iaddr) = sockaddr_in($local_point);
	my $local_name = gethostbyaddr($local_iaddr, AF_INET);
	$info{'local_ip'} = inet_ntoa($local_iaddr);
	$info{'local_port'} = $local_port;
	$file_name = $info{'local_ip'}."-".time;
	BASE::logMsgT($fname,"Incoming connection from $info{'remote_ip'}:$info{'remote_port'} to $info{'local_ip'}:$info{'local_port'}",2,$GLOBAL_VARS::LOG_FH);
	#### Process the SMTP commands (RFC 0821)
	while( $buffer = <$client_socket> ){
		if (!defined $buffer && 0+$! == ETIMEDOUT) {
			print FH "timeout reading on the socket\n";
			$client_socket->close();
			last;
		}
		$message_flag = 1;
		open(FH,">>$CONFIG_VARS::spam_directory/$file_name") ||
		BASE::logMsgT($fname,"Error creating mail file: $file_name",1,$GLOBAL_VARS::LOG_FH);
		BASE::logMsgT($fname,"Saving data into file: $file_name",2,$GLOBAL_VARS::LOG_FH);
		print FH "$buffer";
		print "$buffer" if $CONFIG_VARS::debug == 1;
		BASE::logMsgT($fname,"$buffer",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
		given (substr($buffer,0,4)) {
			when (/HELO|EHLO/i)	{ $client_socket->send("250 $CONFIG_VARS::hostname\r\n"); }
			when (/MAIL/i)		{ $client_socket->send("250 OK\r\n"); }
			when (/RCPT/i)		{ $client_socket->send("250 OK\r\n"); }
			when (/RSET/i)		{ $client_socket->send("250 OK\r\n"); }
			when (/DATA/i)		{ 
									$client_socket->send("354 Enter message, end with \".\"\r\n");
									while( my $line = <$client_socket> ){
				 						chomp($line);
										if($line =~ m/^.$/){
											print FH "$line\n";
											print "$line" if $CONFIG_VARS::debug == 1;
											last;
										}else{
											print FH "$line\n";
											print "$line" if $CONFIG_VARS::debug == 1;
										}
								  	}
								  	BASE::logMsgT($fname,"All the data has been received",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
									$client_socket->send("250 OK: Queued message as $msg_id\r\n");
						}
			when (/QUIT/i)		{ $client_socket->send("221 Bye\r\n"); 
						  $client_socket->close();
						}
			when (/VRFY/i)		{ chomp($buffer); $client_socket->send("250 ".substr($buffer,5)." OK\r\n"); }
			when (/EXPN/i)		{ $client_socket->send("250 OK\r\n"); }
			when (/AUTH/i)		{ $client_socket->send("503 Error: authentication not enabled\r\n"); }
			when (/HELP/i)		{ 
								  	$client_socket->send("Available Commands:\r\n");
								  	$client_socket->send("HELO/EHLO\r\n");
									$client_socket->send("MAIL FROM: <mail_address>\r\n");
									$client_socket->send("RCPT TO: <mail_addres>\r\n");
									$client_socket->send("RSET\r\n");
									$client_socket->send("DATA\r\n");
									$client_socket->send("QUIT\r\n");
									$client_socket->send("VRFY <user_name>\r\n");
									$client_socket->send("EXPN <mail_list>\r\n");
									$client_socket->send("AUTH <login>\r\n");
									$client_socket->send("HELP\r\n");
								}
			default				{ 
								$client_socket->send("502 Error: command not recognized\r\n");
								BASE::logMsgT($fname,"Command not recognized [$buffer]",0,$GLOBAL_VARS::LOG_FH);
							}
		}
	}
	close(FH);
	BASE::logMsgT($fname,"Closed file: $file_name",2,$GLOBAL_VARS::LOG_FH);
	$client_socket->close();
	if($message_flag){
		ParseMail("StartServer",$file_name,$info{'remote_ip'},$info{'remote_port'},$info{'local_ip'},$info{'local_port'});
	}
	print "Handler[$fileno] is closing\n" if $CONFIG_VARS::debug == 3;
	BASE::logMsgT($fname,"Handler[$fileno] is closing",3,$GLOBAL_VARS::LOG_FH) if $CONFIG_VARS::debug == 2;
}
###############################################################################
