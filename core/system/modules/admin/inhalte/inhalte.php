<?php
	
	/************************************************************************
	Adminmaske zur Verwaltung & Bearbeitung der Seiteninhalte
	Version 1.0
	Copyright by Julian Burr - 02.08.2012
	************************************************************************/

	include_once($_SERVER['DOCUMENT_ROOT']."core/classes/admin/AdminMaske.php");
	
	$maske = new AdminMaske("inhalte_inhalte");
	$maske->printMaskeStart();
	
	if(isset($_GET['file'])){
		//Datei ausgewählt => Detailmaske der Datei ausgeben
		include($_SERVER['DOCUMENT_ROOT']."core/system/modules/admin/inhalte/inhalte/detail.php");
	} else {
		//Keine Datei ausgewählt, also Liste der Inhalte ausgeben
		include($_SERVER['DOCUMENT_ROOT']."core/system/modules/admin/inhalte/inhalte/liste.php");
	}
	
	$maske->printMaskeEnd();
	
?>