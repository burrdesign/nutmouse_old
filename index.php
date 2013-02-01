<?php
//Session starten
session_start();

//Hauptbibliothek + -klasse einbinden
include_once($_SERVER['DOCUMENT_ROOT'].'/core/lib.php');
include_once($_SERVER['DOCUMENT_ROOT'].'/core/classes/BurrDesignCMS.php');

//Ausgabe
$site = new BurrDesignCMS();