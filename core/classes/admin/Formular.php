<?php

	/************************************************************
	Hauptklasse zur Ausgabe von Formularen (für den Adminbereich
	Version 0.1
	Copyright by Julian Burr - 03.08.2012
	************************************************************/

	class Formular {
		
		private $form_object = array();
		private $form_id;
		
		public function __construct($array){
			if(!is_array($array)){
				return;
			}
			$this->form_object = $array;
		}
		
		public function printFormStart($id,$action,$method){
			$this->form_id = $id;
			$enctype = "";
			if($method == "post"){
				$enctype = "enctype=\"multipart/form-data\"";
			}
			echo "<div class=\"wrap_form wrap_form_$id\">\n<form id=\"$id\" name=\"$id\" action=\"$action\" method=\"$method\" $enctype>\n";
		}
		
		public function printFormEnd(){
			echo "</form>\n</div>\n";
		}
		
		public function printInputHidden($name,$value=""){
			if(!$value){
				$value = $this->form_object[$name];
			}
			echo "<input type=\"hidden\" class=\"hidden\" name=\"$name\" value=\"$value\">\n";
		}
		
		public function printInputText($name,$label,$value="",$class="",$disabled="",$style=""){
			if(!$value){
				$value = $this->form_object[$name];
			}
			echo "\n<div class=\"wrap_input\">\n<div class=\"label\">$label</div>\n<div class=\"input\"><input type=\"text\" class=\"text $class\" name=\"$name\" value=\"$value\" style=\"$style\" $disabled>\n</div>\n</div>\n";
		}
		
		public function printInputTextarea($name,$label,$value="",$class="",$disabled="",$style=""){
			if(!$value){
				$value = $this->form_object[$name];
			}
			echo "\n<div class=\"wrap_input\">\n<div class=\"label\">$label</div>\n<div class=\"input textarea\"><textarea class=\"text $class\" name=\"$name\" style=\"$style\" $disabled>$value</textarea>\n</div>\n</div>\n";
		}
		
		public function printSubmit($name,$value,$class="",$disabled="",$style=""){
			echo "\n<div class=\"input submit $class\">\n<input type=\"submit\" class=\"submit $class\" name=\"".$this->form_id."_$name\" style=\"$style\" value=\"$value\" $disabled>\n</div>\n";
		}
		
	}
	
?>