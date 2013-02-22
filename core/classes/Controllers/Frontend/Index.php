<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-14
 *
 * @Beschreibung:
 *		Content-Controller im MVC-Framework. Hier wird anhand der übergebenen Parameter
 *		das entsprechende Model geladen und die Seite erzeugt und zur Ausgabe an die
 *		Hauptklasse übergeben
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Models/Frontend/Index.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller.php');

class Controllers_Frontend_Index extends Controller {

	public function __construct($get,$post){
		parent::__construct($get,$post);
	}

	//Ausgabe generieren und zurückgeben
	public function display(){
		$view = new View();
		
		//versuchen aus dem Cache zu laden (TTL = 1 Woche)
		if(isset($this->request['path'])) $entry = Cache::loadCache("content:" . $this->request['path'], 60 * 24 * 7);
		
		//Inhalt laden
		if(!$entry && isset($this->request['path'])) $entry = Models_Frontend_Index::getContentByPath($this->request['path']);
		if(!$entry && isset($this->request['ckey'])) $entry = Models_Frontend_Index::getContentByKey($this->request['ckey']);
		
		if(is_array($entry)){
			//im Cache speichern
			Cache::saveCache("content:" . $this->request['path'], $entry);
		
			//inneres Template
			$inner_template = 'page/default';
			if(!empty($entry['versionTemplate'])){
				$inner_template = $entry['versionTemplate'];
			}
			$view->setTemplate($inner_template);
			$view->assign('content', $entry['versionText']);
			
			//äußeres Template
			$this->view->setTemplate('index');
			$this->view->assign('title', $entry['contentTitle']);
			$this->view->assign('page_content', $view->loadTemplate());
		} else {
			//keinen Content mit diesem Pfad gefunden => 404-Fehler
			$view->header("HTTP/1.0 404 Not Found");
			$view->setTemplate("page/error/error404");
			$view->assign('content', "404-Fehler");
			
			//äußeres Template
			$this->view->setTemplate('index');
			$this->view->assign('title', "Seite nicht gefunden");
			$this->view->assign('page_content', $view->loadTemplate());
		}

		return $this->view->loadTemplate();
	}
	
}