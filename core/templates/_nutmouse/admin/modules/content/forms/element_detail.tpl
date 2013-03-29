<?php

	$key = $_REQUEST['editFormElement'];
	$formkey = $_REQUEST['editForm'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern des Formularelements
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveMenuElement'){
		//Formularelement speichern
		if($this->_['post']['elementKey'] && $this->_['post']['elementFormKey']){
			if($this->_['post']['elementKey'] == "new"){
				//Neues Menüelement anlegen
				$sql->insert("bd_main_form_element",$this->_['post']);
				$key = $sql->getLastInsertID();
				$messages['ok'] = 'Formularelement erfolgreich angelegt!';
			} else {
				//vorhandenes Menüelement updaten
				$sql->update("bd_main_form_element",$this->_['post']);
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
				
				//Menü löschen
				Cache::clearCache("form:" . $this->_['post']['elementFormKey']);
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	 
	/*
	 * Menüelement laden
	 */
	if($messages['error']){
		$element = $this->_['post'];
	} elseif($key == "new"){
		$element['elementKey'] = "new";
		$element['elementFormKey'] = $formkey;
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_form_element
			WHERE elementKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$element = $sql->result();
		if(!$element['elementKey']){
			$messages['error'] = 'Formularelement konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Formularelement konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neues Formularelement anlegen';
			} else {
				echo 'Formularelement bearbeiten';
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
		
		$form->start("?editFormElement={$key}","post");
		
		$form->row->printHidden("do","saveMenuElement");
		
		if($key != "new") $form->row->printHidden("elementKey",$element['elementKey'],true,"ID");
		else $form->row->printHidden("elementKey",$element['elementKey']);
		$form->row->printHidden("elementFormKey",$element['elementFormKey']);
		
		$form->row->printTextfield("Position", "elementPos", $element['elementPos'],"","width:50px;");
		$form->row->printTextfield("Name", "elementName", $element['elementName'],"","width:200px;");
		$form->row->printTextfield("Label", "elementLabel", $element['elementLabel'],"","width:200px;");
		
		//verfügbare Typen ermitteln für SELECT-Auswahl
		$sql = new SqlManager();
		$sql->setQuery("SELECT * FROM bd_main_form_element_type");
		$types = $sql->execute();
		
		$form->row->printSelectFromQuery("Typ", "elementType", $element['elementType'], $types, "typeKey", "typeLabel",0);
		$form->row->printTextfield("Optionen", "elementOptions", $element['elementOptions'],"","width:200px;");
		
		$form->row->printEnable("Pflichtfeld", "elementRequired", $element['elementRequired']);
		$form->row->printEnable("Aktiv", "elementActive", $element['elementActive']);
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeFormElement=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zum Formular","?editForm={$element['elementFormKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>


