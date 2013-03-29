<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-23
 *
 * @Beschreibung:
 *		Galierie-Content-Controller im MVC-Framework. Hier wird anhand der übergebenen Parameter
 *		das entsprechende Model geladen und die Seite erzeugt und zur Ausgabe an die
 *		Hauptklasse übergeben
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Models/Frontend/Galery.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/View.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller.php');

class Controllers_Frontend_Galery extends Controller {

	public function __construct($get,$post){
		parent::__construct($get,$post);
	}

	//Ausgabe generieren und zurückgeben
	public function display(){
		$view = new View();
		
		Event::trigger('Controller_Frontend_Galery_PreDispatch');
	
		//Neuigkeit laden
		$entry = Cache::loadCache("galery:" . $this->request['gkey'], 60 * 24 * 7);		
		if(!$entry && isset($this->request['gkey'])) $entry = Models_Frontend_Galery::getGaleryByKey($this->request['gkey']);
		
		if($entry['galeryKey'] && $entry['galeryActive'] == 1){
			//im Cache speichern
			Cache::saveCache("galery:" . $this->request['gkey'], $entry);
		
			//Datenhook
			$custom_head = Event::trigger('Controller_Frontend_Galery_CustomHead');
			$custom_footer = Event::trigger('Controller_Frontend_Galery_CustomFooter');
		
			//inneres Template
			$inner_template = 'page/galery/detail';
			if(!empty($entry['galeryTemplate'])){
				$inner_template = $entry['galeryTemplate'];
			}
			$view->setTemplate($inner_template);
			$view->assign('galeryData', $entry);
			
			//äußeres Template
			$this->view->setTemplate('index');
			$this->view->assign('title', $entry['galeryTitle']);
			if(Config::get("maintitle")){
				$this->view->assign('title', $entry['galeryTitle'] . " - " . Config::get("maintitle"));
			}
			$this->view->assign('canonical', $_SERVER['SERVER_NAME'] . Lib::getCanonicalUrl("galery",$entry['galeryKey'],$entry['galeryTitle']));
			$this->view->assign('custom_head', $custom_head);
			$this->view->assign('custom_footer', $custom_footer);
			$this->view->assign('page_content', $view->loadTemplate());
		} else {
			//keinen Content mit diesem Pfad gefunden => 404-Fehler
			header('HTTP/1.0 404 Not Found');
			$view->setTemplate('page/error/error404');
			$view->assign('content', "404-Fehler");
			
			//äußeres Template
			$this->view->setTemplate('index');
			$this->view->assign('title', "Galerie nicht gefunden");
			if(Config::get("maintitle")){
				$this->view->assign('title', "Galerie nicht gefunden - " . Config::get("maintitle"));
			}
			$this->view->assign('page_content', $view->loadTemplate());
		}
		
		Event::trigger('Controller_Frontend_Galery_PostDispatch');

		return $this->view->loadTemplate();
	}
}