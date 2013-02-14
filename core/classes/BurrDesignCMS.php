<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 *
 * @Beschreibung:
 *		Hauptklasse für die Initialisierung und Ausgabe des Content Management Systems,
 *		sowohl Front- als auch Backend. Im Grunde soll diese Klasse nur den Controller
 *		richtigen aufrufen und dessen Rückgabe ausgeben.
 *		Außerdem werden hier die statischen Hilfsklassen eingebunden, die überall zur
 *		Verfügung stehen müssen.
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller/Frontend/Index.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller/Frontend/News.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller/Admin/Index.php');

//statische Hilfs-Klassen einbinden
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Lib.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Log.php');

class BurrDesignCMS {

	private $view;
	private $controller;

	public function __construct(){
		$this->view = $_REQUEST['view'];
		echo $this->display();
	}
	
	//Ausgabe generieren und zurückgeben
	public function display(){
		switch($this->view){
			case 'content': 
				//Normaler Inhalt
				$this->controller = new Controller_Frontend_Index($_GET,$_POST);
				break;
			
			case 'news':
				//Neuigkeit im Frontend
				$this->controller = new Controller_Frontend_News($_GET,$_POST);
				break;
				
			case 'admin':
				//Adminseite
				$this->controller = new Controller_Admin_Index($_GET,$_POST);
				break;
				
			case 'default':
			default:
				$output =  "<pre>VIEW=" . $this->view . "</pre>";
				break;
		}
		
		if(is_object($this->controller)) $output = $this->controller->display();
		return $output;
	}
	
}