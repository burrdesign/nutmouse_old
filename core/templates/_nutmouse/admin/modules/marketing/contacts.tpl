<?php

//Message-Array initialisieren
$messages = array();

//Entweder Adressdetails, Gruppenübersicht, -details, Kontaktdetails oder Löschbestätigung anzeigen
if(!empty($_REQUEST['editContactAddress'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/contacts/address_detail.tpl');
} elseif(!empty($_REQUEST['editContactGroup'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/contacts/group_detail.tpl');
} elseif(!empty($_REQUEST['editContact'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/contacts/detail.tpl');
} elseif(!empty($_REQUEST['removeContactAddress'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/contacts/address_delete.tpl');
} elseif(!empty($_REQUEST['removeContactGroup'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/contacts/group_delete.tpl');
} elseif(!empty($_REQUEST['removeContact'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/contacts/delete.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/contacts/overview.tpl');
}