<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 *
 * @Beschreibung:
 *		Model-Klasse zum laden der angeforderten Galerie
 */

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Model.php');

class Models_Frontend_Galery extends Model {

	//Galerie anhand des Keys laden
	public static function getGaleryByKey($key){	
		Event::trigger('Model_Frontend_Galery_ContentByKey_PreLoad');
		
		self::$sql = new SqlManager();
		self::$sql->setQuery("
			SELECT * FROM bd_main_galery
			WHERE galeryKey = {{key}}
			LIMIT 1
			");
		self::$sql->bindParam("{{key}}",$key,"int");
		$galeryData = self::$sql->result();
		
		//Bilder laden
		self::$sql = new SqlManager();
		self::$sql->setQuery("
			SELECT * FROM bd_main_galery_image
			WHERE imageGaleryKey = {{key}}
			");
		self::$sql->bindParam("{{key}}",$key,"int");
		$galeryImages = self::$sql->execute();
		
		$newsData['galeryImageCnt'] = mysql_num_rows($galeryImages);
		$newsData['galeryImageQuery'] = $galeryImages;
		
		self::$entry = $galeryData;
		
		Event::trigger('Model_Frontend_Galery_ContentByKey_PostLoad');
		
		if(self::$entry['galeryKey']){
			return self::$entry;
		} else {
			return false;
		}
	}
	
}