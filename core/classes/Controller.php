<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 *
 * @Beschreibung:
 *		Controller im MVC-Framework. Hier wird anhand des übergebenen View-Parameters
 *		das entsprechende Model geladen und die Seite erzeugt und zur Ausgabe an die
 *		Hauptklasse übergeben
 */

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Model.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/View.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Cache.php');

class Controller {

	private $request = null;
	private $get = null;
	private $post = null;
	private $template = '';
	private $view = null;

	/**
	 * @param: get	GET-Request-Parameter
	 * @param: post	POST-Request-Parameter
	 */
	public function __construct($get,$post){
		//Äußerer View
		$this->view = new View();
		$this->get = $get;
		$this->post = $post;
		$this->request = array_merge($get, $post);
		
		if(!empty($this->request['view'])){
			$this->template = $this->request['view'];
		} else {
			$this->template = 'default';
		}
	}

	/**
	 * @Beschreibung: Ausgabe generieren und zurückgeben
	 */
	public function display(){
		$view = new View();
		switch($this->template){
			case 'content':
			
				//versuchen aus dem Cache zu laden (TTL = 1 Woche)
				$entry = Cache::loadCache("content:" . $this->request['path'], 60 * 24 * 7);
				if(is_array($entry)){
					echo "<pre>WURDE AUS DEM CACHE GELADEN</pre>";
				}
			
				//Inhalt laden
				if(!$entry && isset($this->request['path'])) $entry = Model::getContentByPath($this->request['path']);
				if(!$entry && isset($this->request['ckey'])) $entry = Model::getContentByKey($this->request['ckey']);
				
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
				
				break;
				
			case 'admin':
			
				//Admin-Modul laden
				if(isset($this->request['path'])) $entry = Model::getAdminContentByPath($this->request['path']);
				
				if(is_array($entry)){
					//Haupttemplate vorbereiten
					$template = $entry['moduleTemplate'];
					if(!is_file($_SERVER['DOCUMENT_ROOT'] . '/core/templates/' . $template . '.tpl')){
						$template = 'admin/index';
					}
					
					//inneres Template vorbereiten
					$inner_template = 'admin/modules/' . $entry['moduleCoreFile'];
					if(!is_file($_SERVER['DOCUMENT_ROOT'] . '/core/templates/' . $inner_template . '.tpl')){
						$template = 'admin/error/error404';
					}
					
					//Menüs ermitteln und vorbereiten
					if($entry['menuParent'] > 0){
						$mainmenu = $entry['menuParent'];
						$submenu = $entry['menuKey'];
					} else {
						$mainmenu = $entry['menuKey'];
						$submenu = "";
					}
					
					//inneres Modul-Template
					$view->setTemplate($inner_template);
					$view->assign('request', $this->request);
					$view->assign('post', $this->request);
					$view->assign('get', $this->request);
					
					//äußeres Rahmen-Template
					$this->view->setTemplate($template);
					$this->view->assign('mainmenu', $mainmenu);
					$this->view->assign('submenu', $submenu);
					$this->view->assign('admin_content', $view->loadTemplate());
				} else {
					//kein Admin-Modul mit dem angegeben Pfad gefunden => 404-Fehler
					$template = 'admin/index';
					
					//inneres Template vorbereiten
					$inner_template = 'admin/error/error404';
					
					//inneres Modul-Template
					$view->setTemplate($inner_template);
					
					//äußeres Rahmen-Template
					$this->view->setTemplate($template);
					$this->view->assign('admin_content', $view->loadTemplate());
				}
					
				break;
				
			case 'default':
			default:				
				break;
		}
		
		return $this->view->loadTemplate();
	}
}