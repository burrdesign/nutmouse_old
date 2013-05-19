<?php

/**
 * Step 1: PHP-Version prüfen
 * Step 2: SQL-Zugangsdaten
 * Step 3: SQL-Version prüfen + Dump einspielen
 * Step 4: Admin-Benutzer
 * Step 5: DONE
 **/
 
session_start();

//Fehlerausgabe steuern
error_reporting(E_ALL);
ini_set("display_errors", "off");

//Hilfsvariablen für die Ausgabe am Ende
$syserr = "";
$errmsg = "";
$step = 1;
$steps = array(
			1 => "Systemvorraussetzungen pr&uuml;fen",
			2 => "Datenbankverbindung herstellen",
			3 => "Datenbank pr&uuml;fen",
			4 => "Datenbank anlegen",
			5 => "Benutzer anlegen",
			6 => "Abschluss"
			);

//Pfad zur Konfigurationsdatei
$configfile = $_SERVER['DOCUMENT_ROOT'] . '/core/config.php';

//SqlManager + StdLib einbinden
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Db/SqlManager.php');
nclude_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Lib.php');

//Datenbankdaten überschreiben, wenn in POST enthalten
if($_POST['tryConnection']){
	$_SESSION['dbhost'] = $_POST['dbhost'];
	$_SESSION['dbuser'] = $_POST['dbuser'];
	$_SESSION['dbpwd'] = $_POST['dbpwd'];
	$_SESSION['dbdb'] = $_POST['dbdb'];
	
	//Daten in die Config-Datei schreiben
	Lib::writeDbConfigFile($_SESSION['dbhost'], $_SESSION['dbuser'], $_SESSION['dbpwd'], $_SESSION['dbdb']);
}

//Wenn Datenbankdaten bereits hinterlegt sind diese verwenden
include_once($configfile);
$_SESSION['dbhost'] = $HOST;
$_SESSION['dbuser'] = $USER;
$_SESSION['dbpwd'] = $PWD;
$_SESSION['dbdb'] = $DB;

//Datenbankabfragen vor der InstallAssistent-Ausgabe
if(mysql_select_db($_SESSION['dbdb'], mysql_connect($_SESSION['dbhost'],$_SESSION['dbuser'],$_SESSION['dbpwd']))){
	$sql = new SqlManager();
	
	//Version auslesen
	$sql->setQuery("SELECT VERSION() AS version");
	$res = $sql->result();
	$sqlversion = $res['version'];
	
	//DB auf vorhandene Tabellen prüfen
	$sql->setQuery("SHOW TABLES LIKE 'bd_%'");
	$res = $sql->execute();
	$sqltest = (int)mysql_num_rows($res);
	
	//Neuen Benutzer anlegen
	if($_POST['addAdmin'] && $_POST['adminLogin'] && $_POST['adminPassword']){
		$_POST['adminPassword'] = md5($_POST['adminPassword']);
		$sql->setQuery("SELECT groupKey FROM bd_sys_admin_group WHERE groupName = 'root'");
		$res = $sql->result();
		$_POST['adminGroupKey'] = (int)$res['groupKey'];
		$sql->insert("bd_sys_admin_user", $_POST);
	}
	
	if($sqltest > 0){
		//Anzahl vorhandener Admins in der DB prüfen
		$sql->setQuery("SELECT COUNT(*) AS anzahl FROM bd_sys_admin_user");
		$res = $sql->result();
		$sqladmin = $res['anzahl'];
	} else {
		//Dump einspielen
		$sql->executeSqlFile($_SERVER['DOCUMENT_ROOT'] . '/core/install/database.sql');
		
		$sql->setQuery("SHOW TABLES LIKE 'bd_%'");
		$res = $sql->execute();
		$sqltest = (int)mysql_num_rows($res);
	}
}

if(phpversion() < "5.3.1"){
	//STEP 1 - PHP-Version ist zu alt und wird nicht unterstützt
	$step = 1;
	
} elseif(!$_SESSION['dbuser'] || !$_SESSION['dbhost'] || !$_SESSION['dbpwd'] || !$_SESSION['dbdb'] || 
	!mysql_select_db($_SESSION['dbdb'], mysql_connect($_SESSION['dbhost'],$_SESSION['dbuser'],$_SESSION['dbpwd']))){
	//STEP 2 - Verbindung mit Datenbank noch nicht hergestellt
	$step = 2;
	
} elseif($sqlversion < "5.1.0"){
	//STEP 3 - SQL-Version ist zu alt und wird nicht unterstützt
	$step = 3;
	
} elseif($sqltest <= 0){
	//STEP 4 - SQL-Dump nicht eingespielt
	$step = 4;
	
} elseif($sqladmin <= 0){
	//STEP 5 - Es wurde noch kein Admin-Benutzer angelegt
	$step = 5;

} else {
	//Installation abgeschlossen
	$step = 6;
}

/**
 * Nachfolgend findet die Ausgabe entsprechend des gerade ermittelten
 * Standes der Installation statt!
 **/

?><!doctype html>
<html>
<head>
	<title>NutMouse CMS v0.2 - Installations Assistent - Step <?php echo $step; ?></title>
	
	<link rel="stylesheet" href="style.css">
	<link rel="stylesheet" href="/core/templates/_nutmouse/admin/img/icons/iconfont/style.css">
	<!--[if lte IE 7]><script type="text/javascript" src="/core/templates/_nutmouse/admin/img/icons/iconfont/lte-ie7.js"></script><![endif]-->
</head>
</body>
	<div class="wrap_installassistant">
		<div class="wrap_head">
			<h1>NutMouse Installations Assistent</h1>
		</div>
		<div class="wrap_steps">
			<?php
				foreach($steps as $nmb => $label){
					$class = "todo";
					$icon = "icon-checkbox-unchecked";
					if($nmb < $step){
						$class = "done";
						$icon = "icon-checkbox-checked";
					} elseif($nmb == $step){
						$class = "curr";
						$icon = "icon-checkbox-partial";
					}
					echo "<div class=\"step step{$nmb} {$class}\"><p><span class=\"icon {$icon}\"></span> {$label}</p></div>";
				}
			?>
		</div>
		<div class="wrap_content">
			<?php			
				switch($step){
					case 1: 
						//Systemtest nicht bestanden => PHP-Version zu alt
						echo "<div class=\"syserr\"><h3><span class=\"icon icon-warning\"></span> Es ist ein Fehler aufgetreten</h3><p>F&uuml;r das NutMouse CMS System wird mindestens die PHP-Version 5.3.1 ben&ouml;tigt. Auf dem Server l&auml;ft aktuell aber nur Version " . PHP_VERSION . ". Die Installation wurde daher abgebrochen!</p></div>";
						break;
					case 2:
						//Noch keine Verbindung zur DB hergestellt
						echo "<h3>Datenbankverbindung</h3>";
						if($_POST['tryConnection']){
							echo "<div class=\"errormsg\"><p>Es konnte keine Verbindung zur Datenbank hergestellt werden!</p></div>";
						}
						echo "<p>Geben Sie die Zugangsdaten für die SQL-Datenbank an, damit sich das System verbinden kann.</p>";
						echo "<div class=\"db_form\"><form name=\"tryConnection\" action=\"{$_SERVER['PHP_SELF']}\" method=\"post\"><input type=\"hidden\" name=\"tryConnection\" value=\"1\"><table>";
						echo "<tr><td class=\"label\">Host:</td><td><input type=\"text\" class=\"text\" name=\"dbhost\" value=\"{$_SESSION['dbhost']}\"></td></tr>";
						echo "<tr><td class=\"label\">Benutzer:</td><td><input type=\"text\" class=\"text\" name=\"dbuser\" value=\"{$_SESSION['dbuser']}\"></td></tr>";
						echo "<tr><td class=\"label\">Passwort:</td><td><input type=\"text\" class=\"text\" name=\"dbpwd\" value=\"{$_SESSION['dbpwd']}\"></td></tr>";
						echo "<tr><td class=\"label\">Datenbank:</td><td><input type=\"text\" class=\"text\" name=\"dbdb\" value=\"{$_SESSION['dbdb']}\"></td></tr>";
						echo "<tr><td colspan=\"2\"><input type=\"submit\" class=\"submit\" name=\"dbsubmit\" value=\"Verbindung herstellen\"></td></tr>";
						echo "</table></form></div>";
						break;
					case 3:
						//Systemtest nicht bestanden => SQL-Version zu alt
						echo "<div class=\"syserr\"><h3><span class=\"icon icon-warning\"></span> Es ist ein Fehler aufgetreten</h3><p>F&uuml;r das NutMouse CMS System wird mindestens die SQL-Version 5.1.0 ben&ouml;tigt. Der SQL-Server hat aber nur Version " . $sqlversion . ". Die Installation wurde daher abgebrochen!</p></div>";
						break;
					case 4:
						//Dump konnte nicht eingespielt werden
						echo "<div class=\"syserr\"><h3><span class=\"icon icon-warning\"></span> Es ist ein Fehler aufgetreten</h3><p>Die Datenbankstruktur konnte aus unbekannten Gr&uuml;nden nicht angelegt werden!</p></div>";
						break;
					case 5:
						//Noch kein Benutzer angelegt
						echo "<h3>Benutzer</h3>";
						if($_POST['addAdmin']){
							echo "<div class=\"errormsg\"><p>Es m&uuml;ssen mindestens Benutzername und Passwort angegeben werden!</p></div>";
						}
						echo "<p>Geben Sie die Zugangsdaten für den Admin-Benutzer an.</p>";
						echo "<div class=\"db_form\"><form name=\"addAdmin\" action=\"{$_SERVER['PHP_SELF']}\" method=\"post\"><input type=\"hidden\" name=\"addAdmin\" value=\"1\"><table>";
						echo "<tr><td class=\"label\">Benutzername:</td><td><input type=\"text\" class=\"text\" name=\"adminLogin\" value=\"{$_POST['adminLogin']}\"></td></tr>";
						echo "<tr><td class=\"label\">Passwort:</td><td><input type=\"password\" class=\"text\" name=\"adminPassword\" value=\"\"></td></tr>";
						echo "<tr><td class=\"trenner\" colspan=\"2\"></td></tr>";
						echo "<tr><td class=\"label\">Name:</td><td><input type=\"text\" class=\"text\" name=\"adminName\" value=\"{$_POST['adminName']}\"></td></tr>";
						echo "<tr><td class=\"label\">Nachname:</td><td><input type=\"text\" class=\"text\" name=\"adminLastName\" value=\"{$_POST['adminLastName']}\"></td></tr>";
						echo "<tr><td colspan=\"2\"><input type=\"submit\" class=\"submit\" name=\"adminsubmit\" value=\"Benutzer anlegen\"></td></tr>";
						echo "</table></form></div>";
						break;
					case 6:
						//Installation abgeschlossen
						echo "<div class=\"done\"><h3>Installation abgeschlossen</h3><p>Das NutMouse CMS System wurde erfolgreich auf dem System installiert. Das Backoffice erreichen Sie nun unter <a href=\"http://{$_SERVER['SERVER_NAME']}/admin/\">http://{$_SERVER['SERVER_NAME']}/admin/</a>.</p></div>";
						break;
					default:
						break;
				}
			?>
		</div>
	</div>
</body>
</html>