<?php

//Message-Array initialisieren
$messages = array();

//Entweder Seiten�berblick, L�schbest�tigung oder Detailansicht der ausgew�hlten Seite anzeigen
if(!empty($_REQUEST['removePlugin'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/config/plugins/delete.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/config/plugins/overview.tpl');
}