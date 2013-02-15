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

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Model.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Db/SqlManager.php');

class Models_Frontend_Index extends Model {

	//Inhalt anhand des Pfades laden
	public static function getContentByPath($path){
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
	
	//Inhalt anhand des Schlüssels laden
	public static function getContentByKey($key){
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
	
}