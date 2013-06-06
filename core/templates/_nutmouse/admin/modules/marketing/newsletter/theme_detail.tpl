<?php

	$key = $_REQUEST['editNewsletterTheme'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern des Newsletter-Themas
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveNewsletterTheme'){
	
		//Thema speichern
		if($this->_['post']['themeKey']){
			if($this->_['post']['themeKey'] == "new"){
				//Neues Thema anlegen
				$sql->insert("bd_main_newsletter_theme",$this->_['post']);
				$key = $sql->getLastInsertID();
				$messages['ok'] = 'Thema erfolgreich angelegt!';
			} else {
				//vorhandenes Thema updaten
				$sql->update("bd_main_newsletter_theme",$this->_['post']);
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
		
	}
	 
	/*
	 * Thema laden
	 */
	if($messages['error']){
		$theme = $this->_['post'];
	} elseif($key == "new"){
		$theme['themeKey'] = "new";
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_newsletter_theme
			WHERE themeKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$theme = $sql->result();
		
		//Prüfen, ob Thema geladen werden konnte
		if(!$theme['themeKey']){
			$messages['error'] = 'Thema konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Thema konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neues Thema anlegen';
			} else {
				echo 'Thema bearbeiten';
			}
		?>
	</h2>
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
		
		$form->start("?editNewsletterTheme={$key}","post");
		
		$form->row->printHidden("do","saveNewsletterTheme");
		
		if($key != "new") $form->row->printHidden("themeKey",$theme['themeKey'],true,"ID");
		else $form->row->printHidden("themeKey",$theme['themeKey']);
		
		$form->row->printTextfield("Themen-Name", "themeName", $theme['themeName'],"","width:200px;");
		$form->row->printTextarea("Beschreibung", "themeDesc", $theme['themeDesc']);
		
		if($key != "new"){
			//Anzahl der Themen-Abonnenten ermitteln
			$sql->setQuery("
				SELECT * FROM bd_main_newsletter_to_contact
				WHERE toNewsletterThemeKey = {{key}}
				");
			$sql->bindParam("{{key}}", $key);
			$abo = $sql->execute();
			
			$form->row->printInfo("Abonnenten", (int)mysql_num_rows($abo));
		}

		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeNewsletterTheme=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?page=1");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>