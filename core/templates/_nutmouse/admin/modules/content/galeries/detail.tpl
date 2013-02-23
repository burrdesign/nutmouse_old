<?php

	$key = $_REQUEST['editGalery'];
	$galerypath = 'core/files/galeries';
	$galerydir = $galerypath . '/' . $key;
	
	/*
	 * ACTIONPHASE:
	 * Speichern der Galerie
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveGalery'){
	
		//Galerie speichern
		if($this->_['post']['galeryKey']){
			if($this->_['post']['galeryKey'] == "new"){
				//Neue Galerie anlegen
				$this->_['post']['galeryCreated'] = date("Y-m-d H:i:s", time());
				$sql->insert("bd_main_galery",$this->_['post']);
				$key = $sql->getLastInsertID();
				mkdir($_SERVER['DOCUMENT_ROOT'] . '/' . $galerypath . '/' . $key);
				$messages['ok'] = 'Bildergalerie erfolgreich angelegt!';
			} else {
				//vorhandene Galerie updaten
				$sql->update("bd_main_galery",$this->_['post']);
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
		
	} elseif($this->_['post']['do'] == 'uploadImages'){
	
		$filecnt = 0;
		
		//Bilder hochladen
		for($i=0;$i<count($_FILES['uploadImages']['name']);$i++){
			$fileurl = $_SERVER['DOCUMENT_ROOT'] . '/' . $galerydir . '/' . $_FILES['uploadImages']['name'][$i];
			
			if(!is_file($fileurl)){			
				$insert = array();
				$insert['imageGaleryKey'] = $key;
				$insert['imageCreated'] = date("Y-m-d H:i:s", time());
				$insert['imageFilename'] = $_FILES['uploadImages']['name'][$i];
				$sql->insert("bd_main_galery_image",$insert);
				move_uploaded_file($_FILES['uploadImages']['tmp_name'][$i], $fileurl);
				if(is_file($fileurl)){
					$filecnt++;
				} else {
					$messages['error'] = 'Es ist ein Fehler aufgetreten!';
				}
			} else {
				$messages['error'] = 'Bildname ist bereits vorhanden!';
			}
		}
		if($filecnt > 0){
			$messages['ok'] = "{$filecnt} Bilder wurden erfolgreich hochgeladen!";
		}
		
	}
	 
	/*
	 * Galerie laden
	 */
	if($messages['error']){
		$galery = $this->_['post'];
	} elseif($key == "new"){
		$galery['galeryKey'] = "new";
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_galery
			WHERE galeryKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$galery = $sql->result();
		if(!$galery['galeryKey']){
			$messages['error'] = 'Bildergalerie konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Bildergalerie konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neue Bildergalerie anlegen';
			} else {
				echo 'Galerie und Bilder bearbeiten';
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
		
		$form->start("?editGalery={$key}","post");
		
		$form->row->printHidden("do","saveGalery");
		
		if($key != "new") $form->row->printHidden("galeryKey",$galery['galeryKey'],true,"ID");
		else $form->row->printHidden("galeryKey",$galery['galeryKey']);
		
		$form->row->printTextfield("Datum", "galeryDate", $galery['galeryDate'],"","width:200px;");
		$form->row->printTextfield("Galerie-Titel", "galeryTitle", $galery['galeryTitle'],"","width:200px;");

		$form->row->start("Beschreibung","","nolabel");
			$form->element->printTextarea("galeryDesc",$galery['galeryDesc'],"wysiwyg-editor","width:100%; height:120px;");
		$form->row->end();
		
		$form->row->printEnable("Aktiv", "galeryActive", $galery['galeryActive']);
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeGalery=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?page=1");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>


<div class="mask_table" style="margin-top:30px; width:100%; float:left;">

	<?php
	
		if($key != "new"){
			//Bilder laden
			$sql->setQuery("
				SELECT * FROM bd_main_galery_image
				WHERE imageGaleryKey = {{key}}
				ORDER BY imagePos
				");
			$sql->bindParam("{{key}}",$key,"int");
			$imagequery = $sql->execute();
			
			//Elemente ausgeben
			if(mysql_num_rows($imagequery) == 0){
				echo "<p><i>Es wurden keine Bilder gefunden!</i></p>\n";
			} else {
				echo "\t<table class=\"list list_menus\" cellpadding=0 cellspacing=0>\n";
				while($image = mysql_fetch_array($imagequery)){
					$filepath = $_SERVER['DOCUMENT_ROOT'] . '/' . $galerydir . '/' . $image['imageFilename'];
					
					if(!is_file($filepath)){
						//keine Datei zum Datensatz gefunden!
						continue;
					}
				
					echo "
						\t\t<tr class=\"\">\n
						\t\t\t<td class=\"first filename\">{$image['imageFilename']}</td>\n
						\t\t\t<td class=\"title hide_1050\">{$image['imageTitle']}</td>\n
						\t\t\t<td class=\"date width_120 font_small hide_650 align_center\">" . date("D, j. M Y", strtotime($image['imageCreated'])) . "</td>\n
						\t\t\t<td class=\"active width_90 font_small hide_650 align_right\">" . filesize($filepath) . " byte</td>\n
						\t\t\t<td class=\"action\"><a href=\"?editGaleryImage={$image['imageKey']}\" class=\"icon icon-pencil\" title=\"Bild bearbeiten\"></a></td>\n
						\t\t\t<td class=\"action\"><a href=\"?removeGaleryImage={$image['imageKey']}\" class=\"icon icon-cancel-circle\" title=\"Bild l&ouml;schen\"></a></td>\n
						\t\t</tr>\n";
				}
				echo "\t</table>\n";
			}
				
			//Neue Datei hochladen
			$form->start("?editGalery={$key}","post","multipart/form-data");
			
			$form->row->printHidden("do","uploadImages");
			$form->row->start();
				$form->element->printUpload("uploadImages[]","","","float:left; margin:10px 10px 5px 0;","","",1);
				$form->element->printSubmit("Bild(er) hochladen","","","margin:10px 0 0 0;");
			$form->row->end();
			
			$form->end();
		}
	
	?>
	
</div>



