<?php

	/**************************************
	Hauptklasse für das Schreiben von Logs
	Version 0.1
	Copyright by Julian Burr - 06.10.2012
	**************************************/

	class Log {
		
		public function __construct(){
		}
		
		public function writeLog($type,$message){
			if(!$_SESSION['BURRDESIGN']['CONFIG']['LOG']){
				//Log deaktiviert
				return;
			}
			
			$sql = new SQLManager();
			
			$log['logDate'] = date("Y-m-d H:i:s",time());
			$log['logSession'] = $_SESSION['BURRDESIGN']['SESSION'];
			$log['logType'] = $type;
			$log['logMessage'] = $message;
			
			$sql->insert("bd_system_log",$log);
		}
	}
	
	$_SESSION['LOG'] = new Log();

?>