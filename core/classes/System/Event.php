<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-15
 *
 * @Beschreibung:
 *		Event-Klasse zum triggern von Events und binden von bspw.
 *		Plugins an diese
 */

class Event {

	private static $bound = array();
	private static $plugin_path = 'core/classes/Plugins';
	
	public static function bind($event, $class, $function){
		//Pluginfunktion an Event binden (nur einmal!)
		$boundclass = self::$bound[$event][$class];
		for($i=0; $i<count($boundclass); $i++){
			if($boundclass[$i] == $function){
				return;
			}
		}
		self::$bound[$event][$class][] = $function;
	}
	
	public static function unbind($event, $class, $function){
		//Gebundene Klassenfunktion wieder lösen
		$boundclass = self::$bound[$event][$class];
		for($i=0; $i<count($boundclass); $i++){
			if($boundclass[$i] == $function){
				unset($boundclass[$i]);
			}
		}
	}
	
	public static function trigger($event){
		//Event triggern und dadurch die gebundenen Funktionen auslösen
		$to_trigger = self::$bound[$event];
		foreach($to_trigger as $class => $functions){
			include_once($_SERVER['DOCUMENT_ROOT'] . '/' . self::$plugin_path . '/' . $class . '/' . $class . '.php');
			$call = new $class();
			foreach($functions as $function){
				$call->$function();
			}
		}
	}

}