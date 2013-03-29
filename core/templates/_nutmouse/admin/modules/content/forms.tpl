<?php

//Message-Array initialisieren
$messages = array();

//Entweder Formularübersicht, Formulardetails, Formularelementdetails oder Löschbestätigung anzeigen
if(!empty($_REQUEST['editFormElement'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/forms/element_detail.tpl');
} elseif(!empty($_REQUEST['editForm'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/forms/detail.tpl');
} elseif(!empty($_REQUEST['removeFormElement'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/forms/element_delete.tpl');
} elseif(!empty($_REQUEST['removeForm'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/forms/delete.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/forms/overview.tpl');
}