<?php

	/***********************************************
	NutMouse CMS
	Version 0.1
	Copyright by Julian Burr - 12.07.2012
	***********************************************/

	session_start();
	
	include_once($_SERVER['DOCUMENT_ROOT']."/core/system/functions.php");
	include_once($_SERVER['DOCUMENT_ROOT']."/core/classes/BurrDesignCMS.php");

	$_SITE = new BurrDesignCMS($_REQUEST['page']);	
	
?>