<?php

	/***********************************************
	Hauptklasse des BurrDesign NutMouse CMS Systems
	Version 0.1
	Copyright by Julian Burr - 30.07.2012
	***********************************************/
	
	include_once($_SERVER['DOCUMENT_ROOT']."/core/classes/Session.php");
	include_once($_SERVER['DOCUMENT_ROOT']."/core/classes/AdminPage.php");
	include_once($_SERVER['DOCUMENT_ROOT']."/core/classes/ContentPage.php");
	
	class BurrDesignCMS {		
		
		public function __construct($page){
			
			//Session holen und ggf. initialisieren
			$session = new Session();
			$session->getSession();
			
			//Immer auf eingestellten Host umleiten
			if($_SERVER['HTTP_HOST'] != $_SESSION['BURRDESIGN']['CONFIG']['HOST']){
				header("Location: http://".$_SESSION['BURRDESIGN']['CONFIG']['HOST'].$_SERVER['REQUEST_URI']);
				exit;
			}
			
			//Admin-Startseite immer mit abschließendem Slash aufrufen
			if($page == "admin"){
				header("Location: http://".$_SESSION['BURRDESIGN']['CONFIG']['HOST']."/admin/");
				exit;
			}

			//Adminbereich oder Frontend?
			if(strpos($page,"admin/") !== false && strpos($page,"admin/") == 0){
				$content = new AdminPage($page);
				$load = $content->loadPageModule();
				if(!$load){
					$content->printAdminError();
				}
				//und Ausgabe
				$content->printAdminPage();
			} else {
				$content = new ContentPage($page);
				$load = $content->loadPageContent();
				if(!$load){
					header("HTTP/1.1 404 Not Found");
					$content->printPageError(404);
				}
				//und Ausgabe
				$content->printContentPage();
			}
		}
		
	}
	
?>