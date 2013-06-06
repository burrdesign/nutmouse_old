<?php

	$key = $_REQUEST['editNewsletter'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern des Newsletters
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveNewsletter'){
	
		//Newsletter speichern
		if($this->_['post']['newsletterKey']){
			if($this->_['post']['newsletterKey'] == "new"){
				//Neuen Newsletter anlegen
				$sql->insert("bd_main_newsletter",$this->_['post']);
				$key = $sql->getLastInsertID();
				if(!is_dir($_SERVER['DOCUMENT_ROOT'] . '/core/files/newsletter/')){
					mkdir($_SERVER['DOCUMENT_ROOT'] . '/core/files/newsletter/');
				}
				mkdir($_SERVER['DOCUMENT_ROOT'] . "/core/files/newsletter/{$key}/");
				mkdir($_SERVER['DOCUMENT_ROOT'] . "/core/files/newsletter/{$key}/attachment/");
				
				if($_FILES['newsletterThumbnail']['tmp_name']){
					//Thumbnail hochladen
					$dirpath = $_SERVER['DOCUMENT_ROOT'] . "/core/files/newsletter/{$key}/";
					$filepath = $dirpath . "thumbnail.img";
					if(is_file($filepath)) unlink($filepath);
					move_uploaded_file($_FILES['newsletterThumbnail']['tmp_name'], $filepath);
				}
				
				$messages['ok'] = 'Newsletter erfolgreich angelegt!';
			} else {
				//vorhandenen Newsletter updaten
				$sql->update("bd_main_newsletter",$this->_['post']);
				
				if($_FILES['newsletterThumbnail']['tmp_name']){
					//Thumbnail hochladen
					$dirpath = $_SERVER['DOCUMENT_ROOT'] . "/core/files/newsletter/{$key}/";
					$filepath = $dirpath . "thumbnail.img";
					if(is_file($filepath)) unlink($filepath);
					move_uploaded_file($_FILES['newsletterThumbnail']['tmp_name'], $filepath);
				}
				
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
		
	}
	 
	/*
	 * Newsletter laden
	 */
	if($messages['error']){
		$newsletter = $this->_['post'];
	} elseif($key == "new"){
		$newsletter['newsletterKey'] = "new";
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_newsletter
			WHERE newsletterKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$newsletter = $sql->result();
		
		//Prüfen, ob Newsletter geladen werden konnte
		if(!$newsletter['newsletterKey']){
			$messages['error'] = 'Newsletter konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Newsletter konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neuen Newsletter anlegen';
			} else {
				echo 'Newsletter bearbeiten';
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
		
		$form->start("?editNewsletter={$key}","post","multipart/form-data");
		
		$form->row->printHidden("do","saveNewsletter");
		
		if($key != "new") $form->row->printHidden("newsletterKey",$newsletter['newsletterKey'],true,"ID");
		else $form->row->printHidden("newsletterKey",$newsletter['newsletterKey']);
		
		$form->row->printTextfield("Veröffentlichen am", "newsletterDate", $newsletter['newsletterDate'],"datetime");
		$form->row->printTextfield("Betreff", "newsletterSubject", $newsletter['newsletterSubject'],"","width:200px;");

		//verfügbare Themen ermitteln für SELECT-Auswahl
		$sql = new SqlManager();
		$sql->setQuery("SELECT * FROM bd_main_newsletter_theme");
		$themes = $sql->execute();
		
		if(mysql_num_rows($themes) > 0){
			$form->row->printSelectFromQuery("Thema", "newsletterThemeKey", $newsletter['newsletterThemeKey'], $themes, "themeKey", "themeName", true);
		}
		
		if($key != "new"){
			//verknüpfte Anhänge ausgeben
			$form->row->start("Anh&auml;nge");
			
				$sql->setQuery("
					SELECT * FROM bd_main_newsletter_attachment 
					WHERE attachmentNewsletterKey = {{key}}");
				$sql->bindParam("{{key}}", $key, "int");
				$attachments = $sql->execute();
				
				echo "<div class=\"mask_table mask_inner_table\">";
				if(mysql_num_rows($attachments) <= 0){
					echo "<p><i>kein Anhang gefunden!</i></p>";
					$form->element->printSubmitLink("<span class=\"icon icon-attachment\"></span> Neuen Anhang hinzuf&uuml;gen","?editNewsletterAttachment=new&newsletterKey={$key}");
				} else {				
					echo "\t<table class=\"list list_addresses list_filter\" cellpadding=0 cellspacing=0>\n";
					while($attachment = mysql_fetch_array($attachments)){
						echo "
							\t\t<tr class=\"\">\n
							\t\t\t<td class=\"first filename\">{$attachment['attachmentFilename']}</td>\n
						\t\t\t<td class=\"action\"><a href=\"?editNewsletterAttachment={$attachment['attachmentKey']}&contactKey={$key}\" class=\"icon icon-pencil\" title=\"Anhang bearbeiten\"></a></td>\n
							\t\t\t<td class=\"action\"><a href=\"?removeNewsletterAttachment={$attachment['attachmentKey']}&newsletterKey={$key}\" class=\"icon icon-cancel-circle\" title=\"Anhang l&ouml;schen\"></a></td>\n
							\t\t</tr>\n";
							$class = '';
					}
					echo "\t</table>\n";
					$form->element->printSubmitLink("<span class=\"icon icon-attachment\"></span> Neuen Anhang hinzuf&uuml;gen","?editNewsletterAttachment=new&newsletterKey={$key}","","","clear:both;");
				}
				echo "</div>";
			
			$form->row->end();
		}
		
		$form->row->printEmailfield("Absender", "newsletterFrom", $newsletter['newsletterFrom'],"","width:200px;");
		$form->row->printEmailfield("Antwort an", "newsletterReply", $newsletter['newsletterReply'],"","width:200px;");
		
		$form->row->start("Inhalt","","nolabel");
			$form->element->printTextarea("newsletterText",$newsletter['newsletterText'],"wysiwyg-editor","width:100%; height:250px;");
		$form->row->end();
		
		$form->row->printEmailfield("CC an", "newsletterCc", $newsletter['newsletterCc'],"","width:200px;");
		$form->row->printEmailfield("BCC an", "newsletterBcc", $newsletter['newsletterBcc'],"","width:200px;");
		$form->row->printEmailfield("Referer", "newsletterReferer", $newsletter['newsletterReferer'],"","width:200px;");
		//$label, $inputname, $inputvalue, $inputclass="", $inputstyle="", $pretext="", $posttext="", $multiple=0
		
		$form->row->start("Thumbnail");
		$form->element->printUpload("newsletterThumbnail","","","float:left; margin:2px 0;");
		if($key != "new" && is_file($_SERVER['DOCUMENT_ROOT'] . "/core/files/newsletter/{$key}/thumbnail.img")){
			$form->element->printSubmitLink("<span class='icon icon-image'></span>", "/core/files/newsletter/{$key}/thumbnail.img", "_blank", "input_action_icon input_action_icon_image", "float:left; margin:0 5px;");
		}
		$form->row->end();
		
		if($key != "new"){
			/*Testversand
			$form->row->start("Testversand");
				$testform = new Form();
				$testform->start("?editNewsletter={$key}","post");
				$testform->element->printHidden("do","sendNewsletterTest");
				$testform->element->printTextfield("testTo","","","float:left;");
				$testform->element->printSubmit("Test senden","","","margin:0 0 0 5px;");
				$testform->end();
			$form->row->end();*/
		}
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new"){ 
				$form->element->printSubmitLink("<span class=\"icon icon-redo-2 \"></span> Versenden","?sendNewsletter={$key}");
				$form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeNewsletter={$key}", "", "", "margin-right:30px;");
			}
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?page=1");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>