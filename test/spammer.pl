#!/usr/bin/perl

use strict;

use IO::Socket;

my $file = shift;
my $debug = 1;

my $sender_socket = IO::Socket::INET->new(
	Proto => 'tcp',
	PeerAddr => '127.0.0.1',
	PeerPort => '25',
) or die "Error connecting to SMTP Server\n";

open(FH,$file);
while(<FH>){
#	chomp($_);
	print "$_" if $debug == 1;
	$sender_socket->send($_);
}
close(FH);
