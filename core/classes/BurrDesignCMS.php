<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 *
 * @Beschreibung:
 *		Hauptklasse f�r die Initialisierung und Ausgabe des Content Management Systems,
 *		sowohl Front- als auch Backend. Im Grunde soll diese Klasse nur den Controller
 *		aufrufen und dessen R�ckgabe ausgeben
 */

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller.php');

class BurrDesignCMS {

	private $controller;
	private $session;

	public function __construct(){
		$this->controller = new Controller($_GET,$_POST);
		echo $this->controller->display();
	}
	
}