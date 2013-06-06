<?php

	$key = $_REQUEST['editNewsletterAttachment'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern des Anhangs
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveNewsletterAttachment'){
	
		echo "<pre>";
		print_r($FILES);
		echo "</pre>";
	
		//Anhang speichern
		if($this->_['post']['attachmentNewsletterKey'] && $this->_['post']['attachmentKey']){
			$dirpath = $_SERVER['DOCUMENT_ROOT'] . '/core/files/newsletter/' . $this->_['post']['attachmentNewsletterKey'] . '/attachment/';
			if($this->_['post']['attachmentKey'] == "new"){
				if(empty($this->_['post']['attachmentFilename'])){
					$this->_['post']['attachmentFilename'] = $_FILES['attachmentUpload']['name'];
				}
				if(!is_file($dirpath . $this->_['post']['attachmentFilename'])){
					//Neuen Anhang anlegen
					$sql->insert("bd_main_newsletter_attachment",$this->_['post']);
					$key = $sql->getLastInsertID();
					
					//...und auf den Server laden
					if($_FILES['attachmentUpload']['tmp_name']){
						$filepath = $dirpath . $this->_['post']['attachmentFilename'];
						move_uploaded_file($_FILES['attachmentUpload']['tmp_name'], $filepath);
					}
					
					$messages['ok'] = 'Anhang erfolgreich hinzugef&uuml;gt!';
				} else {
					//Datei mit diesem Namen bereits vorhanden
					$messages['error'] = 'Datei mit diesem Dateinamen bereits vorhanden!';
				}
			} else {
				//vorhandenen Anhang updaten
				if(empty($this->_['post']['attachmentFilename'])){ 
					$this->_['post']['attachmentFilename'] = $_FILES['attachmentUpload']['name'];
				}
				if(empty($this->_['post']['attachmentFilename'])){
					//Kein Dateiname angegeben
					$messages['error'] = 'Es muss ein Dateiname angegeben werden!';
				} else {
				
					if($this->_['post']['attachmentFilename'] != $this->_['post']['attachmentOldFilename']){
						if(is_file($dirpath . $this->_['post']['attachmentFilename'])){
							//Datei mit diesem Namen bereits vorhanden
							$messages['error'] = 'Datei mit diesem Dateinamen bereits vorhanden!';
						} else {
							//Datei umbenennen
							rename($dirpath . $this->_['post']['attachmentOldFilename'], $dirpath . $this->_['post']['attachmentFilename']);
						}
					} 	
					
					if(!$messages['error']){
						//Nur wenn keine Fehler aufgetreten sind
						$sql->update("bd_main_newsletter_attachment",$this->_['post']);
						if($_FILES['attachmentUpload']['tmp_name']){
							//alte Datei löschen + neue hochladen
							$filepath = $dirpath . $this->_['post']['attachmentFilename'];
							unlink($filepath);
							move_uploaded_file($_FILES['attachmentUpload']['tmp_name'], $filepath);
						}
						$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
					}
					
				}
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
		
	}
	 
	/*
	 * Anhang laden
	 */
	if($messages['error']){
		$attachment = $this->_['post'];
	} elseif($key == "new"){
		$attachment['attachmentKey'] = "new";
		$attachment['attachmentNewsletterKey'] = $_REQUEST['newsletterKey'];
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_newsletter_attachment
			WHERE attachmentKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$attachment = $sql->result();
		
		//Prüfen, ob Anhang geladen werden konnte
		if(!$attachment['attachmentKey']){
			$messages['error'] = 'Anhang konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Anhang konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neuen Anhang anlegen';
			} else {
				echo 'Anhang bearbeiten';
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
		
		$form->start("?editNewsletterAttachment={$key}newsletterKey={$attachment['attachmentNewsletterKey']}","post","multipart/form-data");
		
		$form->row->printHidden("do","saveNewsletterAttachment");
		$form->row->printHidden("attachmentNewsletterKey",$attachment['attachmentNewsletterKey']);
		
		$form->row->printHidden("attachmentOldFilename",$attachment['attachmentFilename']);
		
		if($key != "new") $form->row->printHidden("attachmentKey",$attachment['attachmentKey'],true,"ID");
		else $form->row->printHidden("attachmentKey",$attachment['attachmentKey']);
		
		$form->row->printUpload("Anhang", "attachmentUpload", "", "", "", "TEST");
		$form->row->printTextfield("Dateiname", "attachmentFilename", $attachment['attachmentFilename'],"","width:200px;");
		
		//Dateiinfos ausgeben
		$filepath = $_SERVER['DOCUMENT_ROOT'] . '/core/files/newsletter/' . $attachment['attachmentNewsletterKey'] . '/attachment/' . $attachment['attachmentFilename'];
		
		if($key != "new"){
			if(!is_file($filepath)){
				$form->row->printInfo("Fehler", "Datei konnte nicht geladen werden!");
			} else {
				$form->row->printInfo("Dateigr&ouml;&szlig;e", filesize($filepath) . ' byte');
				$form->row->printInfo("Dateityp", mime_content_type($filepath));
				$form->row->printInfo("Letzte &Auml;nderung", date("D, j. M Y",filemtime($filepath)));
				$form->row->printInfo("Dateipfad","/core/files/newsletter/{$attachment['attachmentNewsletterKey']}/attachment/{$attachment['attachmentFilename']}");
			}
		}
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeNewsletterAttachment={$key}", "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zum Newsletter","?editNewsletter={$attachment['attachmentNewsletterKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>