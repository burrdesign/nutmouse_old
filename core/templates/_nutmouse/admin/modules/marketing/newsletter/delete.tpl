<?php
	
	$key = $_REQUEST['removeNewsletter'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Newsletters
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeNewsletter'){
		//Newsletter löschen
		if($this->_['post']['newsletterKey']){
			$sql->delete("bd_main_newsletter",$this->_['post']);
			
			//Newsletter-Ordner löschen
			$dirpath = $_SERVER['DOCUMENT_ROOT'] . '/core/files/newsletter/' . (int)$this->_['post']['newsletterKey'] . '/';
			Lib::recursiveRmdir($dirpath);
			
			//Anhänge aus der DB löschen
			$sql->setQuery("
				DELETE FROM bd_main_newsletter_attachment
				WHERE attachmentNewsletterKey = {{key}}
				");
			$sql->bindParam("{{key}}", $this->_['post']['newsletterKey'], "int");
			$sql->execute();
			
			$messages['ok'] = 'Der Newsletter wurde erfolgreich gel&ouml;scht!';
			
			//Übersicht ausgeben
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/overview.tpl');
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeNewsletter'){
	 
		/*
		 * Newsletter laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_main_newsletter
				WHERE newsletterKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$newsletter = $sql->result();
			
			if(!$newsletter['newsletterKey']){
				$messages['error'] = 'Newsletter konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Newsletter konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Newsletter wirklich l&ouml;schen?
	</h2>
	<p>Soll der Newsletter <span class="urlpath"><?php echo $newsletter['newsletterSubject']; ?></span> wirklich gel&ouml;scht werden? Alle dem Newsletter zugeordneten Anh&auml;nge werden automatisch mit gel&ouml;scht. Sie sollten also vorher sicher stellen, dass Sie nirgendwo mehr auf die Dateien verweisen! Dieser Vorgang kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeNewsletter={$key}","post");
		
		$form->row->printHidden("do","removeNewsletter");
		$form->row->printHidden("newsletterKey",$newsletter['newsletterKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zum Newsletter","?editNewsletter={$key}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>