<?php

	/**********************************************************
	Hauptklasse zum Ausgeben von Contentlisten im Adminbereich
	Version 0.1
	Copyright by Julian Burr - 05.10.2012
	**********************************************************/

	class ContentList {
		
		private $list_id;
		private $list_type;
		private $list_dirs = array();
		private $list_files = array();
		private $list_settings = array();
		
		public function __construct($id){
			$this->list_id = $id;
			$this->list_settings = $_SESSION['BURRDESIGN']['ADMIN']['settings'][$id];
			$this->initList($this->list_settings['maindir']);
		}
		
		public function initList($maindir){
			//Verzeichnisse und Dateien aus aktuellem Verzeichnis in Liste schreiben
			$sql = new SQLManager();
			$where = "WHERE TRUE"; /*versionActive = 1*/
			if($maindir){
				$where .= " AND contentURL LIKE '{{maindir}}%'";
			}
			$sql->setQuery("
				SELECT * FROM bd_main_content 
				JOIN bd_main_content_version ON (contentKey = versionContentKey)
				$where
				ORDER BY contentURL, versionNumber DESC
				");
			$sql->bindParam("{{maindir}}",$maindir);
			$result = $sql->execute();
			
			//Unterverzeichnis als Verzeichnis anlegen
			if($maindir){
				$dirs = split("/",$maindir);
				$subdir = str_replace($dirs[count($dirs)-2]."/","",$maindir);
				$this->addDir($subdir,"..","subdir");
			}
			
			//und zusammenstellen
			while($inhalt = mysql_fetch_array($result)){		
				//relativen URL-Pfad anhand des aktuellen Grundverzeichnisses erstellen
				$rel_url = str_replace($maindir,"",$inhalt['contentURL']);
				
				//anhand der URL die Ordnerstruktur erstellen
				$dirs = split("/",$rel_url);
				
				//Datei bzw. Order ausgeben
				if(count($dirs) > 1){
					$this->addDir($maindir.$dirs[0]."/",$dirs[0]);
				} else {
					$this->addFile(str_replace($maindir,"",$inhalt['contentURL']),$inhalt);
				}
			}
		}
		
		public function addDir($href,$name="",$type="dir"){
			$url = $href;
			$this->list_dirs[$href."_dir"]['title'] = $name;
			if(!$this->list_dirs[$href."_dir"]['title']){
				$this->list_dirs[$href."_dir"]['title'] = $href;
			}
			$this->list_dirs[$href."_dir"]['url'] = $url;
			$this->list_dirs[$href."_dir"]['type'] = $type;
			
		}
		
		public function addFile($title,$info,$type="file",$filetype=""){
			$nmb = count($this->list_files);
			$this->list_files[$nmb]['title'] = $title;
			$this->list_files[$nmb]['info'] = $info;
			$this->list_files[$nmb]['info']['url'] = $info['contentURL'];
			$this->list_files[$nmb]['info']['url_abs'] = $_SESSION['BURRDESIGN']['CONFIG']['HOST']."/".$info['contentURL'];
			$this->list_files[$nmb]['info']['type'] = $type;
			if($filetype){
				$this->list_files[$nmb]['info']['filetype'] = $filetype;
			} else {
				$filetype = split("\.",$title);
				$this->list_files[$nmb]['info']['filetype'] = $filetype[count($filetype)-1];
			}
		}
		
		public function printListNav($elements){
			if(!is_array($elements)){
				//Fehlerhafter Parameter $elements
				return;
			}
			
			echo "<div class=\"wrap_contentlist_settings\">\n";
			
			if(in_array("urlpath",$elements) == true || in_array("all",$elements)){
				//aktuellen URL-Grundpfad ausgeben
				echo "<div class=\"setting_url setting\"><span class=\"label\">URL-PFAD:</span>";
				if($_REQUEST['dir']){
					echo "<a href=\"?dir=\">";
				} else {
					echo "<span class=\"current\">";
				}
				echo $_SESSION['BURRDESIGN']['CONFIG']['HOST']."/";
				if($_REQUEST['dir']){
					echo "</a>";
				} else {
					echo "</span>";
				}
				$dirs = split("/",$this->list_settings['maindir']);
				$collect = "";
				$cnt = 0;
				foreach($dirs as $dir){
					$cnt++;
					if($cnt == count($dirs) - 1){
						echo "<span class=\"current\">$dir/</span>";
					} elseif($dir != ""){
						$collect .= $dir."/";
						echo "<a href=\"?dir=$collect\">$dir/</a>";
					}
				}
				echo "</div>\n";
			}
			
			if(in_array("mixdirs",$elements) == true || in_array("all",$elements)){
				//mögliche Verzeichniseinstellungen ausgeben
			}
			
			if(in_array("sort",$elements) == true || in_array("all",$elements)){
				//mögliche Sortierungen ausgeben
			}
			
			echo "</div>";
		}
					
		
		public function printList(){
			echo "<div class=\"wrap_contentlist\">\n";
			echo "<table><tr><th class=\"icon\"></th><th>Name</th><th>Zuletzt ge&auml;ndert</th><th class=\"version\">Version</th><th>Notiz</th></tr>";
			
			//Verzeichnisse zuerst ausgeben
			foreach($this->list_dirs as $dir){
				echo "<tr><td class=\"icon\"><span class=\"".$dir['type']."\"></span></td><td><a href=\"?dir=".$dir['url']."\"><span class=\"dirname\">".$dir['title']."</span></a></td><td></td><td></td><td></td></tr>\n";
			}
			
			//danach Dateien
			foreach($this->list_files as $file){
				if(!$file['title']){
					$file['title'] = "<span class=\"notitle\">index</span></span>";
				}
				$trclass = "";
				if($file['info']['versionActive'] != 1){
					$trclass = "inactive";
				}
				echo "<tr class=\"$trclass\"><td class=\"icon\"><span class=\"".$file['info']['type']." file_".$file['info']['filetype']."\"></span></td><td><a href=\"?file=".$file['info']['contentKey']."&version=".$file['info']['versionNumber']."\" title=\"".$file['info']['contentTitle']."\"><span class=\"filename\">".$file['title']."</span></a></td><td>".$file['info']['versionLastChanged']."</td><td class=\"version\">".$file['info']['versionNumber']."</td><td>".$file['info']['versionNote']."</td></tr>\n";
			}

			echo "</table>\n";
			echo "</div>\n";
		}
		
	}
	
?>