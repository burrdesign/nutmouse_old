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
 *		aufrufen und dessen Rückgabe ausgeben
 */

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Log.php');

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller/Frontend/Index.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller/Frontend/News.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller/Admin/Index.php');

class BurrDesignCMS {

	private $controller;

	public function __construct(){
		echo $this->display();
	}
	
	//Ausgabe generieren und zurückgeben
	public function display(){
		switch($_REQUEST['view']){
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
				$output =  "<pre>VIEW=" . $this->template . "</pre>";
				break;
		}
		
		$output = $this->controller->display();
		return $output;
	}
	
}