<?php

//Message-Array initialisieren
$messages = array();

$path = $_REQUEST['tree'];

//Entweder Seiten�berblick, L�schbest�tigung oder Detailansicht der ausgew�hlten Seite anzeigen
if(!empty($_REQUEST['removeFile'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/files/delete.tpl');
} elseif(is_file($_SERVER['DOCUMENT_ROOT'] . '/' . $path)){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/files/detail.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/files/overview.tpl');
}