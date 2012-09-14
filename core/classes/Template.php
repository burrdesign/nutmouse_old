<?php

	/***********************************************
	Hauptklasse des BurrDesign Template-Verwaltung
	Version 0.1
	Copyright by Julian Burr - 30.07.2012
	***********************************************/
	
	class Template {
		
		private $tpl_path;
		private $tpl_output;
		
		public function __construct($tpl){
			//Template laden
			$this->tpl_path = $this->loadTemplate($tpl);
			if(!$this->tpl_path){
				return;
			}
		}
		
		public function loadTemplate($tpl){
			$return_path = "";
			
			//Standardverzeichnis für die Templates laden
			$std_dir =  $_SERVER['DOCUMENT_ROOT']."/templates/standard/";
			if($_SESSION['BURRDESIGN']['CONFIG']['LayoutClass']){
				//Layoutspez. Templateverzeichnis laden
				$cst_dir = $_SERVER['DOCUMENT_ROOT']."templates/".$_SESSION['BURRDESIGN']['CONFIG']['LayoutClass']."/";
			}
			
			if($cst_dir){
				if(is_file($cst_dir.$tpl)){
					//Prüfen ob Layoutspez. Überladung des Templates vorhanden ist
					$return_path = $cst_dir.$tpl;
				} elseif(is_file($std_dir.$tpl)){
					//Sonst Standard laden
					$return_path = $std_dir.$tpl;
				}
			} else {
				if(is_file($std_dir.$tpl)){
					//Kein Layout definiert, also immer Standard-Template laden
					$return_path = $std_dir.$tpl;
				}
			}
			
			if(!$return_path){
				if(is_file($std_dir."index.tpl")){
					$return_path = $std_dir."index.tpl";
				}
			}
			
			return $return_path;
		}
		
		public function parseTemplateContent($content){
			$output = "";
			
			//Template laden
			$output = file_get_contents($this->tpl_path);
			$output = str_replace("{{main_content}}",$content,$output);
			
			//und parsen
			$this->tpl_output = $this->parseContent($output);
		}
		
		public function parseContent($content){
			//Include-Funktionen für Module
			while(preg_match("/\{{mod:(.*?)\}}/",$content,$matches)){
				$mod_path = $_SERVER['DOCUMENT_ROOT']."core/system/modules/".$matches[1];
				$text = "";
				if(is_file($mod_path)){
					$text = get_include($mod_path);
				} else {
					$text = "{{module not found:$mod_path}}";
				}
				$content = str_replace($matches[0],$text,$content);
			}
			
			//Include-Funktionen für Templates (Inception-Templates: ein Template in einem Template in einem Template ...
			while(preg_match("/\{{tpl:(.*?)\}}/",$content,$matches)){
				$tpl_path = $_SERVER['DOCUMENT_ROOT']."templates/standard/".$matches[1];
				$text = "";
				if(is_file($tpl_path)){
					$text = $this->parseContent(file_get_contents($tpl_path));
				}else {
					$text = "{{template not found:$tpl_path}}";
				}
				$content = str_replace($matches[0],$text,$content);
			}
			
			//Weitere Parse-Funktionen...
			
			return $content;
		}
		
		public function printTemplateContent(){
			echo $this->tpl_output;
		}
		
	}
	
?>