Installation
============

Perl
----

In case Perl is not available in your Linux system you just have to type

`# apt-get install perl`

Probably you might need to update your CPAN repositories (also if it is the first time you run CPAN) 

`# cpan` 

And inside the CPAN shell type: 

`> upgrade`
`> reload`

CPAN Modules 
------------

Install the required CPAN modules 
`# cpan -i IO::Socket Switch Proc::ProcessTable IPC::System::Simple Mail::MboxParser LWP::Simple LWP::UserAgent DBI DBD::mysql Digest::MD5 Digest::MD5::File`

MySQL Server
------------

Install the mysql-server package 
`# apt-get install mysql-server`

