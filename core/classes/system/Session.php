<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-02
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum Handling von Sessions
 *		Hier wäre auch der Ansatzpunkt für Statistik-Hooks
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Log.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Config.php');
 
class Session {

	public function getSession(){
		if(!$_SESSION['BD']['session'] || $_GET['initSession'] == 1){
			//Session noch nicht initialisiert bzw. Initialisierung angefordert
			$this->newSession();
		}
		//Konfiguration immer laden (aus Cache, oder wenn Cache nicht vorhanden ist aus der DB
		$_SESSION['BD']['config'] = Config::load();
	}
	
	private function newSession(){
		//Session-Initialisierung
		$_SESSION['BD']['session'] = session_id();
		Log::writeLog("INF","Sessioninitalisierung durchgeführt");
	}

}