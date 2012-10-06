<?php

	/*****************************************************************************
	Ausgabe der Seiteninhalte als Liste mithilfe der Klasse lists/ContentList.php
	Version 0.1
	Copyright by Julian Burr - 06.10.2012
	
	@DESC: ES WURDE KEINE DATEI AUSGEWÄHLT => LISTE DER SEITENINHALTE LADEN 
	UND AUSGEBEN
	*****************************************************************************/

	include_once($_SERVER['DOCUMENT_ROOT']."core/classes/admin/lists/ContentList.php");
	include_once($_SERVER['DOCUMENT_ROOT']."core/classes/admin/Formular.php");
	
	//Grundverzeichnis initialisieren und berücksichigen
	$list_id = "inhalte_inhalte_liste";
	if(isset($_GET['dir'])) $_SESSION['BURRDESIGN']['ADMIN']['settings'][$list_id]['maindir'] = $_GET['dir'];
	if(isset($_GET['mixdirs'])) $_SESSION['BURRDESIGN']['ADMIN']['settings'][$list_id]['mixdirs'] = $_GET['mixdirs'];
	if(isset($_GET['sort'])) $_SESSION['BURRDESIGN']['ADMIN']['settings'][$list_id]['sort'] = $_GET['sort'];
	
	$maindir = $_SESSION['BURRDESIGN']['ADMIN']['settings'][$list_id]['maindir'];
	
	//Liste initalisieren
	$filelist = new ContentList($list_id);
	
	//und ausgeben
	$filelist->printListNav(array("all"));
	$filelist->printList();
	
	//Button zum anlegen neuer Inhalte einbinden
	$formular = new Formular(array());
	$formular->printFormStart("inhalte_detail","?file=","post");
	$formular->printInputHidden("addnew_from",$maindir);
	$formular->printSubmit("addnew","Neuen Inhalt anlegen","button_new clear");
	$formular->printFormEnd();
?>