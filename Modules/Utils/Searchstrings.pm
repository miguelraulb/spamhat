#!/usr/bin/perl -w

package Searchstrings::REGEX;
require Exporter ;
@ISA = qw(Exporter);
our @EXPORT=qw($tld $cctld $domain_regex $protocol_regex $path_regex $url_regex $ip_regex $enclosed_ip_regex $user_regex $mail_regex $displayName $encodedDisplayName $To_regex $Received_regex $Received_line $Subject_regex);

    #@EXPORT_OK = qw(funcTwo $varTwo);

# Top Level Domain
our $tld = '(a(ero|rpa|sia)|biz|c(at|om|oop)|edu|gov|i(nfo|nt)|jobs|m(il|obi|useum)|n(a(me|to)|et)|org|pro|t(el|ravel))';

# Country Code Top Level Domain 
our $cctld = '((a(c|d|e|f|g|i|l|m|n|o|q|r|s|t|u|w|x|z))|(b(a|b|d|e|f|g|h|i|j|m|n|o|r|s|t|v|w|y|z))|(c(a|c|d|f|g|h|i|k|l|m|n|o|r|s|u|v|x|y|z))|(d(d|e|j|k|m|o|z))|(e(c|e|g|h|r|s|t|u))|(f(i|j|k|m|o|r))|(g(a|b|d|e|f|g|h|i|l|m|n|p|q|r|s|t|u|w|y))|(h(k|m|n|r|t|u))|(i(d|e|l|m|n|o|q|r|s|t))|(j(e|m|o|p))|(k(e|g|h|i|m|n|p|r|w|y|z))|(l(a|b|c|i|k|r|s|t|u|v|y))|(m(a|c|d|e|g|h|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z))|(n(a|c|e|f|g|i|l|o|p|r|u|z))|(o(m))|(p(a|e|f|g|h|k|l|m|n|r|s|t|w|y))|(q(a))|(r(e|o|s|u|w))|(s(a|b|c|d|e|g|h|i|j|k|l|m|n|o|r|t|u|v|y|z))|(t(c|d|f|g|h|j|k|l|m|n|o|p|r|t|v|w|z))|(u(a|g|k|s|y|z))|(v(a|c|e|g|i|n|u))|(w(f|s))|(y(e|t))|(z(a|m|w)))';

# Dominio de internet
our $domain = '[\w\d]+(\.?[\w\d\-])*\.(('.$tld.'(\.'.$cctld.')?)|'.$cctld.')';

#Usuario
our $dir='[\w\d]+[\w\d\-_.]*'; #Usuario

#E.R de Correo
our $email="$dir\@$domain"; #correo electronico

#E.R de Direcciones IP
our $ip='(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})';

#E.R de Subject
our $subject = 'Subject: ';

#E.R. de URL
# URL de http, https o ftp
our $protocol = '(f|ht)tps?://' ;
#our $domain = '([\w\d\-_]+\.)+[\w\d]+' ;
our $path = '[\w\d\-\/\+_.,:=#%]+';
our $url = $protocol.'('.$domain.')'.'('.$path.')';
our $binarios = '(.*)\.';
our $binarios1 = '([A-Za-z]{2,4})';
our $binarios2= $binarios.$binarios1;

my %correos=();
#sub get_urls(){
#        my $string=shift;
#        my $regex_set=shift;
#        my $oct='[0-9]{1,3}';
#        my $flag;
#        my %dominios;
#        my %ips;
#        my %correos;
#        my %urls;
#        my $patron_inc=0;
#        my $correostr;
#        my $urlstr;
#        my $ipstr;
#        my $dominiostr;
#	if ($palabra =~ /(((ftp|http|https|tftp|sftp|link)\:\/\/|www\.)(([a-z0-9]
#+\-?[a-z0-9]+\.)+[a-z0-9]+)((\/\~?[a-z0-9]+\-?[a-z0-9]+)+(\.[a-z0-9]+)?)*)/gi){
#                        $urls{$1}++;
#                        $dominios{$4}++;
#                }
#        foreach my $url (keys%urls){
#                $urlstr .= "$url($urls{$url}),";
#        }
#        foreach my $dominio (keys%dominios){
#                $dominiostr .= "$dominio($dominios{$dominio}),";
#        }
#        return "$correostr|$urlstr|$dominiostr|$ipstr|$pattern_rule($patron_inc)";
#}        

sub get_mails{
        my $string=shift;
        my $regex_set=shift;
        my $correostr;
#	print "$string\n";
	if ($string =~ /$email/){
#			print "$&\n";
			$correos{$&}++;
	}
        #foreach my $correo (keys %correos){
        #       #$correostr .= "$correo($correos{$correo}),";
        #       print "$correo - $correos{$correo}\n";
        #}
        #print "$correostr\n";
}

#sub get_ip(){
#        my $string=shift;
#        my $regex_set=shift;
#        my $oct='[0-9]{1,3}';
#        my $flag;
#        my %dominios;
#        my %ips;
#        my %correos;
#        my %urls;
#        my $patron_inc=0;
#        my $correostr;
#        my $urlstr;
#        my $ipstr;
#        my $dominiostr;
#        if ( ($palabra =~ /(($oct)\.($oct)\.($oct)\.($oct))/g) && ($2<256) && ($3<256) && ($4<256) && ($5<256) ){
#                       $ips{$1}++;
#        }
#	
#        foreach my $ip (keys%ips){
#                $ipstr .= "$ip($ips{$ip}),";
#        }
#        return "$correostr|$urlstr|$dominiostr|$ipstr|$pattern_rule($patron_inc)";
#}

1;
