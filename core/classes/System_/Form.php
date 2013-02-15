<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-01
 *
 * @Beschreibung:
 *		Hilfs-Klasse zur Ausgabe und aufbereitung von Formularen
 *		im Admin-Bereich
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/FormElement.php');

class Form {

	public $element;
	public $row;
	private $mandatory = array();
	
	public function __construct(){
		$this->element = new FormElement();
		$this->row = new FormElementRow();
	}
	
	public function addMandatory($name,$type,$pattern=""){
		$this->mandatory[$name] = array('type' => $type, 'pattern' => $pattern);
	}

	public function start($action, $method, $enctype="", $name=""){
		echo "<form name=\"{$name}\" action=\"{$action}\" method=\"{$method}\" enctype=\"{$enctype}\">\n";
		$this->element->printMandatory($this->mandatory);
	}
	
	public function end(){
		echo "</form>\n";
	}

}