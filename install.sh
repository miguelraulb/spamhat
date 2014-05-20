##################################################################################
## This file is free software; as a special exception the author gives          ##
## unlimited permission to copy and/or distribute it, with or without           ##
## modifications, as long as this notice is preserved.                          ##
##                                                                              ##
## This program is distributed in the hope that it will be useful, but          ##
## WITHOUT ANY WARRANTY, to the extent permitted by law; without even the       ##
## implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.     ##
##                                                                              ##
##################################################################################
## Honeynet Project UNAM-Chapter                                                ##
## SSI/UNAM-CERT                                                                ##
## honeynet@seguridad.unam.mx                                                   ##
## www.seguridad.unam.mx/www.cert.org.mx/www.honeynet.unam.mx                   ##
##                                                                              ##
##################################################################################
## Installation script for SCANS requirements  Debian GNU/Linux 7.x Base  V0.1.0##
## By [Miguel Bautista] [miguelraulb@gmail.com, mbautista@seguridad.unam.mx]    ##
## ---------------------------------------------------------------------------- ##
## Requirements:                                                                ##
##      - Debian GNU/Linux 7.0.x                                                ##
## Abstract:                                                                    ##
##      This script is an installer of SCANS required modules and extra tools.  ##
##################################################################################
#!/bin/bash

LOG=log/INSTALL.LOG
INSTALLER=`whoami`
##################################################################################
banner()
{
        echo "######################################" >  $LOG
        echo "###   CPAN MODULES INSTALLATION   ####" >> $LOG
        echo "######################################" >> $LOG
	echo "______________________________________" >> $LOG
        echo "Started @ [`date`]"                     >> $LOG
        echo                                          >> $LOG
        echo                                          >> $LOG
}
##################################################################################
user_install()
{
        if [ $INSTALLER != "root" ]; then
                echo ""
                echo ""
                echo "#####################################################"
                echo "# You must be root to exec this installation script #"
                echo "#####################################################"
                echo ""
                echo ""
                echo ""
                echo ""
                exit_install
        fi
}
##################################################################################
exit_install()
{
	echo
        echo
        echo "[EXIT_INSTALL   ]   The installation script has been terminated with errors" >> $LOG
        echo "[EXIT_INSTALL   ]   The installation script has been terminated with errors"
        echo
        echo
        exit 1
}
##################################################################################
exec_install()
{
	if [ $1 -ne 0 ]; then
		echo "[EXEC_INSTALL   ]   ERROR - Installation of $2" >> $LOG
		exit_install
	else
		echo "[EXEC_INSTALL   ]   The package $2 has been installed OK" >> $LOG
	fi
}
##################################################################################
install_perl()
{
	echo "[INSTALL_PERL]   Installing Perl..." >> $LOG
	cmd = "apt-get install perl"
	$cmd
	exec_install $? $cmd
}
##################################################################################
upgrade_cpan()
{
	echo "[UPGRADE_CPAN]   Upgrading CPAN..." >> $LOG
	cmd = "cpan -r"
	$cmd
	exec_install $? $cmd
}
##################################################################################
install_cpan_modules()
{
	echo "[INSTALL_CPAN_MODULES]   Installing CPAN Modules..." >> $LOG
	cmd = "cpan -f -i IO::Socket Switch Proc::ProcessTable IPC::System::Simple Mail::MboxParser LWP::Simple LWP::UserAgent DBI DBD::mysql Digest::MD5 Digest::MD5::File"
	$cmd
	exec_install $? $cmd
}
##################################################################################
banner
user_install
install_perl
upgrade_cpan
install_cpan_modules
