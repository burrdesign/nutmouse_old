<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-02
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum Schreiben von Log-Einträgen in die Datenbank
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/db/SqlManager.php');
 
class Log {

	public static function writeLog($type, $text){
		if($_SESSION['BD']['config']['enableLogs'] != 1){
			//Log deaktiviert
			return;
		}
		
		$sql = new SqlManager();
		
		$log['logDate'] = date("Y-m-d H:i:s",time());
		$log['logSession'] = $_SESSION['BD']['session'];
		$log['logType'] = $type;
		$log['logText'] = $message;
		
		$log['logIP'] = '';
		$log['logSource'] = '';
		
		$sql->insert("bd_sys_log",$log);
	}
	
}