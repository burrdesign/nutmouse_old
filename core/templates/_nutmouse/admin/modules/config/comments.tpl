<?php
	$cachepath = $_SERVER['DOCUMENT_ROOT'] . '/core/cache/';

	/**
	 * ACTIONPHASE:
	 * Speichern der Einstellungen
	 */
	if($this->_['post']['do'] == 'saveCommentConfig'){
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
		Cache::clearCache("config");
	}
	 
	/**
	 * Einstellungen laden
	 */
	$config = Config::load("config");
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-bubbles "></span> Kommentar-Einstellungen</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie die Kommentarfunktion des Systems konfigurieren. Kommentare k&ouml;nnen f&uuml;r unterschiedliche Systembereiche wie Neuigkeiten, Bildergalerien oder Bilder verwendet werden.</p>
	<p>Neben der M&ouml;glichkeit Kommentare ganz zu deaktivieren k&ouml;nnen Sie hier weitere M&ouml;glichkeiten bzgl. der Kontrolle und Einblendung von Kommentaren festlegen.</p>
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
		$form->row->printHidden("do","saveCommentConfig");
		
		$form->row->start("Funktion aktivieren");
			$form->element->printEnable("comments_news_enable", $config['comments_news_enable'], 1, 0,"", "", "<div style=\"clear:both;\">", "<span style=\"float:left; margin:5px 0 0 5px;\">Neuigkeiten</span></div>");
			$form->element->printEnable("comments_galeries_enable", $config['comments_galeries_enable'], 1, 0,"", "", "<div style=\"clear:both;\">", "<span style=\"float:left; margin:5px 0 0 5px;\">Bildergalerien</span></div>");
			$form->element->printEnable("comments_images_enable", $config['comments_images_enable'], 1, 0,"", "", "<div style=\"clear:both;\">", "<span style=\"float:left; margin:5px 0 0 5px;\">Bilder</span></div>");
		$form->row->end();
		
		$form->row->printEnable("Einzeln einstellbar", "comments_config_individuell", $config['comments_config_individuell']);
		$form->row->printEnable("Prüfung aktivieren", "comments_controle", $config['comments_controle']);
		
		$captchas = array("none","image","maths");
		$labels = array("none"=>"- kein Captcha -", "image"=>"Bild-Captcha", "maths"=>"Rechenaufgabe");
		$form->row->printSelect("Captcha", "comments_captcha", $config['comments_captcha'], $captchas, $labels);
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
		$form->row->end();
		$form->end();
	
	?>
	
</div>