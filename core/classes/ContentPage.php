<?php

	/************************************************************************
	Hauptklasse des BurrDesign für das Laden und Ausgeben der Seiteninhalte
	Version 0.1
	Copyright by Julian Burr - 30.07.2012
	************************************************************************/
	
	include_once($_SERVER['DOCUMENT_ROOT']."/core/classes/Template.php");

	class ContentPage {
		
		private $page_url;
		private $page_object = array();
		
		public function __construct($page){
			$this->page_url = $page;
		}
		
		public function loadPageContent(){
			$success = false;
			
			//Versuchen den Inhalt unter den Seiteninhalten zu finden
			$pg = $this->page_url;
			$this->page_object['pagedata'] = sqlresult("SELECT * FROM bd_main_contents WHERE contentURL = '$pg' LIMIT 1");
			
			if($this->page_object['pagedata']['contentKey']){
				$success = true;
			} else {
				$success = $this->loadFunctionsContent();
			}
			
			return $success;
		}
		
		private function loadFunctionsContent(){
			$success = false;
			
			//zuerst Neuigkeiten versuchen
			$news_basicurl = $_SESSION['BURRDESIGN']['CONFIG']['news_basicurl'];
			$page = $this->page_url;
			if($news_basicurl && strpos($page,$news_basicurl) !== false && strpos($page,$news_basicurl) == 0){
				//News-Basisurl steht am Anfang => News laden
				$pg = str_replace($news_basicurl,"",$page);
				$this->page_object['newsdata'] = sqlresult("SELECT * FROM bd_main_news WHERE newsUrl = '$pg' LIMIT 1");
				
				if($this->page_object['newsdata']['newsKey']){
					if(!$this->page_object['newsdata']['newsTemplate']){
						$this->page_object['newsdata']['newsTemplate'] = "news/detail.tpl";
					}
					return true;
				}
			}
			
			return $success;
		}
			
		
		public function printContentPage(){
			$tpl = new Template($this->page_object['pagedata']['contentTemplate']);
			$tpl->parseTemplateContent($this->page_object['pagedata']['contentText']);
			$tpl->printTemplateContent();
		}
		
		public function printPageError($code){
			if($code == 404){
				$tpl = new Template("error/404error.tpl");
				$tpl->parseTemplateContent("<pre>Seite konnte nicht gefunden werden!</pre>");
				$tpl->printTemplateContent();
				exit();
			}
		}
		
	}
	
?>