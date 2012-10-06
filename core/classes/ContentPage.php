<?php

	/************************************************************************
	Hauptklasse des BurrDesign für das Laden und Ausgeben der Seiteninhalte
	Version 0.1
	Copyright by Julian Burr - 19.09.2012
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
			$page_query = new SQLManager();
			$page_query->setQuery("
				SELECT * FROM bd_main_content
				JOIN bd_main_content_version ON (contentKey = versionContentKey)
				WHERE contentURL = '{{page}}' AND versionActive = 1
				LIMIT 1
				");
			$page_query->bindParam("{{page}}",$pg);
			$this->page_object['pagedata'] = $page_query->result();
			
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
				$news_query = new SQLManager();
				$this->page_object['newsdata'] = $news_query->get("bd_main_news","newsUrl",$pg);
				
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
			$tpl = new Template($this->page_object['pagedata']['versionTemplate']);
			$tpl->parseTemplateContent($this->page_object['pagedata']['versionText']);
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