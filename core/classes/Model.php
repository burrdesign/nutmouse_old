<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 *
 * @Beschreibung:
 *		Model-Klasse zum laden der angeforderten Inhalte (sowohl Front- als auch Backend!)
 */

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/db/SqlManager.php');

class Model {

	private static $entry = array();
	private static $sql;
	
	/**
	 * @param: path		angeforderter URL-Pfad
	 */
	public static function getContentByPath($path){
		/**
		 * hier ggf. guter Ansatzpunkt für Cache-Abfrage?! Aber woher die ExpireTime nehmen, 
		 * wenn ich die Seitenspez. einstellbar machen will??
		 */
	
		self::$sql = new SqlManager();
		self::$sql->setQuery("
			SELECT * FROM bd_main_content
			JOIN bd_main_content_version ON (contentKey = versionContentKey)
			WHERE contentPath = '{{path}}' AND versionActive = 1
			LIMIT 1
			");
		self::$sql->bindParam("{{path}}",$path);
		self::$entry = self::$sql->result();
		
		//Hier findet ggf. noch Nachbereitung statt
		
		if(self::$entry['contentKey']){
			return self::$entry;
		} else {
			return false;
		}
	}
	
	/**
	 * @param: key	angeforderter Content-Schlüssel
	 */
	public static function getContentByKey($key){
		/**
		 * hier ggf. guter Ansatzpunkt für Cache-Abfrage?! Aber woher die ExpireTime nehmen, 
		 * wenn ich die Seitenspez. einstellbar machen will??
		 */
		
		self::$sql = new SqlManager();
		self::$sql->setQuery("
			SELECT * FROM bd_main_content
			JOIN bd_main_content_version ON (contentKey = versionContentKey)
			WHERE contentKey = '{{key}}' AND versionActive = 1
			LIMIT 1
			");
		self::$sql->bindParam("{{key}}",$key);
		self::$entry = self::$sql->result();
		
		//Hier findet ggf. noch Nachbereitung statt
		
		if(self::$entry['contentKey']){
			return self::$entry;
		} else {
			return false;
		}
	}
	
	/**
	 * @param: path		angeforderter URL-Pfad
	 */
	public static function getAdminContentByPath($path){
		/**
		 * hier ggf. guter Ansatzpunkt für Cache-Abfrage?! Aber woher die ExpireTime nehmen, 
		 * wenn ich die Seitenspez. einstellbar machen will??
		 */
	
		self::$sql = new SqlManager();
		self::$sql->setQuery("
			SELECT * FROM bd_sys_admin_module
			LEFT JOIN bd_sys_admin_menu ON (moduleMenu = menuKey)
			WHERE modulePath = '{{path}}' AND moduleActive = 1
			LIMIT 1
			");
		self::$sql->bindParam("{{path}}",$path);
		self::$entry = self::$sql->result();
		
		//Hier findet ggf. noch Nachbereitung statt
		
		if(self::$entry['moduleKey']){
			return self::$entry;
		} else {
			return false;
		}
	}
	
}