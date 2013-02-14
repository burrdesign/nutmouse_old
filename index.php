<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 */

session_start();

include_once($_SERVER['DOCUMENT_ROOT'] . '/core/lib.php');
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/BurrDesignCMS.php');

$site = new BurrDesignCMS();