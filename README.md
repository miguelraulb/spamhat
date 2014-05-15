<h1>Spam Honeypot Tool</h1>

Open Relay Simulator Tool for the analysis and spam harvesting

Feel free to ask anything or request help for development

miguelraulb &lt;at&gt; gmail &lt;dot&gt; com

<h2>Installation Requirements on Debian (base) 6.x, 7.x</h2>
<ul>
	<li>Perl 5.10.1</li><br>
	<code>Perl is on the most of the Linux distros, just check that you have this version</code><br>
	<li>CPAN Modules</li>
	<ul>
		<li>IO::Socket</li>
		<li>Switch</li>
		<li>Proc::ProcessTable</li>
		<li>IPC::System::Simple</li>
		<li>Mail::MboxParser</li>
		<li>LWP::Simple</li>
		<li>LWP::UserAgent</li>
		<li>DBI</li>
		<li>DBD::mysql</li>
		<li>Digest::MD5</li>
		<li>Digest::MD5::File</li>
	</ul><br>
	<code># cpan -i IO::Socket Switch Proc::ProcessTable IPC::System::Simple Mail::MboxParser LWP::Simple LWP::UserAgent DBI DBD::mysql Digest::MD5 Digest::MD5::File</code>
	<li>MySQL Server</li><br>
	<code># apt-get install mysql-server</code>
</ul>
