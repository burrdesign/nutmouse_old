<?php
	
	$key = $_REQUEST['removeContactGroup'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen der Kontaktgruppe
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeContactGroup'){
		//Kontaktgruppe löschen
		if($this->_['post']['groupKey']){
			//Prüfen, ob die Gruppe auch keine Kontakte mehr enthält
			$sql->setQuery("
				SELECT * FROM bd_main_contact
				WHERE contactGroupKey = {{key}}
				LIMIT 1");
			$sql->bindParam("{{key}}",$key,"int");
			$test = $sql->result();
			
			if($test['contactKey']){
				$messages['error'] = 'Die Gruppe enth&auml;lt noch Kontakte!';
			} else {
				$sql->delete("bd_main_contact_group",$this->_['post']);
				$messages['ok'] = 'Die Kontaktgruppe wurde erfolgreich gel&ouml;scht!';
				
				//Übersicht ausgeben
				include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/marketing/contacts/overview.tpl');
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeContactGroup'){
	 
		/*
		 * Kontaktgruppe laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_main_contact_group
				WHERE groupKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$group = $sql->result();
			
			if(!$group['groupKey']){
				$messages['error'] = 'Kontaktgruppe konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Kontaktgruppe konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Kontaktgruppe wirklich l&ouml;schen?
	</h2>
	<p>Soll der Kontaktgruppe <span class="urlpath"><?php echo $group['groupName']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang kann nicht r&uuml;ckg&auml;ngig gemacht werden! Kontaktgruppen k&ouml;nnen nur gel&ouml;scht werden, wenn Sie keine Kontakte mehr enthalten. Ordnen Sie diese also zuerst anderen Gruppen zu, bevor Sie die Gruppe l&ouml;schen.</p>

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
		
		$form->start("?removeContactGroup={$key}","post");
		
		$form->row->printHidden("do","removeContactGroup");
		$form->row->printHidden("groupKey",$group['groupKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zur Gruppe","?editContactGroup={$group['groupKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>