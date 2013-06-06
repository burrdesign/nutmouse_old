<?php

	$key = $_REQUEST['editContactAddress'];
	$contactKey = $_REQUEST['contactKey'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern der Adresse
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveContactAddress'){
	
		//Adresse speichern
		if($this->_['post']['addressKey'] && $this->_['post']['addressContactKey']){
			if($this->_['post']['addressKey'] == "new"){
				//Neue Adresse anlegen
				$sql->insert("bd_main_contact_address",$this->_['post']);
				$key = $sql->getLastInsertID();
				$messages['ok'] = 'Adresse erfolgreich angelegt!';
				
				//Newsletterabos speichern
				...
			} else {
				//vorhandene Adresse updaten
				$sql->update("bd_main_contact_address",$this->_['post']);
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
		
	}
	 
	/*
	 * Adresse laden
	 */
	if($messages['error']){
		$address = $this->_['post'];
	} elseif($key == "new"){
		$address['groupKey'] = "new";
		$sql->setQuery("
			SELECT contactKey FROM bd_main_contact
			WHERE contactKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$contactKey,"int");
		$res = $sql->result();
		$address['addressContactKey'] = $res['contactKey'];
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_contact_address
			WHERE addressKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$address = $sql->result();
		
		//Prüfen, ob Adresse + entsprechender Kontakt geladen werden konnte
		if(!$address['addressKey']){
			$messages['error'] = 'Adresse konnte nicht gefunden werden!';
		} elseif(!$address['addressContactKey']){
			$messages['error'] = 'Kontakt konnte nicht gefunden werden!';
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
				echo 'Neue Adresse anlegen';
			} else {
				echo 'Adresse bearbeiten';
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
		
		$form->start("?editContactAddress={$key}&contactKey={$address['addressContactKey']}","post");
		
		$form->row->printHidden("do","saveContactAddress");
		
		$form->row->printHidden("addressContactKey",$address['addressContactKey']);
		
		if($key != "new") $form->row->printHidden("addressKey",$address['addressKey'],true,"ID");
		else $form->row->printHidden("addressKey",$address['addressKey']);
		
		$form->row->printSelect("Anrede", "addressGender", $address['addressGender'], array("m","f"), array("m"=>"Herr","f"=>"Frau"));
		$form->row->printTextfield("Name", "addressName", $address['addressName'],"","width:200px;");
		$form->row->printTextfield("Nachname", "addressLastName", $address['addressLastName'],"","width:200px;");
		$form->row->start("Stra&szlig;e/Hausnr.");
			$form->element->printTextfield("addressStreet", $address['addressStreet'],"","width:200px; float:left;");
			$form->element->printTextfield("addressStreetNumber", $address['addressStreetNumber'],"","width:50px; float:left; margin-left:5px;");
		$form->row->end();
		$form->row->printTextfield("PLZ", "addressZIP", $address['addressZIP'],"","width:100px;");
		$form->row->printTextfield("Ort", "addressCity", $address['addressCity'],"","width:200px;");
		
		//Länder aus Tabelle auslesen, wenn vorhanden
		$sql->setQuery("
			SELECT * FROM bd_main_country
			WHERE countryActive = 1");
		$countries = $sql->execute();
		if(mysql_num_rows($countries) > 0){
			$form->row->printSelectFromQuery("Land", "addressCountry", $address['addressCountry'], $countries, "countryKey", "countryName");
		}
		
		$form->row->printTextfield("Telefon", "addressTel", $address['addressTel'],"","width:200px;");
		$form->row->printTextfield("Handy", "addressMobile", $address['addressMobile'],"","width:200px;");

		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeContactAddress=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zum Kontakt","?editContact={$address['addressContactKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>