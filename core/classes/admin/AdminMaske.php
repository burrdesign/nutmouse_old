<?php

	/*******************************************
	Hauptklasse zur Ausgabe von AdminMasken
	Version 0.1
	Copyright by Julian Burr - 03.08.2012
	*******************************************/

	class AdminMaske {
		
		private $maske_id;
		
		public function __construct($id){
			$this->maske_id = $id;
		}
		
		public function printMaskeStart(){
			//Beginn der Adminmaske mit ID
			if($this->maske_id){
				$id = "adminmaske_".$this->maske_id;
			}
			echo "<!-- ADMINMASKE $id START -->\n<div class=\"adminmaske\" id=\"$id\">\n";
		}
		
		public function printMaskeEnd(){
			//Abschluss der Adminmaske
			echo "</div>\n<!-- ADMINMASKE $id END -->\n";
		}
		
	}
	
?>