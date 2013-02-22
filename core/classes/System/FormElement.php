<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-01
 *
 * @Beschreibung:
 *		Hilfs-Klasse zur Ausgabe und Aufbereitung von Formular-Elementen
 *		im Admin-Bereich
 */
 
class FormElement {

	private $mandatory = array();
	
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
	
	public function printHidden($inputname, $inputvalue, $show=false){
		echo "\t\t<input name=\"{$inputname}\" type=\"hidden\" value=\"{$inputvalue}\">\n";
	}
	
	public function printHiddenInfo($inputvalue){
		echo "\t\t<span class=\"info\">{$inputvalue}</span>\n";
	}

	public function printTextfield($inputname, $inputvalue, $inputclass="", $inputstyle="", $pretext="", $posttext=""){
		echo "\t\t{$pretext}<input name=\"{$inputname}\" type=\"text\" class=\"text {$inputclass}\" value=\"{$inputvalue}\" id=\"{$inputname}\" style=\"{$inputstyle}\">{$posttext}\n";
	}
	
	public function printTextarea($inputname, $inputvalue, $inputclass="", $inputstyle="", $pretext="", $posttext=""){
		echo "\t\t{$pretext}<textarea name=\"{$inputname}\" class=\"text {$inputclass}\" id=\"{$inputname}\" style=\"{$inputstyle}\">{$inputvalue}</textarea>{$posttext}\n";
	}
	
	public function printUpload($inputname, $inputvalue, $inputclass="", $inputstyle="", $pretext="", $posttext="", $multiple=0){
		$multipletag = "";
		if($multiple == 1){
			$multipletag = "multiple=\"multiple\"";
		}
		echo "\t\t{$pretext}<input name=\"{$inputname}\" type=\"file\" class=\"file {$inputclass}\" id=\"{$inputname}\" style=\"{$inputstyle}\" {$multipletag}>{$posttext}\n";
	}
	
	public function printSelect($inputname, $inputvalue, $inputoptions, $inputoptionlabels=array(), $inputclass="", $inputstyle="", $pretext="", $posttext=""){
		if(!is_array($inputoptions)){
			return;
		}
		echo "\t\t{$pretext}\n\t\t<select name=\"{$inputname}\" class=\"select {$inputclass}\" id=\"{$inputname}\" style=\"{$inputstyle}\">\n";
		foreach($inputoptions as $option){
			$selected = "";
			if($option == $inputvalue){
				$selected = "selected=\"selected\"";
			}
			$value = $option;
			if(!empty($inputoptionlabels[$option])){
				$value = $inputoptionlabels[$option];
			}
			echo "\t\t\t<option value=\"{$option}\" {$selected}>{$value}</option>\n";
		}
		echo "\t\t</select>\n\t\t{$posttext}";
	}
	
	public function printSelectFromQuery($inputname, $inputvalue, $query, $optionsfield, $labelfield, $emptyfield=1, $emptyvalue="&nbsp;", $inputclass="", $inputstyle="", $pretext="", $posttext=""){
		$inputoptions = array();
		$inputoptionlabels = array();
		if($emptyfield == 1){
			$inputoptions[] = "";
			$inputoptionlabels[""] = $emptyvalue;
		}
		while($option = mysql_fetch_array($query)){
			$inputoptions[] = $option[$optionsfield];
			$inputoptionlabels[$option[$optionsfield]] = $option[$labelfield];
		}
		$this->printSelect($inputname, $inputvalue, $inputoptions, $inputoptionlabels, $inputclass, $inputstyle, $pretext, $posttext);
	}
	
	public function printEnable($inputname, $inputvalue, $truevalue=1, $falsevalue=0, $inputclass="", $inputstyle="", $pretext="", $posttext=""){
		$checked = "";
		if($inputvalue == $truevalue){
			$checked = "checked=\"checked\"";
		}
		echo "\t\t<input name=\"{$inputname}\" type=\"hidden\" value=\"{$falsevalue}\">\n";
		echo "\t\t{$pretext}\n\t\t<input name=\"{$inputname}\" type=\"checkbox\" class=\"checkbox {$inputclass}\" value=\"{$truevalue}\" style=\"{$inputstyle}\" {$checked}>\t\t{$posttext}\n";
	}
	
	public function printSubmit($label, $inputname="", $inputclass="", $inputstyle=""){
		echo "\t\t<input name=\"{$inputname}\" type=\"submit\" class=\"submit {$inputclass}\" value=\"{$label}\" style=\"{$inputstyle}\">\n";
	}
	
	public function printSubmitLink($label, $href, $target="", $class="", $style=""){
		if($target){
			$target = "target=\"{$target}\"";
		}
		echo "\t\t<a href=\"{$href}\" {$target} class=\"submit {$class}\" style=\"{$style}\">{$label}</a>\n";
	}
	
}


/*
 * Wrapper-Klasse
 */
class FormElementRow {

	private $mandatory = array();
	private $mandatory_sign = '*';
	
	private $core;
	
	public function __construct(){
		$this->core = new FormElement;
	}

	public function start($label="", $name="", $type="default"){
		$class = $type;
		if(is_array($this->mandatory[$name])){
			$class .= " mandatory";
		}
		echo "<div class=\"input_row {$class}\">\n";
		if($label){
			$this->printLabel($label, $name);
		}
		echo "\t<div class=\"input_field input_field_{$type}\">\n";
	}
	
	public function end(){
		echo "
			\t</div>\n
			</div>\n
			";
	}
	
	public function printLabel($label, $name){
		$sign = "";
		if(is_array($this->mandatory[$name])){
			$sign = $this->mandatory_sign;
		}
		echo "\t<div class=\"input_label\">\n
			\t\t<label for=\"test_text\">{$label}{$sign}:</label>\n
			\t</div>\n";
	}
	
	public function printHidden($inputname, $inputvalue, $show=false, $label=""){
		$this->core->printHidden($inputname, $inputvalue, $show);
		if($show){
			$this->start($label,$inputname,"info");
			$this->core->printHiddenInfo($inputvalue);
			$this->end();
		}
	}
	
	public function printInfo($label, $value){
		$this->start($label,"","info");
		$this->core->printHiddenInfo($value);
		$this->end();
	}

	public function printTextfield($label, $inputname, $inputvalue, $inputclass="", $inputstyle="", $pretext="", $posttext=""){
		$this->start($label,$inputname,"text");
		$this->core->printTextfield($inputname, $inputvalue, $inputclass, $inputstyle, $pretext, $posttext);
		$this->end();
	}
	
	public function printTextarea($label, $inputname, $inputvalue, $inputclass="", $inputstyle="", $pretext="", $posttext=""){
		$this->start($label,$inputname,"textarea");
		$this->core->printTextarea($inputname, $inputvalue, $inputclass, $inputstyle, $pretext, $posttext);
		$this->end();
	}
	
	public function printUpload($label, $inputname, $inputvalue, $inputclass="", $inputstyle="", $pretext="", $posttext="", $multiple=0){
		$this->start($label,$inputname,"text");
		$this->core->printUpload($inputname, $inputvalue, $inputclass, $inputstyle, $pretext, $posttext, $multiple);
		$this->end();
	}
	
	public function printSelect($label, $inputname, $inputvalue, $inputoptions, $inputoptionlabels=array(), $inputclass="", $inputstyle="", $pretext="", $posttext=""){
		$this->start($label,$inputname,"select");
		$this->core->printSelect($inputname, $inputvalue, $inputoptions, $inputoptionlabels, $inputclass, $inputstyle, $pretext, $posttext);
		$this->end();
	}
	
	public function printSelectFromQuery($label, $inputname, $inputvalue, $query, $optionsfield, $labelfield, $emptyfield=1, $emptyvalue="&nbsp;", $inputclass="", $inputstyle="", $pretext="", $posttext=""){
		$this->start($label,$inputname,"select");
		$this->core->printSelectFromQuery($inputname, $inputvalue, $query, $optionsfield, $labelfield, $emptyfield, $emptyvalue, $inputclass, $inputstyle, $pretext, $posttext);
		$this->end();
	}
	
	public function printEnable($label, $inputname, $inputvalue, $truevalue=1, $falsevalue=0, $inputclass="", $inputstyle="", $pretext="", $posttext=""){
		$this->start($label,$inputname,"enable checkbox");
		$this->core->printEnable($inputname, $inputvalue, $truevalue, $falsevalue, $inputclass, $inputstyle, $pretext, $posttext);
		$this->end();
	}
	
	public function printSubmit($label, $inputname="", $inputclass="", $inputstyle=""){
		$this->start("","","submit");
		$this->core->printSubmit($label, $inputname, $inputclass, $inputstyle);
		$this->end();
	}
	
}