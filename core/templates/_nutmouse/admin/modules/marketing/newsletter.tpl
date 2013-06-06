<?php

//Message-Array initialisieren
$messages = array();

//Entweder Anhangdetails, Themenübersicht, -details, Newsletterdetails, Lösch- oder Sendebestätigung anzeigen
if(!empty($_REQUEST['editNewsletterAttachment'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/attachment_detail.tpl');
} elseif(!empty($_REQUEST['editNewsletterTheme'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/theme_detail.tpl');
} elseif(!empty($_REQUEST['editNewsletter'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/detail.tpl');
} elseif(!empty($_REQUEST['removeNewsletterAttachment'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/attachment_delete.tpl');
} elseif(!empty($_REQUEST['removeNewsletterTheme'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/theme_delete.tpl');
} elseif(!empty($_REQUEST['removeNewsletter'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/delete.tpl');
} elseif(!empty($_REQUEST['sendNewsletter'])){
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/send.tpl');
} else {
	include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/overview.tpl');
}