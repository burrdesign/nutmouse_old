<?php

//Message-Array initialisieren
$messages = array();

//Entweder Seitenüberblick, Löschbestätigung oder Detailansicht der ausgewählten Seite anzeigen
if(!empty($_REQUEST['editFile'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/sites/detail.tpl');
} elseif(!empty($_REQUEST['removeFile'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/sites/delete.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/sites/overview.tpl');
}