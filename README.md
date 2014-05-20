Spam Honeypot Tool
==================

Open Relay Simulator Tool for the analysis and spam harvesting
--------------------------------------------------------------

Feel free to ask anything or request help for development

miguelraulb at gmail dot com

### Installation Requirements on Debian (base) 6.x, 7.x
* Perl 5.10.1
* CPAN Modules
	- IO::Socket
	- Switch
	- Proc::ProcessTable
	- IPC::System::Simple
	- Mail::MboxParser
	- LWP::Simple
	- LWP::UserAgent
	- DBI
	- DBD::mysql
	- Digest::MD5
	- Digest::MD5::File
	
* MySQL Server

Installation
Linux Debian installation [instructions](https://github.com/miguelraulb/spampot/blob/master/docs/linux_install.md)

### Execution

Once you have all the modules installed you just have to create a database called spampot or whatever you wish to name it, create a user with password and then assign the name of your database to the user you've already created.

Please set this values on the `spampot-ng.conf` file.

In order to run the tool you have to run it with sudo or using a wrapper as authbind, [here](http://mutelight.org/authbind) are the instructions

 `# sudo perl spampot-ng.pl `

 `# authbind --deep perl spampot-ng.pl `

Author
------
Miguel Raúl Bautista Soria

