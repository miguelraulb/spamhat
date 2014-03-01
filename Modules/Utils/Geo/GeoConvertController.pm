#!/usr/bin/perl -w
###################################################################################
## This file is free software; as a special exception the author gives           ##
## unlimited permission to copy and/or distribute it, with or without            ##
## modifications, as long as this notice is preserved.                           ##
##                                                                               ##
## This program is distributed in the hope that it will be useful, but           ##
## WITHOUT ANY WARRANTY, to the extent permitted by law; without even the        ##
## implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.      ##
##                                                                               ##
###################################################################################
## Honeynet Project UNAM-Chapter                                                 ##
## SSI/UNAM-CERT                                                                 ##
## honeynet@seguridad.unam.mx                                                    ##
## www.seguridad.unam.mx/www.cert.org.mx/www.honeynet.unam.mx                    ##
##                                                                               ##
###################################################################################
## [Program name] v[1.0]                                                         ##
## By Xocoyotzin Carlos Zamora Parra   honeynetstaff@seguridad.unam.mx           ##
##                                     xoco.carlos@gmail.com                     ##
## Date 2013-02-25                                                               ##
## ----------------------------------------------------------------------------- ##
## Requirements:                                                                 ##
## -GeoLiteCity.dat                                                              ##
## -                                                                             ##
## Abstract:                                                                     ##
##    Funciones utiles para geo-ip-localizacion                                  ##
###################################################################################

use strict;
use PHUapi::Utils::Geo::GeoConvertModel;
sub coordenadas{
	my ($function_caller, $fh)	=	@_;
	my $coord="";
	my $ipHash=getIpHash();
	my $i=0;
	
	foreach my $ip (keys %$ipHash){
		my($latitude,$longitude)=split(",",getCoordenadasUnam($function_caller, $fh, $ip));
		$coord.="{lat:".$latitude.",lng:".$longitude.",count:".$ipHash->{$ip}{$VARS::CAMPO}."},";
	}
	$coord=$coord."{lat: 0.0, lng: 0.0 , count: 0}]";
	return $coord;
}
1;
