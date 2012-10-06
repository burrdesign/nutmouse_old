<?php

	/************************************************************************
	Maske zum bearbeiten des ausgewählten Seiteninhalts
	Version 1.0
	Copyright by Julian Burr - 02.08.2012
	
	@DESC: ES WURDE EINE DATEI AUSGEWÄHLT => DETAILMASKE AUSGEBEN + GGF
	ACTIONS AUSFÜHREN
	************************************************************************/

	include_once($_SERVER['DOCUMENT_ROOT']."core/classes/admin/actions/inhalte/Content.php");
	include_once($_SERVER['DOCUMENT_ROOT']."core/classes/admin/Formular.php");

	$key = $_GET['file'];
	
	$content = new Content($key);
	
	/************************************************************************
	ACTION-PHASE
	************************************************************************/
	
	if($_POST['inhalte_detail_save']){
		//Änderungen speichern bzw. neuen Inhalt anlegen
		if($_POST['contentKey']){
			$content->saveContent($_POST);
		} else {
			$content->saveNewContent($_POST);
			$key = $content->getLastInsertID();
		}
	} elseif($_POST['inhalte_detail_save_new_version']){
		//Als neue Version speichern
		$content->saveContentNewVersion($_POST);
		$key = $content->getLastInsertID();
	} elseif($_POST['inhalte_detail_delete']){
		//Wirklich löschen? Bestätigungsbilschrim anzeigen
		$content->printDeleteAcception();
		return;
	} elseif($_POST['inhalte_detail_deleteaccepted']){
		//Löschen
		$done = $content->deleteContent();
		
		if($done){
			//und Listenansich einblenden, wenn Löschung erfolgreich war
			unset($_GET['file']);
			include($_SERVER['DOCUMENT_ROOT']."core/system/modules/admin/inhalte/inhalte/liste.php");
			return;
		}
	}
	
	
	/************************************************************************
	BEARBEITUNGSMASKE AUSGEBEN
	************************************************************************/
	
	//Seiteninhalt laden
	$content_array = $content->loadContent($key);
	
	//URL-Pfad ausgeben
	$content->printURLPath();
	
	//Titel und ggf. Kurzbeschreibung der Adminmaske ausgeben
	echo "<h3>Seiteninhalt bearbeiten</h3>\n\n";
	
	//Globale Fehler- und Erfolgsmeldungen laden und ggf. ausgeben
	$messages = $content->getMessages();
	if(is_array($messages['global'])){
		foreach($messages['global'] as $type => $message){ echo "<div class=\"$type\">$message</div>"; }
	}
	
	//Formular ausgeben
	$formular = new Formular($content_array);
	$formular->printFormStart("inhalte_detail","?file=".$key,"post");
	
	$formular->printInputHidden("contentKey");
	
	$urlpath = "";
	if($content_array['contentKey'] == "") $urlpath = $_POST['addnew_from'];
	$formular->printInputURL("contentURL","URL-Pfad",$urlpath);
	$formular->printInputText("contentTitle","Seitentitel","","","","width:480px;");
	$formular->printInputSourceCode("contentText","Inhalt","","","","width:800px;");
	
	if($content_array['contentKey']){
		//wenn vorhandener Inhalt bearbeitet wird
		$formular->printSubmit("save","&Auml;nderungen speichern","button_save");
		$formular->printSubmit("save_new_version","Als neue Version speichern","button_save_new_version");
		$formular->printSubmit("delete","L&ouml;schen","button_delete");
	} else {
		//wenn neuer Inhalt angelegt wird
		$formular->printSubmit("save","Speichern","button_save clear");
	}
	
	$formular->printFormEnd();
	
?>