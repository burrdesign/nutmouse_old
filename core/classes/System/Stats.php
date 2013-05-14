<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-04-17
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum festhalten von Statistiken
 */
 
class Stats {

	private static $stats_site_table = "bd_stats_site";
	private static $stats_session_table = "bd_stats_session";

	public static function callUrl($url, $session){
		if(!is_array($session)){
			return;
		}
		
		//URL wurde aufgerufen
		$sql = new SqlManager();
		$insert = array(
			'statsSiteURL' => $url,
			'statsSiteDate' => date("Y-m-d H:i:s", time()),
			'statsSiteSessionId' => $session['BD']['session']
		);
		$sql->insert(self::$stats_site_table, $insert);
	}
	
	public static function newSession($session){
		if(!is_array($session)){
			return;
		}
		
		//neue Session wurde initialisiert
		$sql = new SqlManager();
		$insert = array(
			'statsSessionId' => $session['BD']['session'],
			'statsSessionEnterDate' => date("Y-m-d H:i:s", time()),
			'statsSessionReferer' => $_SERVER['HTTP_REFERER'],
			'statsSessionUserAgent' => $_SERVER['HTTP_USER_AGENT'],
			'statsSessionRemoteAddress' => $_SERVER['REMOTE_ADDR']
		);
		$sql->insert(self::$stats_session_table, $insert);
	}

}