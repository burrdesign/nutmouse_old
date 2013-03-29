<?php
	
	$key = $_REQUEST['removeFormElement'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Formularelements
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeFormElement'){
		//Formularelement löschen
		if($this->_['post']['elementKey']){
		
			$sql->delete("bd_main_form_element",$this->_['post']);
			
			//Formularcache löschen
			Cache::clearCache("form:" . $this->_['post']['elementFormKey']);
			
			$messages['ok'] = 'Das Formularelement wurde aus der Datenbank entfernt!';
			
			//Übersicht ausgeben
			$_REQUEST['editForm'] = $this->_['post']['elementFormKey'];
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/forms/detail.tpl');
			
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeFormElement'){
	 
		/*
		 * Formularelement laden
		 */
		if((int)$key > 0){
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
		<span class="icon icon-remove"></span> Formularelement wirklich l&ouml;schen?
	</h2>
	<p>Soll das Formularelement <span class="urlpath"><?php echo $element['elementLabel']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang wirkt sich sofort auf das Frontend aus und kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeFormElement={$key}","post");
		
		$form->row->printHidden("do","removeFormElement");
		$form->row->printHidden("elementKey",$element['elementKey']);
		$form->row->printHidden("elementFormKey",$element['elementFormKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?editForm={$element['elementFormKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>