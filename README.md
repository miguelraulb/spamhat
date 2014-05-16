<h1>Spam Honeypot Tool</h1>

Open Relay Simulator Tool for the analysis and spam harvesting

Feel free to ask anything or request help for development

miguelraulb &lt;at&gt; gmail &lt;dot&gt; com

<h2>Installation Requirements on Debian (base) 6.x, 7.x</h2>
<ul>
	<li>Perl 5.10.1</li>
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
	</ul>
	<li>MySQL Server</li>
</ul>
<h2>Installation</h2>
Linux Debian installation <a href="https://github.com/miguelraulb/spampot/blob/master/docs/linux_install.md">instructions</a>

<h2>Execution</h2>

Once you have all the modules installed you just have to create a database called <code>spampot</code> or whatever you wish to name it, create a user with password and then assign the name of your database to the user you've already created.

Please set this values on the <code>spampot-ng.conf</code> file.

In order to run the tool you have to run it with <code>sudo</code> or using a wrapper as authbind, <a href="http://mutelight.org/authbind">here</a> are the instructions
<br>
<code> # sudo perl spampot-ng.pl </code>
<br>
<code> # authbind --deep perl spampot-ng.pl </code>

<h2>Author</h2>
<ul>
	<li>Miguel Raúl Bautista Soria</li>
</ul>
