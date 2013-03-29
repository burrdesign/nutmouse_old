<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 *
 * @Beschreibung:
 *		Model-Klasse zum laden der angeforderten Neuigkeit
 */

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Model.php');

class Models_Frontend_News extends Model {

	//Neuigkeit anhand des Keys laden
	public static function getNewsByKey($key){	
		Event::trigger('Model_Frontend_News_ContentByKey_PreLoad');
		
		self::$sql = new SqlManager();
		self::$sql->setQuery("
			SELECT * FROM bd_main_news
			WHERE newsKey = {{key}}
			LIMIT 1
			");
		self::$sql->bindParam("{{key}}",$key,"int");
		$newsData = self::$sql->result();
		
		//Kommentare laden
		self::$sql = new SqlManager();
		self::$sql->setQuery("
			SELECT * FROM bd_main_news_comment
			WHERE commentNewsKey = {{key}}
			ORDER BY commentDate DESC
			");
		self::$sql->bindParam("{{key}}",$key,"int");
		$newsComments = self::$sql->execute();
		
		$newsData['commentCnt'] = mysql_num_rows($newsComments);
		$newsData['commentQuery'] = $newsComments;
		
		self::$entry = $newsData;
		
		Event::trigger('Model_Frontend_News_ContentByKey_PostLoad');
		
		if(self::$entry['newsKey']){
			return self::$entry;
		} else {
			return false;
		}
	}
	
}