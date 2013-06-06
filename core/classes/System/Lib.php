<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-03-31
 *
 * @Beschreibung: Hauptbibliothek von kleineren Hilfsfunktionen
 */
 
class Lib {

	public static function recursiveReadDir($dir, $exclude=array()){
		//Liest ein Verzeichnis rekursiv aus und gibt alle Dateien und Verzeichnisse als Array zurück
		//Optional kann ein Array mit Excludes übergeben werden, die nicht mit gelesen werden sollen
		$return = array();
		if(!is_dir($dir)){
			return $return;
		}
		$handle = opendir($dir);
		while($f = readdir($handle)){
			if($f != "." && $f != ".." && !in_array($dir . $f, $exclude)){
				if(is_file($dir . $f)){
					$return[] = $dir . $f;
				} elseif(is_dir($dir . $f)){
					$return[] = $dir . $f;
					$return_sub = array();
					$return_sub = self::recursiveReadDir($dir . $f . "/", $exclude);
					$return = array_merge($return, $return_sub);
				}
			}
		}
		closedir($handle);
		return $return;
	}

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
	
	public static function writeDbConfigFile($host, $user, $pwd, $db){
		$configcontent = "<?php\n\n\$HOST={$host};\r\n\$USER={$user};\r\n\$PWD={$pwd};\r\n\$DB={$db};";
		file_put_contents($configfile, $configcontent);
	}
	
	public static function checkAdminModuleRight($module){
		$key = "";
		if(!is_string($module)){
			$key = $module;
		} else {
			$sql = new SqlManager();
			$sql->setQuery("
				SELECT * FROM bd_sys_admin_module
				WHERE moduleCoreFile = '{{path}}' AND modulePlugin = 0
				LIMIT 1
				");
			$sql->bindParam("{{path}}",$module);
			$mod = $sql->result();
			$key = $mod['moduleKey'];
		}
		return $_SESSION['BD']['ADMIN']['user']['rights'][$key];
	}

}