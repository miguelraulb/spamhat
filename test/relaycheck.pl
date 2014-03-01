#!/usr/bin/perl

# relaycheck.pl - Erik Schorr (erik-rpl@arpa.org) 2000-12-18
# last revision: 2001-06-13: code cleanup, removed warnings with perl -w
# Usage:  ./relaycheck.pl address.of.remote.mailserver

# Set the following to be appropriate for you: (i use relay-from@ and
#   relay-to@poison.cwnet.com so i can receive the messages for analysis
#   later.  Please change these!)

my $fromaddr='relay-from@poison.cwnet.com';
my $rcptaddr='relay-to@poison.cwnet.com';

# Set $debug to 1 if you'd like to see server responses
my $debug=1;

# no user-serviceable parts inside
use Socket;

my $dport=25;
$SIG{PIPE}='IGNORE';
$| = 1;

die "usage: $0 remote.mailserver.addr" if !defined($ARGV[0]);
my $remote_host=$ARGV[0];
print "... checking $remote_host\n" if $debug;

if (!socket(S, PF_INET, SOCK_STREAM, getprotobyname('tcp'))) {
	print "::: socket: $!\n";
	exit(1);
}

my $daddr = inet_aton($remote_host);
if (!$daddr) {
	print "::: inet_aton: $!\n";
	exit(1);
}
my $sockaddr = sockaddr_in($dport, $daddr);

my $c=tconnect($sockaddr);
print "::: tconnect() returned $c\n" if $debug;
if ($c != 1) {
	print "::: failed to connect: $c\n";
	exit(1);
}

my $serverid;
my $welcome;
my $in;
while (!$welcome) {
	my $in=timerecv(30);
	if ($in !~ /^220/) {
		print "::: got unrecognized prompt form mailserver\n";
		exit(2);
	}
	if (!$serverid) {
		$serverid=$in;
	}
	if ($in =~ /^220 /) {
		$welcome=$in;
	}
}
qsend("HELO relaytest");

$in=timerecv(10);
if ($in !~ /^250/) {
	print "::: got unrecognized HELO response from mailserver\n";
	exit(2);
}
qsend("MAIL FROM: <$fromaddr>");

$in=timerecv(10);
if ($in !~ /^250/) {
	print "::: got unrecognized MAIL response from mailserver\n";
	exit(2);
}
qsend("RCPT TO: <$rcptaddr>");

$in=timerecv(10);
if ($in !~ /^250/) {
	print "::: got unrecognized RCPT response from mailserver - probably NOT promiscuous\n";
	exit(2);
}
qsend("DATA");

$in=timerecv(10);
if ($in !~ /^3/) {
	print "got unrecognized DATA response from mailserver\n";
	exit(2);
}
qsend("Subject: PROMISCUOUS RELAY $ARGV[0]");
qsend("");
qsend("$serverid");
qsend(".");
qsend("QUIT");

$in=timerecv(10);
print "IN: $in\n";
if ($in !~ /^250/) {
print "Response: $in\n";
	print "got unrecognized response after DATA sent\n";
	exit(2);
}
qsend("QUIT");
close(S);
print "+++ $ARGV[0] seems to be promiscuous\n";

exit(0);

sub grabline {
	my $xline="";
	my $char;
	while (1) {
		last if (!sysread S,$char,1);
		last if ($char eq "\n");
		$xline=$xline . $char;
	}
	print "... grabbed: $xline\n" if $debug;
	return $xline;
}

sub qsend {
	my $send=$_[0] . "\r\n";
	syswrite S,$send,length($send) || die "::: Could not write to socket: $!\n" ;
}

sub timerecv {
	my $timeout=$_[0];
	my $tmp;
	eval {
		local $SIG{ALRM} = sub { die "alarm\n" };
		alarm($timeout);
		$tmp=grabline();
		print "tmp: $tmp\n";
		alarm(0);
	};
	if ($@) {
		if ($@ eq "alarm\n") {
			return "_TIMEOUT_";
		} else {
			return "_ERROR:$@_";
		}
	}
	return $tmp;
}

sub tconnect {
	my $sockaddr=$_[0];
	my $cr=0;
	eval {
		local $SIG{ALRM} = sub { die "alarm\n" };
		alarm(10);
		$cr=connect(S,$sockaddr);
		alarm(0);
	};
	if ($@) {
		if ($@ eq "alarm\n") {
			return "_TIMEOUT_";
		} else {
			return "_ERROR:$@_";
		}
	}
	return 1 if defined($cr);
	return $!;
}

