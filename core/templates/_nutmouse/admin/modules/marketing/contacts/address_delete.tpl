<?php
	
	$key = $_REQUEST['removeContactAddress'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen der Adresse
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeContactAddress'){
		//Adresse löschen
		if($this->_['post']['addressKey']){
			$sql->delete("bd_main_contact_address",$this->_['post']);
			$messages['ok'] = 'Die Adresse wurde erfolgreich gel&ouml;scht!';
			
			//Kontakt ausgeben
			$_REQUEST['editContact'] = $this->_['post']['addressContactKey'];
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/contacts/detail.tpl');
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeContactAddress'){
	 
		/*
		 * Adresse laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_main_contact_address
				WHERE addressKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$address = $sql->result();
			
			if(!$address['addressKey']){
				$messages['error'] = 'Addresse konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Adresse konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Adresse wirklich l&ouml;schen?
	</h2>
	<p>Soll die Adresse <span class="urlpath">#<?php echo $address['addressKey']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeContactAddress={$key}&contactKey={$address['addressContactKey']}","post");
		
		$form->row->printHidden("do","removeContactAddress");
		$form->row->printHidden("addressKey",$address['addressKey']);
		$form->row->printHidden("addressContactKey",$address['addressContactKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zum Kontakt","?editContact={$address['addressContactKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>