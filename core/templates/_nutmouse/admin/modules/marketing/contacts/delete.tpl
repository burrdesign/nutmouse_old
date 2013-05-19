<?php
	
	$key = $_REQUEST['removeContact'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Kontakt
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeContact'){
		//Kontakt löschen
		if($this->_['post']['contactKey']){
			$sql->delete("bd_main_contact",$this->_['post']);
			
			//Alle zugeordneten Adressen löschen
			$sql->setQuery("
				DELETE FROM bd_main_contact_address
				WHERE addressContactKey = {{key}}
				");
			$sql->bindParam("{{key}}", $this->_['post']['addressKey'], "int");
			$sql->execute();
			
			//Alle Newsletter-Verknüpfungen löschen
			$sql->setQuery("
				DELETE FROM bd_main_newsletter_to_contact
				WHERE toContactKey = {{key}}
				");
			$sql->bindParam("{{key}}", $this->_['post']['addressKey'], "int");
			$sql->execute();
			
			$messages['ok'] = 'Der Kontakt wurde erfolgreich gel&ouml;scht!';
			
			//Übersicht ausgeben
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/contacts/overview.tpl');
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeContact'){
	 
		/*
		 * Konatkt laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_main_contact
				WHERE contactKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$contact = $sql->result();
			
			if(!$contact['contactKey']){
				$messages['error'] = 'Kontakt konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Kontakt konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Kontakt wirklich l&ouml;schen?
	</h2>
	<p>Soll der Kontakt <span class="urlpath"><?php echo $contact['contactName'] . " " . $contact['contactLastName'] . "(#" . $contact['contactKey'] . ")"; ?></span> wirklich gel&ouml;scht werden? Alle dem Kontakt zugeordneten Adressen werden automatisch mit gel&ouml;scht. Dieser Vorgang kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeContact={$key}","post");
		
		$form->row->printHidden("do","removeContact");
		$form->row->printHidden("contactKey",$contact['contactKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zum Kontakt","?editContact={$contact['contactKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>