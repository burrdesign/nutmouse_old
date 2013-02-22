<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-01
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum speichern und laden von Cache-Files
 *		Auf dieser Klasse basiert z.Z. das simpel aufgebaute Cache-System
 */
 
class Cache {

	public static $cache_dir = '/core/cache/';
	
	public static function loadCache($key,$ttl="no_ttl"){
		if($_SESSION['BD']['config']['enable_cache'] != "1") return false;
		$file = md5($key);
		$path = $_SERVER['DOCUMENT_ROOT'] . self::$cache_dir . $file;
		if(is_file($path)){
			if($ttl == "no_ttl" || time() < (filemtime($path) + (int)$ttl)){
				//Cachedatei ist noch gültig
				$cache = unserialize(file_get_contents($path));
				return $cache;
			}
			//Cachedatei ist nicht mehr gültig
			unlink($path);
			return false;
		}
		//keine Cachedatei gefunden
		return false;
	}
	
	public static function saveCache($key, $data){
		if($_SESSION['BD']['config']['enable_cache'] != "1") return;
		$file = md5($key);
		$data = serialize($data);
		file_put_contents($_SERVER['DOCUMENT_ROOT'] . self::$cache_dir . $file, $data);
	}
	
	public static function clearCache($key){
		$file = md5($key);
		$path = $_SERVER['DOCUMENT_ROOT'] . self::$cache_dir . $file;
		if(is_file($path)){
			unlink($path);
		}
	}
	
}