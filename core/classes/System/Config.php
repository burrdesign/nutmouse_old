<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-02
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum Verwalten der Systemkonfiguration
 *		Hier sollte ggf. ein Hook f�r Plugins eingebaut werdem?!
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Cache.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Db/SqlManager.php');
 
class Config {
	
	public static function load($cachekey="config"){
		$config = Cache::loadCache($cachekey);
	
		if(!is_array($config)){
			//kein Cache vorhanden, also neu aus der Datenbank laden
			$sql = new SqlManager();
			$sql->setQuery("SELECT * FROM bd_sys_config");
			$result = $sql->execute();
			$config = array();
			while($res = mysql_fetch_array($result)){
				$config[$res['configLabel']] = $res['configValue'];
			}
			$_SESSION['BD']['config'] = $config;
			Cache::saveCache($cachekey,$config);
		}
		
		return $config;
	}
	
	public static function get($key){
		if(!$_SESSION['BD']['config']){
			$_SESSION['BD']['config'] = self::load();
		}
		return $_SESSION['BD']['config'][$key];
	}
	
}