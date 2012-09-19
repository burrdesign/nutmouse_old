<?php

	/************************************************************************
	Hauptklasse des BurrDesign für das Laden und Ausgeben der Adminmodule
	Version 0.1
	Copyright by Julian Burr - 19.09.2012
	************************************************************************/
	
	include_once($_SERVER['DOCUMENT_ROOT']."/core/classes/Template.php");

	class AdminPage {
		
		private $page_url;
		private $page_object = array();
		private $page_module;
		private $page_module_path;
		
		public function __construct($page){
			unset($_SESSION['BURRDESIGN']['ADMIN']['current_page']);
			$this->page_url = $page;
		}
		
		public function loadPageModule(){
			$success = false;
			$module = "";
			
			//Modul aus der Datenbank laden
			
			//Loginstatus überprüfen
			include($_SERVER['DOCUMENT_ROOT']."/core/system/modules/admin/auth/checklogin.php");
			
			if(!$_SESSION['BURRDESIGN']['ADMIN']['loggedin']){
				//Admin noch nicht eingeloggt, also Loginseite erzwingen
				$this->page_module = "admin/auth/loginform.php";
				$this->page_module_path = $_SERVER['DOCUMENT_ROOT']."/core/system/modules/".$this->page_module;
				$this->page_object['pagedata']['modTemplate'] = "admin/login.tpl";
				$this->page_object['pagedata']['modText'] = get_include($this->page_module_path);
				return true;
			}
			
			//Aus der Moduldatenbanktabelle laden
			$page_query = new SQLManager();
			$this->page_object['pagedata'] = $page_query->get("bd_admin_modules","modURL",$this->page_url);
			
			if($this->page_object['pagedata']['modKey']){
				//Modul gefunden
				$this->page_module = $this->page_object['pagedata']['modPath'];
				$this->page_module_path = $_SERVER['DOCUMENT_ROOT']."/core/system/modules/".$this->page_module;
				if(!$this->page_object['pagedata']['modTemplate']){
					$this->page_object['pagedata']['modTemplate'] = "admin/index.tpl";
				}
				$this->page_object['pagedata']['modText'] = get_include($this->page_module_path);
				
				$_SESSION['BURRDESIGN']['ADMIN']['current_page'] = $this->initPageInfo();
				
				$success = true;
			}
			
			return $success;
		}
		
		public function printAdminPage(){
			//Seite ausgeben
			$tpl = new Template($this->page_object['pagedata']['modTemplate']);
			$tpl->parseTemplateContent($this->page_object['pagedata']['modText']);
			$tpl->printTemplateContent();
		}
		
		public function printAdminError(){
			//Fehlerseite ausgeben
			$tpl = new Template("admin/error.tpl");
			$tpl->parseTemplateContent("<pre>Adminseite konnte nicht gefunden werden!</pre>");
			$tpl->printTemplateContent();
		}
		
		private function initPageInfo(){
			//Seiteninformationen initialisieren
			$info_query = new SQLManager();
			$info['menu_info'] = $info_query->get("bd_admin_menu","adminMenuKey",$this->page_object['pagedata']['modMenu']);
			if($info['menu_info']['adminMenuParent']){
				$info['mainmenu_info'] = $info_query->get("bd_admin_menu","adminMenuKey",$info['menu_info']['adminMenuParent']);
			} else {
				$info['mainmenu_info'] = $info['menu_info'];
			}
			return $info;
		}
	}
	
?>