<?php

	/************************************************************
	Hauptklasse zur Ausgabe von Formularen (für den Adminbereich
	Version 0.1
	Copyright by Julian Burr - 06.10.2012
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
			if(!$value) $value = $this->form_object[$name];
			echo "<input type=\"hidden\" class=\"hidden\" name=\"$name\" value=\"$value\">\n";
		}
		
		public function printInputText($name,$label,$value="",$class="",$disabled="",$style=""){
			if(!$value) $value = $this->form_object[$name];
			echo "\n<div class=\"wrap_input\">\n<div class=\"label\">$label</div>\n<div class=\"input\"><input type=\"text\" class=\"text $class\" name=\"$name\" value=\"$value\" style=\"$style\" $disabled>\n</div>\n</div>\n";
		}
		
		public function printInputTextarea($name,$label,$value="",$class="",$disabled="",$style=""){
			if(!$value) $value = $this->form_object[$name];
			echo "\n<div class=\"wrap_input\">\n<div class=\"label\">$label</div>\n<div class=\"input textarea\"><textarea class=\"text $class\" name=\"$name\" style=\"$style\" $disabled>$value</textarea>\n</div>\n</div>\n";
		}
		
		public function printSelectFromQuery($name,$label,$value="",$query,$class="",$disabled="",$style=""){
			if(!$value) $value = $this->form_object[$name];
			echo "\n<div class=\"wrap_input\">\n<div class=\"label\">$label</div>\n<div class=\"input select\"><select class=\"text $class\" name=\"$name\" style=\"$style\" $disabled>";
			$sql = new SQLManager();
			$sql->setQuery($query);
			$result = $sql->execute();
			while($opt = mysql_fetch_array($result)){
				$selected = "";
				if($value == $opt[$name]){
					$selected = "selected=\"selected\"";
				}
				echo "\n<option value=\"".$opt[$name]."\" $selected>".$opt[$name]."</option>";
			}
			echo "</select>\n</div>\n</div>\n";
		}
		
		public function printInputURL($name,$label,$value="",$class="",$disabled="",$style="",$mainurl=""){
			if(!$value) $value = $this->form_object[$name];
			if(!$mainurl) $mainurl = $_SESSION['BURRDESIGN']['CONFIG']['HOST']."/";			
			echo "\n<div class=\"wrap_input\">\n<div class=\"label\">$label</div>\n<div class=\"input input_url\"><span class=\"mainurl\">$mainurl</span><input type=\"text\" class=\"text $class\" name=\"$name\" value=\"$value\" style=\"$style\" $disabled><a class=\"hyperlink\" href=\"http://".$mainurl.$value."\" target=\"_blank\" title=\"Seite in neuen Fenster &ouml;ffnen\">&nbsp;</a>\n</div>\n</div>\n";
		}
		
		public function printInputSourceCode($name,$label,$value="",$class="",$disabled="",$style="",$content=""){
			//Content-Quelltext (im ACE-Editor) ggf. inkl. Contentinfos ausgeben
			if(!$value) $value = $this->form_object[$name];
			$value = str_replace("<","&lt;",$value);
			$value = str_replace(">","&gt;",$value);
			echo "\n<div class=\"wrap_input wrap_soucecode\" style=\"$style\">\n<div class=\"label\">$label</div>\n";
			if(is_object($content)){
				$content->printContentSourceInfo();
			}
			echo "<input type=\"hidden\" value=\"\" id=\"sourcecode_hidden_$name\" name=\"$name\">\n<div id=\"editor_$name\" class=\"input sourcecode\">$value</div>\n</div>\n";
			echo "<script type=\"text/javascript\">\nvar editor = ace.edit('editor_$name'); \neditor.getSession().setMode('ace/mode/html'); \n\$('form#".$this->form_id."').submit(function(){ \n\$('#sourcecode_hidden_$name').attr('value',editor.getValue()); \n});\n</script>";
		}
		
		public function printSubmit($name,$value,$class="",$disabled="",$style=""){
			echo "\n<div class=\"input submit $class\">\n<input type=\"submit\" class=\"submit $class\" name=\"".$this->form_id."_$name\" style=\"$style\" value=\"$value\" $disabled>\n</div>\n";
		}
		
	}
	
?>