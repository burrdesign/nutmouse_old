<?php

	$key = $_REQUEST['editContactGroup'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern der Kontaktgruppe
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveContactGroup'){
	
		//Kontaktgruppe speichern
		if($this->_['post']['groupKey']){
			if($this->_['post']['groupKey'] == "new"){
				//Neue Kontaktgruppe anlegen
				$sql->insert("bd_main_contact_group",$this->_['post']);
				$key = $sql->getLastInsertID();
				$messages['ok'] = 'Benutzergruppe erfolgreich angelegt!';
			} else {
				//vorhandene Kontaktgruppe updaten
				$sql->update("bd_main_contact_group",$this->_['post']);
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
		
	}
	 
	/*
	 * Kontaktgruppe laden
	 */
	if($messages['error']){
		$group = $this->_['post'];
	} elseif($key == "new"){
		$group['groupKey'] = "new";
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_contact_group
			WHERE groupKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$group = $sql->result();
		
		//Prüfen, ob Kontaktgruppe geladen werden konnte
		if(!$group['groupKey']){
			$messages['error'] = 'Kontaktgruppe konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Kontaktgruppe konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neue Kontaktgruppe anlegen';
			} else {
				echo 'Kontaktgruppe bearbeiten';
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
		
		$form->start("?editContactGroup={$key}","post");
		
		$form->row->printHidden("do","saveContactGroup");
		
		if($key != "new") $form->row->printHidden("groupKey",$group['groupKey'],true,"ID");
		else $form->row->printHidden("groupKey",$group['groupKey']);
		
		$form->row->printTextfield("Gruppen-Name", "groupName", $group['groupName'],"","width:200px;");

		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeContactGroup=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?page=1");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>