<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-02
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum Handling von Sessions
 */
 
class Session {

	public function getSession(){
		Event::trigger('BurrDesign_Session_PreGetSession');
		
		if(!$_SESSION['BD']['session'] || $_GET['initSession'] == 1){
			//Session noch nicht initialisiert bzw. Initialisierung angefordert
			$this->newSession();
		}
		//Konfiguration immer laden (aus Cache, oder wenn Cache nicht vorhanden ist aus der DB
		$_SESSION['BD']['config'] = Config::load();
		
		Event::trigger('BurrDesign_Session_PostGetSession');
	}
	
	private function newSession(){
		Event::trigger('BurrDesign_Session_PreInitSession');
	
		if($_SESSION['BD']['session']){
			return;
		}
	
		//Session-Initialisierung
		$_SESSION['BD']['session'] = session_id();
		Log::writeLog("INF","Sessioninitalisierung durchgeführt");
		
		//für Statistiken festhalten
		Stats::newSession($_SESSION);
		
		Event::trigger('BurrDesign_Session_PostInitSession');
	}

}