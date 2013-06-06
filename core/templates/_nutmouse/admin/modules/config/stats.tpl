<?php
	$cachepath = $_SERVER['DOCUMENT_ROOT'] . '/core/cache/';

	/**
	 * ACTIONPHASE:
	 * Speichern der Einstellungen
	 */
	if($this->_['post']['do'] == 'saveStatsConfig'){
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
		
		//Config- und Stats-Cache löschen
		Cache::clearCache("config");
		Cache::clearCache("stats");
	}
	 
	/**
	 * Einstellungen laden
	 */
	$config = Config::load("config");
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-pie"></span> Statistik-Einstellungen</h2>
	<p class="mask_desc">Das System kann automatisch Statistiken &uuml;ber Besucher und Seitenzugriffe mitf&uuml;hren. Diese werden in der Datenbank gespeichert und k&ouml;nnen in der Administration eingesehen werden.</p>
	<p>Hier k&ouml;nnen Sie erweiterte Einstellungen und Filter zu diesen Statistiken festlegen. Wenn Sie keine Statistik führen wollen, weil Sie bspw. eine externe Software oder ein Plugin daf&uuml;r verwenden m&ouml;chten, k&ouml;nnen Sie die Statistik hier ebenfalls deaktivieren. Bis dato gespeicherte Daten werden dabei nicht gel&ouml;scht. Sie k&ouml;nnen die Statistik jederzeit wieder aktivieren.</p>
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
		$form->row->printHidden("do","saveStatsConfig");
		
		$form->row->printEnable("Statistiken aktivieren", "stats_enable", $config['stats_enable']);
		$form->row->printTextarea("Robot-Filter", "stats_robot_filter", $config['stats_robot_filter']);
		$form->row->printTextarea("Seiten ausschlie&szlig;en", "stats_site_filter", $config['stats_site_filter']);
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
		$form->row->end();
		$form->end();
	
	?>
	
</div>