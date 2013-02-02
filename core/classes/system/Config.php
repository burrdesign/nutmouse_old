<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-02
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum Verwalten der Systemkonfiguration
 *		Hier sollte ggf. ein Hook für Plugins eingebaut werdem?!
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Cache.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/db/SqlManager.php');
 
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
			Cache::saveCache($cachekey,$config);
		}
		
		return $config;
	}
	
}