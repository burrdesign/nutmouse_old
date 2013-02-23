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

}