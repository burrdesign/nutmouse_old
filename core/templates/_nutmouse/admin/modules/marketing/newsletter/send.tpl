<?php
	
	$key = $_REQUEST['sendNewsletter'];
	
	/*
	 * ACTIONPHASE:
	 * Versenden des Newsletters
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'sendNewsletter'){
		//Newsletter versenden
		if($this->_['post']['newsletterKey']){
			$sql->setQuery("
				SELECT * FROM bd_main_newsletter
				WHERE newsletterKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$this->_['post']['newsletterKey'],"int");
			$send = $sql->result();
			
			$sql->setQuery("
				SELECT * FROM bd_main_newsletter_to_contact
				LEFT JOIN bd_main_contact ON (contactKey = toContactKey)
				WHERE toNewsletterThemeKey = {{key}} AND contactEmail IS NOT NULL AND contactEmail > ''
				GROUP BY contactEmail
				");
			$sql->bindParam("{{key}}",$send['newsletterThemeKey'],"int");
			$contacts = $sql->execute();
			
			if(!$send['newsletterKey']){
				//wurde nicht in der DB gefunden
				$messages['error'] = 'Newsletter konnte nicht geladen werden!';
			} elseif(!$send['newsletterThemeKey']){
				//kein Thema zugeordnet
				$messages['error'] = 'Newsletter ist keinem Thema zugeordnet!';
			} elseif(mysql_num_rows($contacts) <= 0){
				//keine Empfänger
				$messages['error'] = 'Es wurden keine Empfänger gefunden!';
			} elseif(empty($send['newsletterFrom'])){
				//kein Absender
				$messages['error'] = 'Newsletter hat keinen Absender definiert!';
			} else {
				//keine Fehler => versenden beginnen
				$sql->setQuery("SELECT MAX(sendKey) AS max FROM bd_main_newsletter_send LIMIT 1");
				$max = $sql->result();
				$identkey = md5('send_newsletter_' .  $max['max']);
				
				//Anhänge laden
				$sql->setQuery("
					SELECT * FROM bd_main_newsletter_attachment
					WHERE attachmentNewsletterKey = {{key}}
					");
				$sql->bindParam("{{key}}",$send['newsletterKey'],"int");
				$attachments = $sql->execute();
				
				while($contact = mysql_fetch_array($contacts)){
					$insert = array();
					$insert['sendNewsletterKey'] = $send['newsletterKey'];
					$insert['sendContactKey'] = $contact['contactKey'];
					$insert['sendDate'] = date("Y-m-d H:i:s");
					$insert['sendIdentKey'] = $identkey;
					$insert['sendFrom'] = $send['newsletterFrom'];
					$insert['sendTo'] = $contact['contactEmail'];
					$insert['sendCc'] = $send['newsletterCc'];
					$insert['sendBcc'] = $send['newsletterBcc'];
					
					//Mail vorbereiten
					$mail = new Mail($identkey);
					$mail->addFrom($insert['sendFrom']);
					$mail->addTo($insert['sendTo']);
					$mail->addCc($insert['sendCc']);
					$mail->addBcc($insert['sendBcc']);
					$mail->setReply($send['newsletterReply']);
					
					$mail->setSubject($send['newsletterSubject']);
					$mail->setText($send['newsletterText']);
					
					while($attachment = mysql_fetch_array($attachments)){
						$filedir = $_SERVER['DOCUMENT_ROOT'] . '/core/files/newsletter/' . $send['newsletterKey'] . '/attachment/';
						$filename = $attachment['attachmentFilename'];
						$filepath = $filedir . $filename;
						$add = array(
							"filename" => $filename,
							"filepath" => $filepath
							);
						$mail->addAttachment($add);
					}
					
					//Mail versenden
					$mail->send();
					
					//Versand in die DB eintragen
					$insert['sendStatus'] = "done";
					$sql->insert("bd_main_newsletter_send", $insert);
					
					//Newsletter-Detailmaske ausgeben
					unset($_REQUEST['sendNewsletter']);
					$_REQUEST['editNewsletter'] = $key;
					$messages['ok'] = 'Newsletter wurde erfolgreich versand!';
					include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/newsletter/detail.tpl');
				}
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'sendNewsletter'){
	 
		/*
		 * Newsletter laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_main_newsletter
				WHERE newsletterKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$newsletter = $sql->result();
			
			$sql->setQuery("
				SELECT COUNT(*) AS anzahl FROM bd_main_newsletter_to_contact
				WHERE toNewsletterThemeKey = {{key}}
				");
			$sql->bindParam("{{key}}",$newsletter['newsletterThemeKey'],"int");
			$res = $sql->result();
			$tocnt = $res['anzahl'];
			
			if(!$newsletter['newsletterKey']){
				$messages['error'] = 'Newsletter konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Newsletter konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-redo-2"></span> Newsletter wirklich versenden?
	</h2>
	<p>Soll der Newsletter <span class="urlpath"><?php echo $newsletter['newsletterSubject']; ?></span> wirklich versendet werden? Der Newsletter w&uuml;rde an <?php echo (int)$tocnt; ?> Empf&auml;nger versendet werden.</p>

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
		
		$form->start("?sendNewsletter={$key}","post");
		
		$form->row->printHidden("do","sendNewsletter");
		$form->row->printHidden("newsletterKey",$newsletter['newsletterKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich versenden");
			$form->element->printSubmitLink("Zur&uuml;ck zum Newsletter","?editNewsletter={$key}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>