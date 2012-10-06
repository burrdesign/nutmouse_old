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
		
		public function loadContent($key="",$version=""){
			//Inhalt anhand des übergebenen Schlüssels laden
			if($key){
				$this->content_key = $key;
			}
			$sql = new SQLManager();
			
			$where = "WHERE contentKey = {{key}} ";
			if(!$version){
				$where .= "AND versionActive = 1";
			} else {
				$where .= "AND versionNumber = {{version}}";
			}
			
			$sql->setQuery("
				SELECT * FROM bd_main_content
				JOIN bd_main_content_version ON (contentKey = versionContentKey)
				$where
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$this->content_key,"int");
			$sql->bindParam("{{version}}",$version,"int");
			$result = $sql->result();
			$this->content_array = $result;
			return $result;
		}
		
		public function saveContent($array){
			if(!is_array($array) || !$array['contentKey']){
				$this->content_messages['global']['errormsg'] .= "<p>Der Inhalt konnte nicht gespeichert werden!</p>\n";
				return;
			}
			
			$array['contentTitle'] = prepareTextSQL($array['contentTitle']);
			$array['versionText'] = prepareTextSQL($array['versionText']);
			$array['versionLastChanged'] = date("Y-m-d H:i:s",time());
			
			$sql = new SQLManager();
			$sql->update("bd_main_content",$array);
			$sql->update("bd_main_content_version",$array);
			
			if($array['versionActive'] == 1){
				$this->activateContentVersion($this->content_key,$array['versionKey']);
			}
		}
		
		public function saveContentNewVersion($array){
			//Inhalt als neue Version speichern
			if(!is_array($array) || !$array['contentKey']){
				$this->content_messages['global']['errormsg'] .= "<p>Der Inhalt konnte nicht gespeichert werden!</p>\n";
				return;
			}
			
			$sql = new SQLManager();
			$sql->setQuery("
				SELECT versionNumber FROM bd_main_content_version 
				WHERE versionContentKey = '{{key}}' ORDER BY versionNumber DESC LIMIT 1
				");
			$sql->bindParam("{{key}}", $this->content_key);
			$oldmaxversion = $sql->result();
			
			$array['versionKey'] = "";
			$array['versionContentKey'] = $this->content_key;
			$array['contentTitle'] = prepareTextSQL($array['contentTitle']);
			$array['versionText'] = prepareTextSQL($array['versionText']);
			$array['versionNumber'] = (int)$oldmaxversion['versionNumber'] + 1;
			$array['versionLastChanged'] = date("Y-m-d H:i:s",time());
			$array['versionCreated'] = date("Y-m-d H:i:s",time());
			
			$sql->update("bd_main_content",$array);
			$sql->insert("bd_main_content_version",$array);
			$versionKey = $sql->getLastInsertID();
			
			if($array['versionActive'] == 1){
				$this->activateContentVersion($this->content_key,$versionKey);
			}
		}
		
		public function saveNewContent($array){
			//Neuen Inhalt anlegen
			if(!is_array($array)){
				$this->content_messages['global']['errormsg'] .= "<p>Der Inhalt konnte nicht gespeichert werden!</p>\n";
				return;
			}
			
			$array['contentTitle'] = prepareTextSQL($array['contentTitle']);
			
			$sql = new SQLManager();
			$sql->insert("bd_main_content",$array);
			$contentKey = $sql->getLastInsertID();
			$this->content_last_insert_id = $contentKey;
			
			$array['versionContentKey'] = $this->content_last_insert_id;
			$array['versionText'] = prepareTextSQL($array['versionText']);
			$array['versionLastChanged'] = date("Y-m-d H:i:s",time());
			$array['versionCreated'] = date("Y-m-d H:i:s",time());
			$array['versionNumber'] = 1;
			
			$sql->insert("bd_main_content_version",$array);
			$versionKey = $sql->getLastInsertID();
			
			if($array['versionActive'] == 1){
				$this->activateContentVersion($contentKey,$versionKey);
			}
		}
		
		public function getLastInsertID(){
			return $this->content_last_insert_id;
		}
		
		public function printDeleteAcception($array){
			//Sicherheitsabfrage, ob Datensatz wirklich gelöscht werden soll
			$inhalt = $this->loadContent();
			echo "<h3>Soll der Inhalt <span class=\"deletekey\">".$this->content_array['contentURL']."</span> <span class=\"deleteversion\">Version ".$array['versionNumber']."</span> wirklich gel&ouml;scht werden?</h3>\n\n";
			$formular = new Formular($this->content_array);
			$formular->printFormStart("inhalte_detail","?file=".$this->content_key,"post");
			$formular->printInputHidden("contentKey",$array['contentKey']);
			$formular->printInputHidden("versionKey",$array['versionKey']);
			$formular->printSubmit("deleteaccepted","Ja, wirklich l&ouml;schen","clear button_deleteacception");
			$formular->printSubmit("deletecanceld","Nein, Vorgang abbrechen","button_cancel");
			$formular->printFormEnd();
		}
		
		public function deleteContent($array){
			if(!$this->content_key){
				$this->content_messages['global']['errormsg'] .= "<p>Löschung konnte nicht vorgenommen werden!</p>";
				return false;
			}
			
			$del = array();
			$del['contentKey'] = $array['contentKey'];
			$del['versionKey'] = $array['versionKey'];
			
			$sql = new SQLManager();
			$sql->setQUery("
				SELECT COUNT(*) AS Anzahl FROM bd_main_content_version
				WHERE versionContentKey = {{key}}
				");
			$sql->bindParam("{{key}}",$del['contentKey'],"int");
			$check = $sql->result();
			
			if($check['Anzahl'] == 0){
				$sql->delete("bd_main_content",$del);
			}
			$sql->delete("bd_main_content_version",$del);
			
			return true;	
		}
		
		public function activateContentVersion($contentKey,$versionKey=""){
			$sql = new SQLManager();
			$sql->setQuery("
				UPDATE bd_main_content_version 
				SET versionActive = 0
				WHERE versionContentKey = {{key}}
				");
			$sql->bindParam("{{key}}",$contentKey);
			$sql->execute();
			
			if($versionKey){
				$sql->setQuery("
				UPDATE bd_main_content_version 
				SET versionActive = 1
				WHERE versionKey = {{key}}
				");
				$sql->bindParam("{{key}}",$versionKey);
				$sql->execute();
			}
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
		
		public function printContentSourceInfo(){
			//Zusatzinfos
			$info = $this->content_array;
			echo "<div class=\"wrap_sourceinfo\"><div class=\"inner\">";
			$dots = split("\.",$info['contentURL']);
			$filetype = $dots[count($dots)-1];
			echo "<div class=\"icon\"><span class=\"icon icon_$filetype\"></span></div>";
			$slashs = split("/",$info['contentURL']);
			$filename = $slashs[count($slashs)-1];
			if(!$filename){
				if(!$info['contentKey']){
					$filename = "<span class=\"noname\">new</span>";
				} else {
					$filename = "<span class=\"noname\">index</span>";
				}
			}
			echo "<div class=\"filename\">$filename</div>";
			if($info['contentKey']){
				echo "<div class=\"lastchanged\"><span class=\"noname\">Zuletzt ge&auml;ndert: ".$info['versionLastChanged']."</span></div>";
				//echo "<div class=\"lastchangedby\">".$info['versionLastChangedBy']."</div>";
			}
			$checked = "";
			if($info['versionActive'] != 0 || !$info['contentKey']){
				$checked = "checked=\"checked\"";
			}
			echo "<div class=\"versionactive\"><input type=\"hidden\" name=\"versionActive\" value=\"0\"><input type=\"checkbox\" name=\"versionActive\" value=\"1\" $checked></div>";
			if($info['contentKey']){
				$sql = new SQLManager();
				$sql->setQuery("
					SELECT versionNumber FROM bd_main_content_version 
					WHERE versionContentKey = {{key}} 
					ORDER BY versionNumber ASC
					");
				$sql->bindParam("{{key}}",$info['contentKey'],"int");
				$versions = $sql->execute();
				echo "<div class=\"versions\"><span class=\"noname\">Version:</span>";
				while($version = mysql_fetch_array($versions)){
					if($version['versionNumber'] == $info['versionNumber']){
						echo " <span class=\"current_version version_".$version['versionNumber']."\">".$version['versionNumber']."</span>";
					} else {
						echo " <a class=\"version version_".$version['versionNumber']."\" href=\"?file=".$info['contentKey']."&version=".$version['versionNumber']."\">".$version['versionNumber']."</a>";
					}
				}
				echo "</div>";
			}
			echo "</div></div>\n";
		}
		
	}
	
?>