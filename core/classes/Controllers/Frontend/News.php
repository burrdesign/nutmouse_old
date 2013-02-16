<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-14
 *
 * @Beschreibung:
 *		News-Content-Controller im MVC-Framework. Hier wird anhand der übergebenen Parameter
 *		das entsprechende Model geladen und die Seite erzeugt und zur Ausgabe an die
 *		Hauptklasse übergeben
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Models/Frontend/News.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/View.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller.php');

class Controllers_Frontend_News extends Controller {

	public function __construct($get,$post){
		parent::__construct($get,$post);
	}

	//Ausgabe generieren und zurückgeben
	public function display(){
		$view = new View();
	
		//Neuigkeit laden
		$entry = Cache::loadCache("news:" . $this->request['nkey'], 60 * 24 * 7);		
		if(!$entry && isset($this->request['nkey'])) $entry = Models_Frontend_News::getNewsByKey($this->request['nkey']);
		
		if($entry['newsKey']){
			//im Cache speichern
			Cache::saveCache("news:" . $this->request['nkey'], $entry);
		
			//inneres Template
			$inner_template = 'page/news/detail';
			if(!empty($entry['newsTemplate'])){
				$inner_template = $entry['newsTemplate'];
			}
			$view->setTemplate($inner_template);
			$view->assign('newsData', $entry);
			
			//äußeres Template
			$this->view->setTemplate('index');
			$this->view->assign('title', $entry['newsTitle']);
			$this->view->assign('page_content', $view->loadTemplate());
		} else {
			//keinen Content mit diesem Pfad gefunden => 404-Fehler
			header('HTTP/1.0 404 Not Found');
			$view->setTemplate('page/error/error404');
			$view->assign('content', "404-Fehler");
			
			//äußeres Template
			$this->view->setTemplate('index');
			$this->view->assign('title', "Neuigkeit nicht gefunden");
			$this->view->assign('page_content', $view->loadTemplate());
		}

		return $this->view->loadTemplate();
	}
}