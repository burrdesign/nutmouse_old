<?php

//Message-Array initialisieren
$messages = array();

//Entweder Galerieübersicht, -details, Bilddetails oder Löschbestätigung anzeigen
if(!empty($_REQUEST['editGaleryImage'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/galeries/image_detail.tpl');
} elseif(!empty($_REQUEST['editGalery'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/galeries/detail.tpl');
} elseif(!empty($_REQUEST['removeGaleryImage'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/galeries/image_delete.tpl');
} elseif(!empty($_REQUEST['removeGalery'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/galeries/delete.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/galeries/overview.tpl');
}