<?php

	/***********************************************
	Hauptklasse des BurrDesign Session-Verwaltung
	Version 0.1
	Copyright by Julian Burr - 30.07.2012
	***********************************************/

	class Session {
		
		public function __construct(){
		}
		
		public function getSession(){
			if($_SESSION['BURRDESIGN']['CONFIG']['isset'] != 1 || $_GET['initSession'] == 1){				
				$this->newSession();
			}
		}
		
		public function newSession(){
			//Session-Initialisierung
			$_SESSION['BURRDESIGN']['SESSION'] = session_id();
			$_SESSION['BURRDESIGN']['PAGE'] = $page;
			$_SESSION['BURRDESIGN']['CONFIG'] = $this->loadconfig();
			$_SESSION['BURRDESIGN']['CONFIG']['isset'] = 1;
		}
		
		public function loadConfig(){
			$config['HOST'] = "dev.burrdesign.de";
			$config['LayoutClass'] = "burrdesign";
			$config['LOG'] = true;
			return $config;
		}
		
	}
	
?>