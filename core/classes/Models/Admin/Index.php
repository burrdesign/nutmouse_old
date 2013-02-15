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

class Models_Admin_Index extends Model {

	public static function getAdminContentByPath($path){
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