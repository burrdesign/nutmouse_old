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

class View {

	private $path = 'core/templates';
	private $template = 'default';

	//Variablen, die im Template zur Verfügung stehen sollen
	private $_ = array();

	/**
	 * @Beschreibung: Variablen initialisieren
	 * @param: key		Variablenname
	 * @param: value	Variablenwert
	 */
	public function assign($key, $value){
		$this->_[$key] = $value;
	}

	/**
	 * @param: template		Name des zu setzenden Templates
	 */
	public function setTemplate($template = 'default'){
		$this->template = $template;
	}

	/**
	 * @Beschreibung: laden des von setTemplate() gesetzten Ausgabe-Templates
	 */
	public function loadTemplate(){
		$tpl = $this->template;
		
		$file = $this->path . DIRECTORY_SEPARATOR . $tpl . '.tpl';
		$exists = file_exists($file);

		if ($exists){
		
			ob_start();
			include $file;
			$output = ob_get_contents();
			ob_end_clean();
				
			// Output zurückgeben.
			return $output;
		} else {
			// Template-File existiert nicht => Fehlermeldung
			return 'could not find template: '.$this->path . DIRECTORY_SEPARATOR . $tpl . '.tpl';
		}
	}
	
}