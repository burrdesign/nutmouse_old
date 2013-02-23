<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 *
 * @Beschreibung:
 *		Vorlagen-Klasse für alle Pluginklassen
 */

class Plugin {

	protected $info = array();

	final public function __construct(){
		//nichts machen!
	}
	
	final protected function bind($event, $function){
		//Pluginfunktion an Event binden
		Event::bind($event, get_class($this), $function);
	}
	
	public function install(){
		//Plugin in die Datenbank schreiben
		$this->info['pluginName'] = get_class($this);
		$this->info['pluginInstalled'] = date("Y-m-d H:i:s", time());
		$this->info['pluginActive'] = 1;
		
		//Plugin in die SQL-Tabelle schreiben
		$sql = new SqlManager();
		$sql->insert('bd_sys_plugin',$this->info);
	}
	
	public function uninstall(){
		//Plugin aus der Datenbank löschen
		$sql = new SqlManager();
		$sql->setQuery("
			SELECT * FROM bd_sys_plugin
			WHERE pluginName = '{{Name}}'
			LIMIT 1
			");
		$sql->bindParam("{{Name}}",get_class($this));
		$uninstall = $sql->result();
		if($uninstall['pluginKey']){
			$sql->delete('bd_sys_plugin',$uninstall);
		}
	}
	
	public function init(){
		//Initialisierung
	}
	
}