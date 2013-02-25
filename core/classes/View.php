<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 *
 * @Beschreibung:
 *		View-Klasse zum setzen, laden und ggf. auch auf- und vorbereiten von
 *		Ausgabetemplates
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Config.php');

class View {

	private $path = 'core/templates';
	private $template = 'default';
	private $theme = null;
	private $default_theme = '_nutmouse';

	//Variablen, die im Template zur Verfügung stehen sollen
	private $_ = array();
	
	public function __construct(){
		Event::trigger('View_PreConstruct');
	
		//aktuelles Theme laden
		$this->theme = Config::get("theme");
		if(!$this->theme){
			$this->theme = $this->default_theme;
		}
		
		Event::trigger('View_PostConstruct');
	}

	//Variable für das aktuelle Template zuweisen
	public function assign($key, $value){
		$this->_[$key] = $value;
	}

	public function setTemplate($template = 'default'){
		$this->template = $template;
	}

	public function loadTemplate(){
		$tpl = $this->template;
		
		$file = $_SERVER['DOCUMENT_ROOT'] . '/' . $this->path . '/' . $this->theme . '/' . $tpl . '.tpl';
		$exists = file_exists($file);
		
		if(!$exists){
			//Template im Theme nicht gefunden, Default-Theme verwenden
			$file = $_SERVER['DOCUMENT_ROOT'] . '/' . $this->path . '/' . $this->default_theme . '/' . $tpl . '.tpl';
			$exists = file_exists($file);
		}

		if ($exists){
			ob_start();
			include $file;
			$output = ob_get_contents();
			ob_end_clean();
			return $output;
		} else {
			// Template-File existiert nicht => Fehlermeldung
			return 'could not find template: ' . $tpl . '.tpl';
		}
	}
	
	public function header($header){
		header($header);
	}
}