# #!/usr/bin/perl
# use strict;
# use Modules::Utils::Base;
# 
# sub Connections{
# 	my $fcaller	= shift;
# 	my $fname	= BASE::getFunctionName($fcaller,(caller(0))[3]);
# 	my $remote_ip	= shift;
# 	my $remote_port	= shift;
# 	my $local_ip		= shift;
# 	my $local_port	= shift;
# 	my $time	 = getTimestamp("localtime","Tdate");
# 
# 	BASE::logMsgT($fname,"Processing Connections",2,$GLOBAL_VARS::LOG_FH);
# 	print "Incoming connection: $remote_ip:$remote_port\-\>$local_ip:$local_port\n" if $CONFIG_VARS::debug == 1;
#     BASE::logMsgT($fname,"Incoming connection: $remote_ip:$remote_port\-\>$local_ip:$local_port",2,$GLOBAL_VARS::LOG_FH);
#     
# } 
# 1;
