<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 *
 * @Beschreibung:
 *		Content-Controller im MVC-Framework. Hier wird anhand der übergebenen Parameter
 *		das entsprechende Model geladen und die Seite erzeugt und zur Ausgabe an die
 *		Hauptklasse übergeben
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Models/Frontend/Index.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/View.php');

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Cache.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Session.php');

class Controller_Frontend_News {

	private $request = array();
	private $get = array();
	private $post = array();
	private $template = '';
	private $view = null;

	public function __construct($get,$post){
		//Reqeust-Arrays speichern
		$this->get = $get;
		$this->post = $post;
		$this->request = array_merge($get, $post);
	
		//Session laden und ggf. initialisieren
		$this->session = new Session($get,$post);
		$this->session->getSession();
	
		//Äußerer View
		$this->view = new View();
		
		$this->template = 'default';
		if(!empty($this->request['view'])){
			$this->template = $this->request['view'];
		}
	}

	//Ausgabe generieren und zurückgeben
	public function display(){
		$view = new View();
		
		//versuchen aus dem Cache zu laden (TTL = 1 Woche)
		$entry = Cache::loadCache("content:" . $this->request['path'], 60 * 24 * 7);
	
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