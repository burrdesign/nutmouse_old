<?php

	$key = $_REQUEST['editUser'];
	$groupkey = $_REQUEST['userGroup'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern des Benutzers
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveUser'){
	
		//Benutzer speichern
		if($this->_['post']['adminKey']){
			if(!$this->_['post']['adminLogin']){
				$messages['error'] = 'Es muss ein Login angegeben werden!';
			} else {
				if($this->_['post']['adminKey'] == "new"){
					if(!$this->_['post']['adminPassword']){
						$messages['error'] = 'Es muss ein Passwort angegeben werden!';
					} else {
						//Prüfen ob Login bereits verwendet wird
						$sql->setQuery("
							SELECT * FROM bd_sys_admin_user
							WHERE adminLogin = '{{login}}'
							LIMIT 1");
						$sql->bindParam("{{login}}", $this->_['post']['adminLogin']);
						$test = $sql->result();
						if($test['adminKey']){
							$messages['error'] = "Der Login wird bereits verwendet!";
						} else {
							//Neuen Benutzer anlegen
							$this->_['post']['adminPassword'] = md5($this->_['post']['adminPassword']);
							$sql->insert("bd_sys_admin_user",$this->_['post']);
							$key = $sql->getLastInsertID();
							$messages['ok'] = 'Benutzer erfolgreich angelegt!';
						}
					}
				} else {
					//Prüfen, ob Login verändert wurde
					if($this->_['post']['adminLogin'] != $this->_['post']['adminLoginOld']){
						$sql->setQuery("
							SELECT * FROM bd_sys_admin_user
							WHERE adminLogin = '{{login}}'
							LIMIT 1");
						$sql->bindParam("{{login}}", $this->_['post']['adminLogin']);
						$test = $sql->result();
						if($test['adminKey']){
							$messages['error'] = "Der Login wird bereits verwendet!";
						}
					}
					if(!$messages['error']){
						//vorhandenen Benutzer updaten
						if(!empty($this->_['post']['adminPassword'])){
							$this->_['post']['adminPassword'] = md5($this->_['post']['adminPassword']);
						} else {
							unset($this->_['post']['adminPassword']);
						}
						$sql->update("bd_sys_admin_user",$this->_['post']);
						$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
					}
				}
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
		
	}
	 
	/*
	 * Benutzer laden
	 */
	if($messages['error']){
		$user = $this->_['post'];
	} elseif($key == "new"){
		$user['adminKey'] = "new";
		$user['adminGroupKey'] = $groupkey;
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_sys_admin_user
			WHERE adminKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$user = $sql->result();
		
		//Prüfen, ob Benutzer geladen werden konnte
		if(!$user['adminKey']){
			$messages['error'] = 'Benutzer konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Benutzer konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neuen Benutzer anlegen';
			} else {
				echo 'Benutzer bearbeiten';
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
		
		$form->start("?editUser={$key}","post");
		
		$form->row->printHidden("do","saveUser");
		$form->row->printHidden("adminLoginOld",$user['adminLogin']);
		
		if($key != "new") $form->row->printHidden("adminKey",$user['adminKey'],true,"ID");
		else $form->row->printHidden("adminKey",$user['adminKey']);
		
		$form->row->printTextfield("Login", "adminLogin", $user['adminLogin'],"","width:200px;");
		if($key != "new") $form->row->printTextfield("Passwort &auml;ndern", "adminPassword", "","","width:200px;");
		else $form->row->printTextfield("Passwort", "adminPassword", "","","width:200px;");
		
		//verfügbare Benutzergruppen ermitteln für SELECT-Auswahl
		$sql = new SqlManager();
		$sql->setQuery("SELECT * FROM bd_sys_admin_group");
		$groups = $sql->execute();
		
		$form->row->printSelectFromQuery("Benutzergruppe", "adminGroupKey", $user['adminGroupKey'], $groups, "groupKey", "groupName", false);
		
		if($user['adminLastLogin']) $form->row->printInfo("Letzter Login", date("D, j. M Y", strtotime($user['adminLastLogin'])));
		
		$form->row->printTextfield("Name", "adminName", $user['adminName'],"","width:200px;");
		$form->row->printTextfield("Nachname", "adminLastName", $user['adminLastName'],"","width:200px;");

		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeUser=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?page=1");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>