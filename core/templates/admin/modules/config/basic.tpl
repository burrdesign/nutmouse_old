<?php
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/db/SqlManager.php');
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/admin/Form.php');
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Cache.php');
	
	/*
	 * ACTIONPHASE:
	 * Speichern der Einstellungen
	 */
	if($this->_['post']['do'] == 'saveConfig'){
		//Konfiguration speichern
		$sql = new SqlManager();
		foreach($this->_['post'] as $key => $value){
			$sql->setQuery("
				UPDATE bd_sys_config
				SET configValue = '{{value}}'
				WHERE configLabel = '{{label}}'
				");
			$sql->bindParam("{{value}}",$value);
			$sql->bindParam("{{label}}",$key);
			$sql->execute();
		}
		$messages['ok'] = 'Die Einstellungen wurden erfolgreich gespeichert!';
		
		//Config-Cache löschen
		$config = Cache::clearCache("config");
	}
	 
	/*
	 * Einstellungen laden
	 */
	$config = Cache::loadCache("config");
	
	if(!is_array($config)){
		//kein Cache vorhanden, also neu laden
		$sql = new SqlManager();
		$sql->setQuery("SELECT * FROM bd_sys_config");
		$result = $sql->execute();
		$config = array();
		while($res = mysql_fetch_array($result)){
			$config[$res['configLabel']] = $res['configValue'];
		}
		Cache::saveCache("config",$config);
	}
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-pawn"></span> Grundeinstellungen</h2>
	<p class="mask_desc">Hier legen Sie grundlegende Einstellungen für Ihre Website und das System fest. Diese Einstellungen k&ouml;nnen Einfluss auf die Darstellung im Frontend haben. &Auml;nderungen werden sofort wirksam!</p>
</div>

<?php
	if(is_array($messages)){
		echo "<div class=\"mask_messages\">\n";
		foreach($messages as $msg_type => $msg_text){
			echo "\t<br class=\"clear\" />\n";
			echo "\t<div class=\"message message_{$msg_type}\"><span class=\"icon\"></span><span class=\"text\">{$msg_text}</span></div>\n";
		}
		echo "</div>\n";
	}
?>

<div class="mask_form">

	<?php
	
		$form = new Form();
		
		$form->addMandatory("maintitle","string");
		
		$form->start("","post");
		$form->element->printHidden("do","saveConfig");
		$form->element->printTextfield("Haupt-Seitentitel", "maintitle", $config['maintitle']);
		$form->element->printSubmit("Speichern");
		$form->end();
	
	?>
	
</div>