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
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controllers/Frontend/Index.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controllers/Frontend/News.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controllers/Frontend/Galery.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Controllers/Admin/Index.php');

//statische Hilfs-Klassen einbinden
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Config.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Lib.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Log.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Event.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Cache.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/DateLib.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Mail.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Backup.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Stats.php');


//allgemeine nicht statische Klassen
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Db/SqlManager.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Plugin.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Form.php');

class BurrDesignCMS {

	private $view;
	private $controller;
	private $pluginpath = 'core/classes/Plugins';

	public function __construct(){
		//Plugins initialisieren
		$this->initPlugins();
	
		Event::trigger('BurrDesign_PreConstruct');
		
		//angeforderten View ermitteln
		$this->view = $this->determineView($_REQUEST['url']);
		
		//und Seite ausgeben
		echo $this->display();
		
		Event::trigger('BurrDesign_PostConstruct');
	}
	
	//Ausgabe generieren und zurückgeben
	public function display(){
		Event::trigger('BurrDesign_Controller_PreDispatch');
		
		//Subcontroller anhand des ermittelten Views aufrufen
		switch($this->view){
			case 'content': 
				//Normaler Inhalt
				$this->controller = new Controllers_Frontend_Index($_GET,$_POST);
				break;
			
			case 'news':
				//Neuigkeit im Frontend
				$this->controller = new Controllers_Frontend_News($_GET,$_POST);
				break;
				
			case 'galery':
				//Neuigkeit im Frontend
				$this->controller = new Controllers_Frontend_Galery($_GET,$_POST);
				break;
				
			case 'admin':
				//Adminseite
				$this->controller = new Controllers_Admin_Index($_GET,$_POST);
				break;
				
			case 'default':
			default:
				$output =  "<pre>VIEW=" . $this->view . "</pre>";
				break;
		}
		
		Event::trigger('BurrDesign_Controller_PostDispatch');
		
		if(is_object($this->controller)) $output = $this->controller->display();
		return $output;
	}
	
	//View anhand der URL ermitteln
	private function determineView($url){
		Event::trigger('BurrDesign_DetermineView_PreInit');
	
		$view = "";
		$parts = explode('/', $url);
		if($parts[0] == 'news' || $parts[0] == 'n'){
			$view = 'news';
			$_GET['nkey'] = $parts[1];
		} elseif($parts[0] == 'pics'){
			$view = 'galery';
			$_GET['gkey'] = $parts[1];
		} elseif($parts[0] == 'admin'){
			$view = 'admin';
			$adminparts = $parts;
			unset($adminparts[0]);
			$adminurl = implode('/', $adminparts);
			$_GET['path'] = $adminurl;
		} else {
			$view = 'content';
			$_GET['path'] = $url;
		}
		
		Event::trigger('BurrDesign_DetermineView_PostInit');
		
		return $view;
	}
	
	//Installierte + aktivierte Plugins initialisieren
	private function initPlugins(){
		Event::trigger('BurrDesign_InitPlugins_PreInit');
	
		$sql = new SqlManager();
		$sql->setQuery("
			SELECT pluginName FROM bd_sys_plugin
			WHERE pluginActive = 1
			");
		$query = $sql->execute();
		while($plugin = mysql_fetch_array($query)){
			include_once("{$_SERVER['DOCUMENT_ROOT']}/{$this->pluginpath}/{$plugin['pluginName']}/{$plugin['pluginName']}.php");
			$initplugin = new $plugin['pluginName']();
			$initplugin->init();
		}
		
		Event::trigger('BurrDesign_InitPlugins_PostInit');
	}
	
}