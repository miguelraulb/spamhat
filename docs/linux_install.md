<h1>Installation</h1>

<p>
<h2>Perl</h2>
In case Perl is not present in your Linux system you just have to type<br>
<code> # apt-get install perl </code> <br>
Probably you might need to update your CPAN repositories (also if it's the first time you run CPAN) <br>
<code> # cpan </code> <br> 
And inside the CPAN shell type: <br>
<code> > upgrade </code> <br>
<code> > reload </code> <br>
</p>

<p>
<h2>CPAN Modules</h2> <br>
Install the required CPAN modules <br>
<code> # cpan -i IO::Socket Switch Proc::ProcessTable IPC::System::Simple Mail::MboxParser LWP::Simple LWP::UserAgent DBI DBD::mysql Digest::MD5 Digest::MD5::File </code> <br>
</p>

<p>
<h2>MySQL Server</h2> <br>
Install the mysql-server package <br>
<code> # apt-get install mysql-server </code> <br>
</p>
