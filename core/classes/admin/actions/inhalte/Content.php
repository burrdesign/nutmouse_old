<?php

	/*****************************************************************************
	Hauptklasse zur Verwaltung von Seiteninhalten (Contents) und deren Actions
	Version 0.1
	Copyright by Julian Burr - 06.10.2012
	*****************************************************************************/

	class Content {
		
		private $content_key;
		private $content_array = array();
		private $content_messages = array();
		private $content_last_insert_id;
		
		public function __construct($key,$array=""){
			$this->content_key = $key;
			if(is_array($array)) $this->content_array = $array;
		}
		
		public function loadContent($key=""){
			//Inhalt anhand des übergebenen Schlüssels laden
			if($key){
				$this->content_key = $key;
			}
			$sql = new SQLManager();
			$result = $sql->get("bd_main_contents","contentKey",$this->content_key);
			$this->content_array = $result;
			return $result;
		}
		
		public function saveContent($array){
			if(!is_array($array) || !$array['contentKey']){
				$this->content_messages['global']['errormsg'] .= "<p>Der Inhalt konnte nicht gespeichert werden!</p>\n";
				return;
			}
			$array['contentTitle'] = prepareTextSQL($array['contentTitle']);
			$array['contentText'] = prepareTextSQL($array['contentText']);
			$array['contentLastChanged'] = date("Y-m-d H:i:s",time());
			
			$sql = new SQLManager();
			$sql->update("bd_main_contents",$array);
		}
		
		public function saveContentNewVersion($array){
			if(!is_array($array) || !$array['contentKey']){
				$this->content_messages['global']['errormsg'] .= "<p>Der Inhalt konnte nicht gespeichert werden!</p>\n";
				return;
			}
			
			$sql = new SQLManager();
			$sql->setQuery("SELECT contentVersion FROM bd_main_contents WHERE contentURL = '{{url}}' ORDER BY contentVersion DESC LIMIT 1");
			$sql->bindParam("{{url}}", $array['contentURL']);
			$oldmaxversion = $sql->result();
			
			$sql->setQuery("UPDATE bd_main_contents SET contentActive = 0");
			$sql->execute();
			
			$array['contentKey'] = "";
			$array['contentTitle'] = prepareTextSQL($array['contentTitle']);
			$array['contentText'] = prepareTextSQL($array['contentText']);
			$array['contentVersion'] = (int)$oldmaxversion['contentVersion'] + 1;
			$array['contentLastChanged'] = date("Y-m-d H:i:s",time());
			$array['contentLastChanged'] = date("Y-m-d H:i:s",time());
			$array['contentActive'] = 1;
			$sql->insert("bd_main_contents",$array);
			$this->content_last_insert_id = $sql->getLastInsertID();
		}
		
		public function saveNewContent($array){
			if(!is_array($array)){
				$this->content_messages['global']['errormsg'] .= "<p>Der Inhalt konnte nicht gespeichert werden!</p>\n";
				return;
			}
			$array['contentTitle'] = prepareTextSQL($array['contentTitle']);
			$array['contentText'] = prepareTextSQL($array['contentText']);
			
			$sql = new SQLManager();
			$array['contentLastChanged'] = date("Y-m-d H:i:s",time());
			$array['contentLastChanged'] = date("Y-m-d H:i:s",time());
			$sql->insert("bd_main_contents",$array);
			$this->content_last_insert_id = $sql->getLastInsertID();
		}
		
		public function getLastInsertID(){
			return $this->content_last_insert_id;
		}
		
		public function printDeleteAcception(){
			//Sicherheitsabfrage, ob Datensatz wirklich gelöscht werden soll
			$inhalt = $this->loadContent();
			echo "<h3>Soll der Inhalt <span class=\"deletekey\">".$this->content_array['contentURL']."</span> <span class=\"deleteversion\">Version ".$this->content_array['contentVersion']."</span> wirklich gel&ouml;scht werden?</h3>\n\n";
			$formular = new Formular($this->content_array);
			$formular->printFormStart("inhalte_detail","?file=".$this->content_key,"post");
			$formular->printSubmit("deleteaccepted","Ja, wirklich l&ouml;schen","clear button_deleteacception");
			$formular->printSubmit("deletecanceld","Nein, Vorgang abbrechen","button_cancel");
			$formular->printFormEnd();
		}
		
		public function deleteContent(){
			if(!$this->content_key){
				$this->content_messages['global']['errormsg'] .= "<p>Löschung konnte nicht vorgenommen werden!</p>";
				return false;
			}
			$del = array();
			$del['contentKey'] = $this->content_key;
			$sql = new SQLManager();
			$sql->delete("bd_main_contents",$del);
			return true;	
		}
		
		public function getMessages(){
			return $this->content_messages;
		}
		
		public function printURLPath($path=""){
			if(!$path){
				$path = $this->content_array['contentURL'];
			}
			
			if(!$path && !$this->content_key){
				$path = $_POST['addnew_from'];
			}
			
			echo "<div class=\"wrap_contentlist_settings\">\n";		
			echo "<div class=\"setting_url setting\"><span class=\"label\">URL-PFAD:</span>";
			echo "<a href=\"?dir=\">".$_SESSION['BURRDESIGN']['CONFIG']['HOST']."/</a>";
			
			$dirs = split("/",$path);
			$cnt = 0;
			$collect = "";
			foreach($dirs as $dir){
				$cnt++;
				if($cnt == count($dirs)){
					if($dir == "") break;
					echo "<span class=\"current\">$dir</span>";
				} elseif($dir != ""){
					$collect .= $dir."/";
					echo "<a href=\"?dir=$collect\">$dir/</a>";
				}
			}
			echo "</div>";
			echo "</div>";
		}
		
	}
	
?>