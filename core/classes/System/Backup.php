<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-03-31
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum anlegen, verwalten, etc. von Systembackups
 *		ACHTUNG: Hier sind noch keine DB-Backups integriert!!!
 *		ACHTUNG: Für das zurückspielen eines Backups müssen ALLE Verzeichnisse entsprechendes
 *			Schreibrecht für den PHP-User bereitstellen => evtl. bei All-inkl wichtig zu wissen!
 */
 
include_once("DateLib.php");
include_once("Lib.php");

class Backup {

	private static $backup_dir = '/core/backups/';
	private static $default_backup_ttl = 14; //days
	
	public static function createBackup($filename="",$exclude_cust=array()){
		if(!is_dir($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir)){
			mkdir($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir);
		}
		
		//Eindeutigen Dateinamen erzeugen
		if($filename == ""){
			$filename = "backup_" . DateLib::fmt("Ymd-His", time());
		}
		$org_filename = $filename;
		$i = 0;
		while(is_file($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir . $filename . ".zip")){
			$filename = $org_filename . "_" . $i;
		}
		$filename .= ".zip";
		
		$zip = new ZipArchive();
		$zip->open($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir . $filename, ZipArchive::CREATE);
		
		//Dateien zum archivieren ermitteln
		$exclude_std = array(
					realpath($_SERVER['DOCUMENT_ROOT'] . "/core/cache"),
					realpath($_SERVER['DOCUMENT_ROOT'] . "/core/updates"),
					realpath($_SERVER['DOCUMENT_ROOT'] . "/core/install"),
					realpath($_SERVER['DOCUMENT_ROOT'] . "/core/backups"));
		$exclude = array_merge($exclude_std,$exclude_cust);
		$to_archive = Lib::recursiveReadDir($_SERVER['DOCUMENT_ROOT'], $exclude);
		
		//Und Archiv erzeugen
		foreach($to_archive as $f){
			$clear_f = str_replace($_SERVER['DOCUMENT_ROOT'], "", $f);
			if(is_dir($f)){
				$zip->addEmptyDir($clear_f);
			} elseif(is_file($f)){
				$zip->addFile($f, $clear_f);
			}
		}
		$zip->close();
	}
	
	public static function cleanupBackupDir(){
		if(!is_dir($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir) || self::$default_backup_ttl <= 0){
			mkdir($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir);
		}
		$handle = opendir($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir);
		while($file = readdir($handle)){
			if(is_file($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir . $file)){
				$backup_date = filemtime($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir . $file);
				$backup_min_date = DateLib::fmt('Y-m-d H:i:s', strtotime('-' . self::$default_backup_ttl . ' days', time()));
				if($backup_date < $backup_min_date){
					//Backup TTL abgelaufen => Archiv löschen
					unlink($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir . $file);
				}
			}
		}
		closedir($handle);
	}
	
	public static function resetToBackup($filename){
		if(!is_file($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir . $filename)){
			return;
		}
		$explode = explode(".",$filename);
		if($explode[count($explode)-1] != "zip"){
			return;
		}
		
		//zur Sicherheit noch ein Backup der aktuellen Version anlegen
		self::createBackup("backup_" . DateLib::fmt("Ymd-His", time()) . "_reset");
		
		//Aktive Dateien löschen
		$exclude = array(
					realpath($_SERVER['DOCUMENT_ROOT'] . "/core/cache"),
					realpath($_SERVER['DOCUMENT_ROOT'] . "/core/updates"),
					realpath($_SERVER['DOCUMENT_ROOT'] . "/core/install"),
					realpath($_SERVER['DOCUMENT_ROOT'] . "/core/backups"));
		$to_delete = Lib::recursiveReadDir($_SERVER['DOCUMENT_ROOT'], $exclude);
		foreach($to_delete as $del){
			if(is_file($del)){
				unlink($del);
			} elseif(is_dir($del)){
				Lib::recursiveRmdir($del);
			}
		}
		
		//Backup-Archiv ins Systemverzeichnis entpacken
		$zip = new ZipArchive();
		$zip->open($_SERVER['DOCUMENT_ROOT'] . self::$backup_dir . $filename);
		$zip->extractTo($_SERVER['DOCUMENT_ROOT']);
		$zip->close();	
		
	}
	
}

Backup::resetToBackup("backup_20130331-221023.zip");



