#!/usr/bin/perl -w
use strict;
use PHUapi::Utils::Geo::GeoConvertConfig;
use PHUapi::Utils::Geo::GeoConvertController;

sub HeatMapMainFunction{
	print coordenadas($CONFIG_VARS::FUNCTION_NAME,$CONFIG_VARS::FILE_HANDLER);
}
sub main{
        open($CONFIG_VARS::FILE_HANDLER,">>$CONFIG_VARS::LOG_FILE");
        HeatMapMainFunction();
	end();
}
sub end{
	close($CONFIG_VARS::FILE_HANDLER);
}
print "content-type: text/html \n\n";
print '
<!DOCTYPE html>
<html lang="es-MX">
<head>
	<meta name="application-name" content="SMART v6.0" />
	<meta name="description" content="UNAM-CERT / Honeynet Project - UNAM Chapter / Proyecto Honeynet UNAM / SMART v6.0" />
	<meta name="keywords" content="UNAM-CERT / Honeynet Project - UNAM Chapter / Proyecto Honeynet UNAM / SMART v6.0" />
	<meta name="author" content="Sergio Anduin Tovar Balderas" />
	<meta name="generator" content="SMART v6.0" />
	<meta name="robots" content="none" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<!--<meta http-equiv="refresh" content="10" />-->
	<title>UNAM-CERT / Honeynet Project - UNAM Chapter / Proyecto Honeynet UNAM / SMART v6.0</title>
	<link rel="stylesheet" type="text/css" href="../../../css/smart.css" />	
	<link type="text/css" href="../../../css/humanity/jquery-ui.css" rel="stylesheet" />	
	<link rel="stylesheet" type="text/css" href="../../../css/smartjs.css" />
	<script type="text/javascript" src="../../../js/jquery.js"></script>
	<script type="text/javascript" src="../../../js/jquery-ui.js"></script>
	<script type="text/javascript" src="../../../js/smart.js"></script> 
	<script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>
	<script type="text/javascript" src="../../../js/heatmap.js"></script>
	<script type="text/javascript" src="../../../js/heatmap-gmaps.js"></script>
		<style>
			body, html {
				margin:0;
				padding:0;
				font-family:Arial;
			}
			#ppal {
				position:relative;
				width:750px;
			}
			#heatmapArea {
				position:relative;
				float:left;
				width:750px;
				height:400px;
			}
		</style>
		<script type="text/javascript">
			var map;
			var heatmap; 
			window.onload = function(){
				var myLatlng = new google.maps.LatLng(37.0625,-95.677068);
				var myOptions = {
	  				zoom: 3,
	  				center: myLatlng,
	  				mapTypeId: google.maps.MapTypeId.ROADMAP,
	  				disableDefaultUI: false,
	  				scrollwheel: true,
	  				draggable: true,
	  				navigationControl: true,
	  				mapTypeControl: false,
	  				scaleControl: true,
	  				disableDoubleClickZoom: false
				};
				map = new google.maps.Map(document.getElementById("heatmapArea"), myOptions);
					heatmap = new HeatmapOverlay(map, {"radius":10, "visible":true, "opacity":100});
					var testData={
    					max: 20,
    					data: [';
					main();
					print '};	
					google.maps.event.addListenerOnce(map, "idle", function(){
						heatmap.setDataSet(testData);
					});
			};
		</script>
</head>
<body id="contenedor">
<header>
	<div id="encabezado">
        <div id="logotipo">
			<a href="index.html" title="Proyecto Honeynet - SMART v6.0 - UNAM-CERT" target="_BLANK"><img src="../../../img/logoPrincipal.jpg" alt="Proyecto Honeynet - SMART v6.0 - UNAM-CERT" width="450" height="100" border="0" /></a>
		</div>
        <div id="logotipo2">
			<img alt="Proyecto Honeynet - SMART v6.0 - UNAM-CERT" src="../../../img/logoSecundario.jpg" width="550" height="100" border="0" />
		</div>
    </div>
</header>
<nav>
	<div id="menuPrincipal">
		<ul>
			<li><a href="../../dashboard/index.html">Dashboard</a></li>
			<li><a href="../../detection/index.html">Detection</a></li>
			<li><a href="../../incidents/index.html">Incidents</a></li>
			<li><a href="../../search/index.html">Search</a></li>
			<li><a href="../../stats/index.html">Stats</a></li>
			<li><a href="../../system/index.html">System</a></li>
			<li><a href="../../reports/index.html">Reports</a></li>
			<li id="activomp"><a href="index.html">Visualization</a></li>
			<li><a href="../../administration/index.html">Administration</a></li>
			<li><a href="../../help/index.html">Help</a></li>
			<li><a href="#" id="quit">Logout</a></li>
		</ul>	
	</div>
</nav>
<article>
	<div id="contenido">
         	<div id="ppal">
			<div id="heatmapArea">
			</div>
		</div>
	</div>
</article>
<aside>
	<div id="menuInterno">
		<ul>
			<li><a href="glti/index.html">glti</a></li>
			<li><a href="logstalgia/index.html">logstalgia</a></li>
			<li><a href="afterglow/index.html">afterglow</a></li>
			<li><a href="gource/index.html">gource</a></li>
			<li><a href="treemap/index.html">treemap</a></li>
			<li id="activoin"><a href="index.html">heatmap</a></li>
			<li><a href="inav/index.html">inav</a></li>
		</ul>
	</div>
</aside>
<footer>
	<div class="pie">
		<div>
		Hecho en M&eacute;xico, Universidad Nacional Aut&oacute;noma de M&eacute;xico (UNAM), todos los derechos reservados 2012. El uso de esta p&aacute;gina deber&aacute; de cumplir las pol&iacute;ticas de participaci&oacute;n del Plan de Sensores de Tr&aacute;fico Malicioso. <a href="#">Cr&eacute;ditos</a>
		</div>
		<div class="administrado">Este sitio web fue elaborado en base a una sitio web institucional de la UNAM y modificado y adaptado con fines internos <br />Sitio web creado por:<br />
			Honeynet Project - UNAM Chapter <a href="mailto:honeynet@seguridad.unam.mx">honeynet@seguridad.unam.mx</a>
		</div>
	</div>
</footer>
</body>
</html>';
exit(1);
