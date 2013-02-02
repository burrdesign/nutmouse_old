<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-02
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum Handling von Sessions
 *		Hier w�re auch der Ansatzpunkt f�r Statistik-Hooks
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Config.php');
 
class Session {

	public function getSession(){
		if($_SESSION['BD']['config']['isset'] != 1 || $_GET['initSession'] == 1){
			//Session noch nicht initialisiert bzw. Initialisierung angefordert
			$this->newSession();
		}
	}
	
	private function newSession(){
		//Session-Initialisierung
		$_SESSION['BD']['session'] = session_id();
		$_SESSION['BD']['config'] = Config::load();
		$_SESSION['BD']['config']['isset'] = 1;
	}

}