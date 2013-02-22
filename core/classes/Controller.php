<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-14
 *
 * @Beschreibung:
 *		Controller-Vorlageklasse, auf der die anderen Subcontroller aufbauen
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/View.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Session.php');

class Controller {

	protected $request = array();
	protected $get = array();
	protected $post = array();
	protected $template = '';
	protected $view = null;

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
		
		$this->display = 'default';
		if(!empty($this->request['view'])){
			$this->display = $this->request['view'];
		}
	}

}