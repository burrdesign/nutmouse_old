<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-14
 *
 * @Beschreibung:
 *		Admin-Controller im MVC-Framework. Hier wird anhand der übergebenen Parameter
 *		das entsprechende Model geladen und die Seite erzeugt und zur Ausgabe an die
 *		Hauptklasse übergeben
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Models/Admin/Index.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/View.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controller.php');

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Cache.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Session.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Admin.php');

class Controllers_Admin_Index extends Controller {

	public function __construct($get,$post){
		parent::__construct($get,$post);
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
				if(!$entry['moduleTemplate']){
					$template = 'admin/index';
				}
				
				//inneres Template vorbereiten
				$inner_template = 'admin/modules/' . $entry['moduleCoreFile'];
				
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