<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-14
 */

session_start();

//Hauptklasse laden
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/BurrDesignCMS.php');

//...und Ausgabe generieren
$site = new BurrDesignCMS();