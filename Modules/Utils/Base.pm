##############################################################################
## This file is free software; as a special exception the author gives      ##
## unlimited permission to copy and/or distribute it, with or without       ##
## modifications, as long as this notice is preserved.                      ##
##                                                                          ##
## This program is distributed in the hope that it will be useful, but      ##
## WITHOUT ANY WARRANTY, to the extent permitted by law; without even the   ##
## implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. ##
##                                                                          ##
##############################################################################
## Honeynet Project UNAM-Chapter                                            ##
## SSI/UNAM-CERT                                                            ##
## honeynet@seguridad.unam.mx                                               ##
## www.seguridad.unam.mx/www.cert.org.mx/www.honeynet.unam.mx               ##
##                                                                          ##
##############################################################################
use strict;
use Switch;
use Proc::ProcessTable;

package BASE;

##############################################################################
## Description: Log message function with tracking support		    ##
## Author     : Javier Santillan					    ##
## Syntax     : logMsgT(FUNCTION_NAME,MESSAGE,CODE,FILE_HANDLE)		    ##
## Options    : CODE >  -1>FATAL_ERROR 0>ERROR  1>WARNING  2>INFO  3>DEBUG  ##
##############################################################################
sub logMsgT
{
	my ($function_name, $msg_data, $msg_code,$file_handle) = @_;
	my $msg_prefix;
	if    ( $msg_code ==-1 ){$msg_prefix = "FATAL ERROR";	}
	elsif ( $msg_code == 0 ){$msg_prefix = "ERROR";		}
	elsif ( $msg_code == 1 ){$msg_prefix = "WARNING";	}
	elsif ( $msg_code == 2 ){$msg_prefix = "INFO";		}
	elsif ( $msg_code == 3 ){$msg_prefix = "DEBUG";		}
	else			{$msg_prefix = "UNDEFINED";	}
        (my $sec,my $min,my $hour,my $day,my $mon,my $year,
	 my $wday,my $yday,my $isdst)=localtime(time);
        my $gdate = sprintf("%4d-%02d-%02dT%02d:%02d:%02d",
		    $year+1900,$mon+1,$day-1,$hour,$min,$sec);
        my $Ddate = sprintf("%4d%02d%02d",$year+1900,$mon+1,$day);
        my $Hdate = sprintf("%02d%02d",$hour,$min);
	my $msg_timestamp = getTimestamp("localtime","Tdate");
	$msg_data = sprintf("[%-.20s]-[%-.11s]-[%.40s]-[%s]\n",
		    $msg_timestamp,$msg_prefix,$function_name,$msg_data);
	print $file_handle "$msg_data";
	die "$msg_data\n" if ( $msg_code ==-1 );
}

##############################################################################
## Description: getTimestamp function					    ##
## Author     : Javier Santillan					    ##
## Syntax     : getTimestamp(TIME_ZONE,TYPE_REQUEST)	 		    ##
## Options    : TIME_ZONE    >  localtime, utc				    ##
## Options    : TYPE_REQUEST >  TDate, Ddate, Hdate			    ##
##############################################################################
sub getTimestamp
{
	my ($time_zone, $time_request) = @_;
	my ($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst);
	if ( $time_zone eq "localtime" )
	{
		($sec, $min, $hour, $day, $mon, $year,
		 $wday, $yday, $isdst)=localtime(time);
	}
	elsif ($time_zone eq "utc")
	{
		($sec, $min, $hour, $day, $mon, $year,
		 $wday, $yday, $isdst)=gmtime(time);
	}
	else
	{
		($sec, $min, $hour, $day, $mon, $year, 
		 $wday, $yday, $isdst)=localtime(time);
	}
        my $Tdate = sprintf("%4d-%02d-%02dT%02d:%02d:%02d",
		    $year+1900,$mon+1,$day,$hour,$min,$sec);
        my $Ddate = sprintf("%4d%02d%02d",$year+1900,$mon+1,$day);
        my $Hdate = sprintf("%02d%02d",$hour,$min);
	return $Tdate if ($time_request eq "Tdate");
	return $Ddate if ($time_request eq "Ddate");
	return $Hdate if ($time_request eq "Hdate");
}

##############################################################################
## Description: Returns function_caller + function_name	for tracking        ##
## Author     : Javier Santillan					    ##
## Syntax     : BASE::getFunctionName(CURRENT_FUNCTION_CALLER,FUNCTION_NAME)	    ##
##############################################################################
sub BASE::getFunctionName
{
        my ($current_function_caller,$function_name) = @_;
        my @names = split(/::/,$function_name);
        return "$current_function_caller|$names[1]";
}

##############################################################################
## Description: Show PHU Banner						    ##
## Author     : Javier Santillan					    ##
## Syntax     : showBannerPHU(FUNCTION_CALLER,OUTPUT,HEADING,[FILE_HANDLE]) ##
## Options    :	OUTPUT > 0-Standar_output, 1-FH				    ##
##############################################################################
sub showBannerPHU
{
	my ($function_caller,$output, $heading, $fh) = @_;
	my $function_name = BASE::getFunctionName($function_caller,(caller(0))[3]);
	if ( $output == 1 )
	{
		if (defined $fh && defined $function_caller)
		{
			logMsgT($function_name,"#################################################",2,$fh);
			logMsgT($function_name,"UNAM-HONEYNET PROJECT               ___          ",2,$fh);   
			logMsgT($function_name,"SSI/UNAM-CERT                      /   \\         ",2,$fh); 
			logMsgT($function_name,"honeynet\@seguridad.unam.mx         \\___/         ",2,$fh);
			logMsgT($function_name,"-------------------------------------------------",2,$fh);
			logMsgT($function_name,"$heading",2,$fh);
			logMsgT($function_name,"#################################################",2,$fh);
		}
	}	
	elsif ( $output == 0)
	{
		print "#################################################\n";
		print "UNAM-HONEYNET PROJECT               ___\n";            
		print "SSI/UNAM-CERT                      /   \\\n"; 
		print "honeynet\@seguridad.unam.mx         \\___/\n";
		print "-------------------------------------------------\n";
		print "$heading\n";
		print "#################################################\n";
	}
	else
	{
		logMsgT($function_name,"Invalid Output",0,$fh);
	}
}
