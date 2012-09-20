<?php

	/********************************************************
	Hauptklasse zum Ausgeben von Dateilisten im Adminbereich
	Version 0.1
	Copyright by Julian Burr - 02.08.2012
	********************************************************/

	class FileList {
		
		private $list_id;
		private $list_type;
		private $list_dirs = array();
		private $list_files = array();
		private $list_settings = array();
		
		public function __construct($id,$type=""){
			$this->list_id = $id;
			$this->list_type = $type;
			$this->list_settings = $_SESSION['BURRDESIGN']['ADMIN']['settings'][$id];
		}
		
		public function addDir($name,$href=""){
			$url = $this->list_settings['maindir'].$name."/";
			$this->list_dirs[$name."_dir"]['title'] = $name."/";
			$this->list_dirs[$name."_dir"]['url'] = $url;
			$this->list_dirs[$name."_dir"]['type'] = "dir";
			
		}
		
		public function addFile($title,$url,$key,$zusatz=""){
			$this->list_files[$title."_file"]['key'] = $key;
			$this->list_files[$title."_file"]['title'] = $title;
			$this->list_files[$title."_file"]['url'] = $url;
			$this->list_files[$title."_file"]['url_abs'] = $_SESSION['BURRDESIGN']['CONFIG']['HOST']."/".$url;
			$this->list_files[$title."_file"]['zusatz'] = $zusatz;
			$this->list_files[$title."_file"]['type'] = "file";
			$filetype = split("\.",$url);
			$this->list_files[$title."_file"]['filetype'] = $filetype[count($filetype) - 1];
		}
		
		public function printListNav($elements){
			if(!is_array($elements)){
				//Fehlerhafter Parameter $elements
				return;
			}
			
			echo "<div class=\"wrap_filelist_settings\">\n";
			
			if(in_array("urlpath",$elements) == true || in_array("all",$elements)){
				//aktuellen URL-Grundpfad ausgeben
				echo "<div class=\"setting_url setting\"><span class=\"label\">URL-PFAD:</span>";
				echo "<a href=\"?dir=\">".$_SESSION['BURRDESIGN']['CONFIG']['HOST']."/</a>";
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
			echo "<div class=\"wrap_filelist\">\n";
			if($this->list_settings['mixdirs'] == 1){
				$all = array_merge($this->list_dirs,$this->list_files);
				//TODO: Sortierung!
				foreach($all as $output){
					if($output['type'] == "dir"){
						echo "<a class=\"dir\" href=\"?dir=".$output['url']."\"><span class=\"dirname\">".$output['title']."</span><span class=\"zusatz\">".$output['zusatz']."</span></a>\n";
					} elseif($output['type'] == "file"){
						echo "<a class=\"file file_".$output['filetype']."\" href=\"?file=".$output['key']."\" title=\"".$output['url']."\"><span class=\"filename\">".$output['title']."</span><span class=\"zusatz\">".$output['zusatz']."</span></a>\n";
					}
				}
			} else {
				//TODO: Sortierung!
				
				//Verzeichnisse zuerst ausgeben
				foreach($this->list_dirs as $dir){
					echo "<a class=\"dir\" href=\"?dir=".$dir['url']."\"><span class=\"dirname\">".$dir['title']."</span><span class=\"zusatz\">".$dir['zusatz']."</span></a>\n";
				}
				
				//danach Dateien
				foreach($this->list_files as $file){
					if(!$file['title']){
						$file['title'] = "<span class=\"notitle\">unbekannt</span>";
					}
					echo "<a class=\"file file_".$file['filetype']."\" href=\"?file=".$file['key']."\" title=\"".$file['url']."\"><span class=\"filename\">".$file['title']."</span><span class=\"zusatz\">".$file['zusatz']."</span></a>\n";
				}
			}
			echo "</div>\n";
		}
		
	}
	
?>