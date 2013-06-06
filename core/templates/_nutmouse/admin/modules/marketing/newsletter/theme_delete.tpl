<?php
	
	$key = $_REQUEST['removeNewsletterTheme'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Newsletter-Themas
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeNewsletterTheme'){
		//Thema löschen
		if($this->_['post']['themeKey']){
			$sql->delete("bd_main_newsletter_theme",$this->_['post']);
			
			//Alle Newsletter dieses Themas lösen
			$sql->setQuery("
				UPDATE bd_main_newsletter
				SET newsletterThemeKey = NULL
				WHERE newsletterThemeKey = {{key}}
				");
			$sql->bindParam("{{key}}", $this->_['post']['themeKey'], "int");
			$sql->execute();
			
			$messages['ok'] = 'Das Thema wurde erfolgreich gel&ouml;scht!';
			
			//Übersicht ausgeben
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/overview.tpl');
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeNewsletterTheme'){
	 
		/*
		 * Thema laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_main_newsletter_theme
				WHERE themeKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$theme = $sql->result();
			
			if(!$theme['themeKey']){
				$messages['error'] = 'Newsletter konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Newsletter konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Thema wirklich l&ouml;schen?
	</h2>
	<p>Soll das Newsletter-Thema <span class="urlpath"><?php echo $theme['themeName']; ?></span> wirklich gel&ouml;scht werden? Alle dem Newsletter die diesem Thema zugeordnet sind verlieren entsprechend ihre Themenzuordnung. Dieser Vorgang kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

	<?php
	
		if(is_array($messages)){
			echo "<div class=\"mask_messages\">\n";
			foreach($messages as $msg_type => $msg_text){
				echo "\t<br class=\"clear\" />\n";
				echo "\t<div class=\"message message_{$msg_type}\"><span class=\"icon\"></span><span class=\"text\">{$msg_text}</span></div>\n";
			}
			echo "</div>\n";
		}
		
		
		$form = new Form();
		
		$form->start("?removeNewsletterTheme={$key}","post");
		
		$form->row->printHidden("do","removeNewsletterTheme");
		$form->row->printHidden("themeKey",$theme['themeKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zum Thema","?editNewsletterTheme={$key}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>