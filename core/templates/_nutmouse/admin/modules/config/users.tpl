<?php

//Message-Array initialisieren
$messages = array();

//Entweder Gruppenübersicht, -details, Userdetails oder Löschbestätigung anzeigen
if(!empty($_REQUEST['editUserGroup'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/config/users/group_detail.tpl');
} elseif(!empty($_REQUEST['editUser'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/config/users/detail.tpl');
} elseif(!empty($_REQUEST['removeUserGroup'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/config/users/group_delete.tpl');
} elseif(!empty($_REQUEST['removeUser'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/config/users/delete.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/config/users/overview.tpl');
}