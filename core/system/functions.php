<?php

	/***********************************************
	PHP-Hilfsfunktionen
	Version 0.1
	Copyright by Julian Burr - 12.07.2012
	***********************************************/
	
	include_once($_SERVER['DOCUMENT_ROOT']."/core/classes/SQLManager.php");
	
	function sqlquery($befehl,$befehl_typ="select"){
		//Allgemeine SQL-Abfrage
		$mysqlhost = "localhost";
		$mysqluser = "d0148efd";
		$mysqlpwd = "TwCWJB7ce2ErGUG9";
		$mysqldb = "d0148efd";
	
		$connection = mysql_connect($mysqlhost,$mysqluser,$mysqlpwd) OR die ('<pre>Verbindungsversuch fehlgeschlagen</pre>');
		mysql_select_db($mysqldb,$connection) OR die ('<pre>Konnte die Datenbank nicht w&auml;hlen</pre>');
		
		$result = mysql_query($befehl) OR die ("<pre>Anfrage nicht erfolgreich\n\n$befehl\n\n".mysql_error()."</pre>");
		
		return $result;
	}
	
	
	function sqlresult($befehl){
		//SQL-Abfrage mit einem Ergebnis => Ergebnis direkt in Array laden und zutück geben
		$abfrage = sqlquery($befehl,'select');
		while ($row = mysql_fetch_array($abfrage)) {
			$ergebnis = $row;
		}
		return $ergebnis;
	}
	
	function get_include($module_path){
		$output = "";
		ob_start();
			//Modul laden, ausführen und Output in Variable speichern und zurück geben
			include($module_path);
			$output = ob_get_contents();
		ob_end_clean();
		return $output;
	}
	
	function loadconfig(){
		$config['HOST'] = "dev.burrdesign.de";
		$config['LayoutClass'] = "burrdesign";
		return $config;
	}
	
	function prepareTextSQL($string){
		$string = str_replace('ä','&auml;',$string);
		$string = str_replace('ü','&uuml;',$string);
		$string = str_replace('ö','&ouml;',$string);
		$string = str_replace('Ä','&Auml;',$string);
		$string = str_replace('Ü','&Uuml;',$string);
		$string = str_replace('Ö','&Ouml;',$string);
		$string = str_replace('ß','&szlig;',$string);
		$string = str_replace('€','&euro;',$string);
		
		return $string;
	}

	
	function write_log($type,$message){
		$query = "INSERT INTO bd_system_logs (logDate, logSession, logType, logMessage) VALUES (NOW(), '".$_SESSION['BURRDESIGN']['SESSIONID']."','".$type."','".$message."')";
		$write = sqlquery($query,"insert");
	}
	
?>