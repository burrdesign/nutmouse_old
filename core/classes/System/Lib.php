<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-23
 *
 * @Beschreibung: Hauptbibliothek von kleineren Hilfsfunktionen
 */
 
class Lib {

	public static function recursiveRmdir($dir){
		//Hilfsfunktion zum rekursiven Löschen von Verzeichnissen
		if(!is_dir($dir)){
			return;
		}
		$handle = opendir($dir);
		while($e = readdir($handle)){
			if($e != "." && $e != ".."){
				if(is_file($dir . $e)){
					unlink($dir . $e);
				} elseif(is_dir($dir . $e)){
					//rekursiv Löschen
					self::recursiveRmdir($dir . $e . '/');
				}
			}
		}
		closedir($handle);
		rmdir($dir);
	}
	
	public static function textToUrl($text){
		$return = strtolower($text);
		$return = str_replace("/","_",$return);
		$return = str_replace(" & ","-und-",$return);
		$return = str_replace("&uuml","ue",$return);
		$return = str_replace("&auml","ae",$return);
		$return = str_replace("&ouml","oe",$return);
		$return = str_replace("&szlig","ss",$return);
		$return = str_replace("ü","ue",$return);
		$return = str_replace("ä","ae",$return);
		$return = str_replace("ö","oe",$return);
		$return = str_replace("ß","ss",$return);
		$return = str_replace(" ","-",$return);
		$return = str_replace("§","",$return);
		$return = str_replace("&euro;","euro",$return);
		$return = str_replace("€","euro",$return);
		$return = str_replace("$","dollar",$return);
		$return = str_replace("&amp;","und",$return);
		$return = str_replace("&","",$return);
		$return = str_replace("?","",$return);
		$return = str_replace("(","",$return);
		$return = str_replace(")","",$return);
		$return = str_replace("%","prozent",$return);
		$return = str_replace("!","",$return);
		$return = str_replace(",","",$return);
		$return = str_replace(".","",$return);
		$return = str_replace("\"","",$return);
		$return = str_replace("'","",$return);
		$return = str_replace("=","-gleich-",$return);
		$return = str_replace("--","-",$return);
		return $return;
	}
	
	public static function getCanonicalUrl($type,$key,$title=""){
		$url = "";
		switch($type){
			case "news":
				$urltitle = self::textToUrl($title);
				$url = "/news/{$key}/{$urltitle}";
				break;
			case "galery":
				$urltitle = self::textToUrl($title);
				$url = "/pics/{$key}/{$urltitle}";
				break;
		}
		return $url;
	}

}