<?php

//Message-Array initialisieren
$messages = array();

//Entweder Seitenüberblick, Löschbestätigung oder Detailansicht der ausgewählten Neuigkeit anzeigen
if(!empty($_REQUEST['editNews'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/news/detail.tpl');
} elseif(!empty($_REQUEST['removeNews'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/news/delete.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/news/overview.tpl');
}