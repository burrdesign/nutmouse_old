<?php

//Message-Array initialisieren
$messages = array();

//Entweder Menüübersicht, Menüedetails, Menüelementdetails oder Löschbestätigung anzeigen
if(!empty($_REQUEST['editMenuElement'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/menus/element_detail.tpl');
} elseif(!empty($_REQUEST['editMenu'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/menus/detail.tpl');
} elseif(!empty($_REQUEST['removeMenuElement'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/menus/element_delete.tpl');
} elseif(!empty($_REQUEST['removeMenu'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/menus/delete.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/menus/overview.tpl');
}