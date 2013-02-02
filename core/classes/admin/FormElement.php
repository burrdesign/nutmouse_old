<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-01
 *
 * @Beschreibung:
 *		Hilfs-Klasse zur Ausgabe und aufbereitung von Formular-Elementen
 *		im Admin-Bereich
 */
 
class FormElement {

	private $mandatory = array();
	private $mandatory_sign = '*';

	private function printRowStart($label, $name, $type=""){
		$sign = "";
		$class = "";
		if(is_array($this->mandatory[$name])){
			$sign = $this->mandatory_sign;
			$class = "mandatory";
		}
		echo "
			<div class=\"input_row {$class}\">\n
			\t<div class=\"input_label\">\n
			\t\t<label for=\"test_text\">{$label}{$sign}:</label>\n
			\t</div>\n
			\t<div class=\"input_field\">\n
			";
	}
	
	private function printRowEnd(){
		echo "
			\t</div>\n
			</div>\n
			";
	}
	
	public function printMandatory($mandatory){
		$this->mandatory = $mandatory;
		//Pflichtfelder als Hidden-Felder übergeben
		foreach($mandatory as $field => $info){
			echo "\t\t<input type=\"hidden\" name=\"mandatory_{$field}\" value=\"{$info['type']}\">\n";
			if($info['pattern']){
				echo "\t\t<input type=\"hidden\" name=\"mandatory_{$field}_pattern\" value=\"{$info['pattern']}\">\n";
			}
		}
	}
	
	public function printHidden($inputname, $inputvalue, $show=false, $label=""){
		echo "\t\t<input name=\"{$inputname}\" type=\"hidden\" value=\"{$inputvalue}\">\n";
		if($show){
			$this->printRowStart($label,$inputname,"info");
			echo "\t\t<span class=\"info\">{$inputvalue}</span>\n";
			$this->printRowEnd();
		}
	}

	public function printTextfield($label, $inputname, $inputvalue, $inputclass="", $inputstyle=""){
		$this->printRowStart($label,$inputname,"text");
		echo "\t\t<input name=\"{$inputname}\" type=\"text\" class=\"text {$inputclass}\" value=\"{$inputvalue}\" id=\"{$inputname}\" style=\"{$inputstyle}\">\n";
		$this->printRowEnd();
	}
	
	public function printSubmit($label, $inputname="", $inputclass="", $inputstyle=""){
		echo "
			<div class=\"input_row\">\n
			\t<div class=\"input_submit\">\n
			\t\t<input name=\"{$inputname}\" type=\"submit\" class=\"submit {$inputclass}\" value=\"{$label}\" style=\"{$inputstyle}\">\n
			\t</div>\n
			</div>\n
			";
	}
		
	
}