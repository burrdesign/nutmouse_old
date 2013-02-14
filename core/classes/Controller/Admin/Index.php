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
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Models/Admin/Index.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/View.php');

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Cache.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Session.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Admin.php');

class Controller_Admin_Index {

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
		$admin = new Admin();
	
		//Login-Actions
		$loginmessage = array();
		if($this->request['path'] == 'logout'){
			$admin->doLogout();
		} elseif($this->post['do'] == 'LogUserIn'){
			$admin->checkLogin($this->post);
		}
					
		//Login-Status prüfen
		if($_SESSION['BD']['ADMIN']['login_status'] == 1){			
			//Admin-Modul laden
			if(isset($this->request['path'])) $entry = Models_Admin_Index::getAdminContentByPath($this->request['path']);
			
			if(is_array($entry)){
				//Haupttemplate vorbereiten
				$template = 'admin/' . $entry['moduleTemplate'];
				if(!is_file($_SERVER['DOCUMENT_ROOT'] . '/core/templates/' . $template . '.tpl')){
					$template = 'admin/index';
				}
				
				//inneres Template vorbereiten
				$inner_template = 'admin/modules/' . $entry['moduleCoreFile'];
				if(!is_file($_SERVER['DOCUMENT_ROOT'] . '/core/templates/' . $inner_template . '.tpl')){
					$inner_template = 'admin/error/error404';
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
		} else {
			//Admin-Benutzer ist noch nicht angemeldet => Login-Fenster ausgeben
			$this->view->setTemplate('admin/login');
			
			if($this->request['path'] == "logout"){
				$this->view->assign('path','/admin/');
			} else {
				$this->view->assign('path','/admin/'.$this->request['path']);
			}
			$this->view->assign('login_message',$admin->getMessage());
		}
		
		return $this->view->loadTemplate();
	}
}