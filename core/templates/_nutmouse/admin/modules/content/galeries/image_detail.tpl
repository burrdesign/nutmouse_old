<?php

	$key = $_REQUEST['editGaleryImage'];
	$galerypath = 'core/files/galeries';
	
	/*
	 * ACTIONPHASE:
	 * Speichern des Bildes
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == "saveGaleryImage"){
		if($this->_['post']['imageFilename'] > ""){
			if($this->_['post']['imageFilename'] != $this->_['post']['oldImageFilename']){
				//Dateipfad wurde geändert => prüfen ob Datei bereits existiert
				$newpath = $_SERVER['DOCUMENT_ROOT'] . '/'. $galerypath . '/' . $this->_['post']['imageGaleryKey'] . '/' . $this->_['post']['imageFilename'];
				if(!is_file($newpath)){
					//Datei noch nicht vorhanden, kann also verschoben werden
					$oldpath = $_SERVER['DOCUMENT_ROOT'] . '/'. $galerypath . '/' . $this->_['post']['imageGaleryKey'] . '/' . $this->_['post']['oldImageFilename'];
					rename($oldpath,$newpath);
				} else {
					//Datei schon vorhanden
					$this->_['post']['imageFilename'] = $this->_['post']['oldImageFilename'];
					$messages['error'] = 'Die gewünschte Datei ist bereits vorhanden!';
				}
			}
			if(!$messages['error']){			
				//weitere Änderungen nur speichern, wenn noch kein Fehler aufgetreten ist
				if($_FILES['imageUpload']['name']){
					//alte Datei löschen + neue hochladen
					$fileurl = $_SERVER['DOCUMENT_ROOT'] . '/'. $galerypath . '/' . $this->_['post']['imageGaleryKey'] . '/' . $this->_['post']['imageFilename'];
					unlink($fileurl);
					move_uploaded_file($_FILES['imageUpload']['tmp_name'], $fileurl);
				}
				
				//Datenbank updaten
				$sql->update('bd_main_galery_image', $this->_['post']);
				
				$messages['ok'] = 'Die &Auml;nderungen wurden erfolgreich gespeichert!';
			}
		} else {
			//kein Dateipfad angegeben
			$messages['error'] = 'Es muss ein Datei-Name angegeben werden!';
		}
	}
	 
	/*
	 * Bild laden
	 */
	if($messages['error']){
		$image = $this->_['post'];
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_galery_image
			WHERE imageKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$image = $sql->result();
		if(!$image['imageKey']){
			$messages['error'] = 'Bild konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Bild konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> Bild bearbeiten
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
	
		$galerydir = $galerypath . '/' . $image['imageGaleryKey'];
	
		$form = new Form();
		
		$form->start("?editGaleryImage={$key}","post","multipart/form-data");
		
		$form->row->printHidden("do","saveGaleryImage");
		
		$form->row->printHidden("imageKey",$image['imageKey'],true,"ID");
		$form->row->printHidden("imageGaleryKey",$image['imageGaleryKey']);
		
		$form->row->printInfo("Dateigr&ouml;&szlig;e", filesize($_SERVER['DOCUMENT_ROOT'] . '/' . $galerydir . '/' . $image['imageFilename']) . " byte");
		
		$form->row->printHidden("oldImageFilename",$image['imageFilename']);
		$form->row->printTextfield("Dateiname", "imageFilename", $image['imageFilename'],"","","http://" . $_SERVER['SERVER_NAME'] . "/{$galerydir}/ ");
		
		$form->row->printTextfield("Bild-Titel", "imageTitle", $image['imageTitle']);

		$form->row->start("Beschreibung","","nolabel");
			$form->element->printTextarea("imageDesc",$image['imageDesc'],"wysiwyg-editor","width:100%; height:120px;");
		$form->row->end();
		
		$form->row->printUpload("Ersetzen durch","imageUpload","","","display:block; margin:3px 0 0 0;");
		$form->row->printInfo("Download", "<a href=\"http://{$_SERVER['SERVER_NAME']}/{$galerydir}/{$image['imageFilename']}\" target=\"_blank\">http://{$_SERVER['SERVER_NAME']}/{$galerydir}/{$image['imageFilename']}</a>");
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			$form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeGaleryImage=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur Galerie","?editGalery={$image['imageGaleryKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>



