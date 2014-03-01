use strict;
use PHUapi::Smart::ConfigV6;
use PHUapi::Db::MySqlQuery;
use PHUapi::Utils::Base;
use PHUapi::Utils::Geo::GeoConvertConfig;
use Geo::IP;
##############################################################################
## Description: Retorna coordenadas de una direccion IP en formato decimal  ##
## Author     : Xocoyotzin Zamora                                           ##
## Syntax     : getCoordenadasUnam(FUNCTION_CALLER,FILE_HANDLE,DECIMAL_IP)  ##
## Return     : $coord ej. "11.0000,10.0000"                                ##
##############################################################################
#package GeoConvert;
	our $COORDENADAS="";
	our $LECTURA;
#	our $CAMPO="counter_events";
sub getCoordenadasUnam{
	my ($function_caller, $fh, $ip_dec)	=	@_;
	my $function_name 			=	getFunctionName($function_caller,(caller(0))[3]);

	open(LECTURA,"<$CONFIG_VARS::GEO_IP_UNAM_DIR") || logMsgT($function_name,"No se puede leer el archivo $CONFIG_VARS::GEO_IP_UNAM_DIR",0,$fh);
	while(<LECTURA>){
		my ($inicio,$fin,$coord)=split(/\|/,$_);
			if($ip_dec ge $inicio && $ip_dec le $fin){
			return $COORDENADAS=$coord;
		}
		else{
			return getCoordenadas($function_caller,$fh,dec2ip($ip_dec));
		}
	}
	close(LECTURA);
}
##############################################################################
## Description: Retorna coordenadas de una direccion IP en formato decimal  ##
## Author     : Xocoyotzin Zamora                                           ##
## Syntax     : getCoordenadas(FUNCTION_CALLER,FILE_HANDLE,IP)              ##
## Return     : $coord ej. "11.0000,10.0000"                                ##
##############################################################################
sub getCoordenadas{
	my ($function_caller, $fh, $ip)		=	@_;
	my $function_name 			=	getFunctionName($function_caller,(caller(0))[3]);
	
	my $gi = Geo::IP->open($CONFIG_VARS::GEO_IP_DIR, Geo::IP::GEOIP_STANDARD()) || logMsgT($function_name,"No se puede leer el archivo $CONFIG_VARS::GEO_IP_DIR",0,$fh);
	my $record = $gi->record_by_name($ip);
    	$COORDENADAS="".$record->latitude.",".$record->longitude || logMsgT($function_name,"Ocurrio un problema al intentar leer $CONFIG_VARS::GEO_IP_DIR",0,$fh);
	
	return $COORDENADAS;

}

sub dec2ip ($) {
	join '.', unpack 'C4', pack 'N', shift;
}   
sub ip2dec ($) {
	unpack N => pack CCCC => split /\./ => shift;
}
sub getIpHash{
	my $hashResults = queryHashSelect(
                                $BASE_TSU_BECARIOS::dsn,
                                $BASE_TSU_BECARIOS::user,
                                $BASE_TSU_BECARIOS::password,
                                #"select Ips.ip_src,incident_counter from Ips,Incidents where Ips.ip_incident_id=Incidents.incident_id;",
				"select Ip.ip_src,Incidents.counter_events from Incidents,Ip where Incidents.idIncidents=Ip.Incidents_idIncidents;",
                                "1"
                        );
	return $hashResults;
}
package VARS;
	our $CAMPO="counter_events";
1;
