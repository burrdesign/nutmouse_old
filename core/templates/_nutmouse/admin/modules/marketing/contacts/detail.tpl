<?php

	$key = $_REQUEST['editContact'];
	$groupkey = $_REQUEST['contactGroupKey'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern des Kontakts
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveContact'){
	
		//Kontakt speichern
		if($this->_['post']['contactKey']){
			if($this->_['post']['contactKey'] == "new"){
				//Prüfen ob Login bereits verwendet wird
				$sql->setQuery("
					SELECT * FROM bd_main_contact
					WHERE contactLogin = '{{login}}'
					LIMIT 1");
				$sql->bindParam("{{login}}", $this->_['post']['contactLogin']);
				$test = $sql->result();
				if($test['contactKey']){
					$messages['error'] = "Der Login wird bereits verwendet!";
				} else {
					//Neuen Kontakt anlegen
					if(!empty($this->_['post']['contactPassword'])){
						$this->_['post']['contactPassword'] = md5($this->_['post']['contactPassword']);
					} else {
						unset($this->_['post']['contactPassword']);
					}
					$this->_['post']['contactCreated'] = date("Y-m-d H:i:s", time());
					$this->_['post']['contactLastChanged'] = date("Y-m-d H:i:s", time());
					$sql->insert("bd_main_contact",$this->_['post']);
					$key = $sql->getLastInsertID();
					$messages['ok'] = 'Kontakt erfolgreich angelegt!';
				}
			} else {
				//Prüfen, ob Login verändert wurde
				if($this->_['post']['contactLogin'] != $this->_['post']['contactLoginOld']){
					$sql->setQuery("
						SELECT * FROM bd_main_contact
						WHERE contactLogin = '{{login}}'
						LIMIT 1");
					$sql->bindParam("{{login}}", $this->_['post']['contactLogin']);
					$test = $sql->result();
					if($test['contactKey']){
						$messages['error'] = "Der Login wird bereits verwendet!";
					}
				}
				if(!$messages['error']){
					//vorhandenen Kontakt updaten
					if(!empty($this->_['post']['contactPassword'])){
						$this->_['post']['contactPassword'] = md5($this->_['post']['contactPassword']);
					} else {
						unset($this->_['post']['contactPassword']);
					}
					$this->_['post']['contactLastChanged'] = date("Y-m-d H:i:s", time());
					$sql->update("bd_main_contact",$this->_['post']);
					$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
				}
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
		
	}
	 
	/*
	 * Kontakt laden
	 */
	if($messages['error']){
		$contact = $this->_['post'];
	} elseif($key == "new"){
		$contact['contactKey'] = "new";
		$contact['contactGroupKey'] = $groupkey;
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_contact
			WHERE contactKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$contact = $sql->result();
		
		//Prüfen, ob Kontakt geladen werden konnte
		if(!$contact['contactKey']){
			$messages['error'] = 'Kontakt konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Kontakt konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neuen Kontakt anlegen';
			} else {
				echo 'Kontakt bearbeiten';
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
		
		$form->start("?editContact={$key}","post");
		
		$form->row->printHidden("do","saveContact");
		$form->row->printHidden("contactLoginOld",$contact['contactLogin']);
		
		if($key != "new") $form->row->printHidden("contactKey",$contact['contactKey'],true,"ID");
		else $form->row->printHidden("contactKey",$contact['contactKey']);
		
		$form->row->printTextfield("Name", "contactName", $contact['contactName'],"","width:200px;");
		$form->row->printTextfield("Nachname", "contactLastName", $contact['contactLastName'],"","width:200px;");
		
		//verfügbare Kontaktgruppen ermitteln für SELECT-Auswahl
		$sql = new SqlManager();
		$sql->setQuery("SELECT * FROM bd_main_contact_group");
		$groups = $sql->execute();
		
		if(mysql_num_rows($groups) > 0){
			$form->row->printSelectFromQuery("Kontaktgruppe", "contactGroupKey", $contact['contactGroupKey'], $groups, "groupKey", "groupName", true);
		}
		
		$form->row->printTextfield("Email", "contactEmail", $contact['contactEmail'],"","width:200px;");
		$form->row->printTextfield("Website", "contactWebsite", $contact['contactWebsite'],"","width:200px;");
		
		if($key != "new"){
			//verknüpfte Adressen ausgeben
			$form->row->start("Adresse(n)");
			
				$sql->setQuery("
					SELECT * FROM bd_main_contact_address 
					WHERE addressContactKey = {{key}}");
				$sql->bindParam("{{key}}", $key, "int");
				$addresses = $sql->execute();
				
				echo "<div class=\"mask_table mask_inner_table\">";
				if(mysql_num_rows($addresses) <= 0){
					echo "<p><i>keine Adressen zugewiesen!</i></p>";
					$form->element->printSubmitLink("Neue Adresse hinzuf&uuml;gen","?editContactAddress=new&contactKey={$key}");
				} else {				
					echo "\t<table class=\"list list_addresses list_filter\" cellpadding=0 cellspacing=0>\n";
					while($address = mysql_fetch_array($addresses)){
						echo "
							\t\t<tr class=\"\">\n
							\t\t\t<td class=\"first key\">{$address['addressKey']}</td>\n
							\t\t\t<td class=\"address\">";
						echo $address['addressName'] . ' ' . $address['addressLastName'] . '<br>';
						echo $address['addressStreet'] . ' ' . $address['addressStreetNumber'] . '<br>';
						echo $address['addressZIP'] . ' ' . $address['addressCity'] . '<br>';
						$country = $sql->get("bd_main_country", "countryKey", $address['addressCountry']);
						echo $country['countryName'];
						echo "</td>
						\t\t\t<td class=\"action\"><a href=\"?editContactAddress={$address['addressKey']}&contactKey={$key}\" class=\"icon icon-pencil\" title=\"Adresse bearbeiten\"></a></td>\n
							\t\t\t<td class=\"action\"><a href=\"?removeContactAddress={$address['addressKey']}&contactKey={$key}\" class=\"icon icon-cancel-circle\" title=\"Adresse l&ouml;schen\"></a></td>\n
							\t\t</tr>\n";
							$class = '';
					}
					echo "\t</table>\n";
					$form->element->printSubmitLink("Neue Adresse hinzuf&uuml;gen","?editContactAddress=new&contactKey={$key}","","","clear:both;");
				}
				echo "</div>";
			
			$form->row->end();
			
			//TODO: Newsletter-Themen ausgeben
		}
		
		$form->row->printTextfield("Login", "contactLogin", $contact['contactLogin'],"","width:200px;");
		if($key != "new") $form->row->printTextfield("Passwort &auml;ndern", "contactPassword", "","","width:200px;");
		else $form->row->printTextfield("Passwort", "adminPassword", "","","width:200px;");

		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeContact={$key}", "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?page=1");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>