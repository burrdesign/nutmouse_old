<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-01-24
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum vorbereiten, ausführen und verarbeiten von
 *		Datenbankabfragen und -anweisungen
 */

class SqlManager {

	private $query;
	private $q_table;
	private $q_action;
	private $q_object = array();
	private $q_table_info = array();
	
	private $mysqlhost = "";
	private $mysqluser = "";
	private $mysqlpwd = "";
	private $mysqldb = "";
	
	public function __construct(){
		//Konfiguration laden
		include($_SERVER['DOCUMENT_ROOT'] . '/core/config.php');
		$this->mysqlhost = $HOST;
		$this->mysqluser = $USER;
		$this->mysqlpwd = $PWD;
		$this->mysqldb = $DB;
		
		//Verbindung zu DB herstellen
		$connection = mysql_connect($this->mysqlhost,$this->mysqluser,$this->mysqlpwd) OR die ('<pre>Verbindungsversuch fehlgeschlagen</pre>');
		mysql_select_db($this->mysqldb,$connection) OR die ('<pre>Konnte die Datenbank nicht w&auml;hlen</pre>');
	}
	
	public function setQuery($query){
		//Query speichern
		$this->query = $query;
	}
	
	public function bindParam($str,$value,$type='string'){
		//Benutzereingabe schützen vor SQL-Injektion
		$value = mysql_real_escape_string($value);
		if($type == "int"){
			$value = (int)$value;
		}
		$this->query = str_replace($str,$value,$this->query);
	}
	
	public function execute(){
		//Query ausführen und ggf. Ergebnisarray zurückgeben
		if(!$this->query){
			return;
		}
		$result = mysql_query($this->query) OR die ("<pre>Anfrage nicht erfolgreich\n\n{$this->query}\n\n".mysql_error()."</pre>");
		return $result;
	}
	
	public function result(){
		//Select mit nur einem Ergebnis ausführen und nur Ergebnis als Array zurückgeben
		if(!$this->query){
			return;
		}
		$ergebnis = array();
		$abfrage = $this->execute();
		while ($row = mysql_fetch_array($abfrage)) {
			$ergebnis = $row;
		}
		return $ergebnis;
	}
	
	public function insert($table,$object){
		//Datensatz anhand eines Arrays anlegen
		$this->q_table = $table;
		if(!is_array($object)){
			return;
		}
		$insert = $this->getDataObject($object);
		if(count($insert) < 1){
			return;
		}
		
		$query = "INSERT INTO {$this->q_table} (";
		$sep = "";
		foreach($insert as $key => $value){
			$query .= "${sep} ".mysql_real_escape_string($key);
			$sep = ",";
		}
		$query .= ") VALUES (";
		$sep = "";
		foreach($insert as $key => $value){
			$value = stripslashes($value);
			$query .= "${sep} '".mysql_real_escape_string($value)."'";
			$sep = ",";
		}
		$query .= ")";
		$this->setQuery($query);
		$this->execute();
	}
	
	public function getLastInsertID(){
		$key = mysql_insert_id();
		return $key;
	}
	
	public function getLineCount($table){
		$this->setQuery("SELECT * FROM ".mysql_real_escape_string($table));
		$result = $this->execute();
		$cnt = mysql_num_rows($result);
		return $cnt;
	}
	
	public function update($table,$object){
		//Datensatz anhand eines Arrays updaten
		$this->q_table = $table;
		if(!is_array($object)){
			return;
		}
		$update = $this->getDataObject($object);
		foreach($this->table_info['primarykey'] as $key){
			if(!$update[$key]){
				return;
			}
		}
		
		$query = "UPDATE {$this->q_table} SET ";
		$sep = "";
		foreach($update as $key => $value){
			$value = stripslashes($value);
			$query .= "${sep} ".mysql_real_escape_string($key)."='".mysql_real_escape_string($value)."'";
			$sep = ",";
		}
		$query .= "WHERE ";
		$sep = "";
		foreach($this->table_info['primarykey'] as $key){
			$query .= "${sep} ${key}='".mysql_real_escape_string($update[$key])."'";
			$sep = "AND";
		}
		$query .= " LIMIT 1";
		$this->setQuery($query);
		$this->execute();
	}
	
	public function delete($table,$object){
		//Datensatz anhand eines Arrays löschen => Array muss eigentlich nur die Primärschlüssel enthalten
		$this->q_table = $table;
		if(!is_array($object)){
			return;
		}
		$delete = $this->getDataObject($object);
		foreach($this->table_info['primarykey'] as $key){
			if(!$delete[$key]){
				return;
			}
		}
		$query = "DELETE FROM {$this->q_table} WHERE ";
		$sep = "";
		foreach($this->table_info['primarykey'] as $key){
			$delete[$key] = stripslashes($delete[$key]);
			$query .= "${sep} ${key}='".mysql_real_escape_string($delete[$key])."'";
			$sep = "AND";
		}
		$query .= " LIMIT 1";
		$this->setQuery($query);
		$this->execute();
	}
	
	public function get($table,$keyfield,$keyvalue){
		//Laden eines Datenobjekts anhand eines übergebenen Schlüssels
		$result = array();
		$keyvalue = stripslashes($keyvalue);
		$this->setQuery("
			SELECT * FROM ".mysql_real_escape_string($table)." 
			WHERE ".mysql_real_escape_string($keyfield)." = '".mysql_real_escape_string($keyvalue)."' 
			LIMIT 1
			");
		$result = $this->result();
		return $result;
	}
	
	public function getDataObject($object){
		//Datenobjekt für den Tabellenmanager aufbereiten und validieren
		if(!$this->q_table){
			return;
		}
		$data = array();
		$this->table_info = $this->getTableInfo($this->q_table);
		foreach($object as $key => $value){
			if(in_array($key,$this->table_info['fields']) !== false){
				$data[$key] = $value;
			}
		}
		return $data;
	}
	
	public function getTableInfo($table){
		//DB-Tabelleninfos in Array laden
		$this->setQuery("DESCRIBE ".mysql_real_escape_string($table));
		$result = $this->execute();
		
		$info['keys'] = array();
		$info['primarykey'] = array();
		$info['fields'] = array();
		$info['field'] = array();
		
		while($row = mysql_fetch_array($result)){
			$info['fields'][] = $row['Field'];
			$info['field'][$row['Field']] = $row;
			if($row['Key']){
				$info['keys'][] = $row['Field'];
				if($row['Key'] == "PRI"){
					$info['primarykey'][] = $row['Field'];
				}
			}
		}
		return $info;
	}
	
	public function executeSqlFile($filepath){
		//(mehrere) SQL-Anweisung(en) aus einer SQL-Datei ausführen (bspw. aus einem Dump)
		if(!is_file($filepath)){
			return;
		}
		$queries = $this->getQueriesFromFile($filepath);
		//Queries ausführen
		foreach($queries as $q){
			$this->setQuery($q);
			$this->execute();
		}
	}
	
	public function getQueriesFromFile($filepath){
		//SQL-Anweisungen aus SQL-Datei auslesen und einzeln getrennt als Array zurückgeben
		if(!is_file($filepath)){
			return;
		}
		$queries = array();
		$handle = fopen($filepath, 'rb');
		while (!feof($handle)) {
			$queries[] = stream_get_line($handle, 1000000, ";\n");
		}
		return $queries;
	}

	public function escape($string, $type="string"){
		if($type == "int"){
			return (int)$string;
		}
		return mysql_real_escape_string($string);
	}
	
}