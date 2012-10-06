<?php

	/***********************************************
	PHP-Hilfsfunktionen
	Version 0.1
	Copyright by Julian Burr - 12.07.2012
	***********************************************/
	
	include_once($_SERVER['DOCUMENT_ROOT']."/core/classes/SQLManager.php");
	include_once($_SERVER['DOCUMENT_ROOT']."/core/classes/Log.php");
	
	function get_include($module_path){
		$output = "";
		ob_start();
			//Modul laden, ausführen und Output in Variable speichern und zurück geben
			include($module_path);
			$output = ob_get_contents();
		ob_end_clean();
		return $output;
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
	
?>