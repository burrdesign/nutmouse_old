<?php

//Message-Array initialisieren
$messages = array();

//Entweder Seiten�berblick, L�schbest�tigung oder Detailansicht der ausgew�hlten Neuigkeit anzeigen
if(!empty($_REQUEST['editNews'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/news/detail.tpl');
} elseif(!empty($_REQUEST['removeNews'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/news/delete.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/news/overview.tpl');
}