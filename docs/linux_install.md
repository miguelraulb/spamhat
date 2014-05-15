<h1>Installation</h1>

<p>
<h2>Perl</h2>
In case Perl is not present in your Linux system you just have to type<br>
<code> # apt-get install perl </code> 
Probably you might need to update your CPAN repositories (also if it's the first time you run CPAN)
<code> # cpan </code> 
And inside the CPAN shell type:
<code> > upgrade </code> 
</p>

<p>
<h2>CPAN Modules</h2>
Install the required CPAN modules
<code> # cpan -i IO::Socket Switch Proc::ProcessTable IPC::System::Simple Mail::MboxParser LWP::Simple LWP::UserAgent DBI DBD::mysql Digest::MD5 Digest::MD5::File </code>
</p>

<p>
<h2>MySQL Server</h2>
Install the mysql-server package
<code> # apt-get install mysql-server </code>
</p>
