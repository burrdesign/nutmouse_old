<?php

//Message-Array initialisieren
$messages = array();

//Entweder Seiten�berblick, L�schbest�tigung oder Detailansicht der ausgew�hlten Seite anzeigen
if(!empty($_REQUEST['editFile'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/sites/detail.tpl');
} elseif(!empty($_REQUEST['removeFile'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/sites/delete.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/sites/overview.tpl');
}