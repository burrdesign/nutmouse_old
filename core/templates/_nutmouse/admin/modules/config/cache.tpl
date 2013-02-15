<?php
	$cachepath = $_SERVER['DOCUMENT_ROOT'] . '/core/cache/';

	/**
	 * ACTIONPHASE:
	 * Speichern der Einstellungen
	 */
	if($this->_['post']['do'] == 'saveCacheConfig'){
		//Konfiguration speichern
		$sql = new SqlManager();
		$sql->setQuery("
			UPDATE bd_sys_config
			SET configValue = {{value}}
			WHERE configLabel = 'enable_cache'
			");
		$sql->bindParam("{{value}}",$this->_['post']['enable_cache'],"int");
		$sql->execute();
		$messages['ok'] = 'Die Einstellungen wurden erfolgreich gespeichert!';
		
		//Config-Cache lˆschen
		Cache::clearCache("config");
	} elseif($this->_['request']['do'] == 'clearCache'){
		//Gesamten Cache lˆschen
		$handle = opendir($cachepath);
		while($file = readdir($handle)){
			if(is_file($cachepath . $file)){
				unlink($cachepath . $file);
			}
		}
		$messages['ok'] = 'Der Cache wurde erfolgreich gel&ouml;scht!';
	}
	 
	/**
	 * Einstellungen laden
	 */
	$config = Config::load("config");
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-cogs"></span> Cache-Einstellungen</h2>
	<p class="mask_desc">Um die Datenbank zu entlasten und gleichzeitig einen schnelleren Zugriff zu erm&ouml;glichen, verwendet das NutMouse CMS System eine simpel aufgebaute Cache-Funktion. Naben Seiteninhalten werden auch Einstellungen gecachet.</p>
	<p>Hier k&ouml;nnen Sie diese Funktion aktivieren und den Cache manuell l&ouml;schen. Auﬂerdem sehen Sie hier immer, wie viel Speicherplatz die Cache-Funktion aktuell in Anspruch nimmt.</p>
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
		$form->row->printHidden("do","saveCacheConfig");
		
		$cachesize = 0;
		$handle = opendir($cachepath);
		while($file = readdir($handle)){
			if(is_file($cachepath . $file)){
				$cachesize += filesize($cachepath . $file);
			}
		}
		$cachesize .= ' byte';
		$form->row->printHidden("",$cachesize,true,"Cache-Speicherplatz");
		
		$form->row->printEnable("Cache aktivieren", "enable_cache", $config['enable_cache']);
		$form->row->start();
			$form->element->printSubmit("Speichern");
			$form->element->printSubmitLink('<span class="icon icon-remove"></span> Cache l&ouml;schen','?do=clearCache');
		$form->row->end();
		$form->end();
	
	?>
	
</div>