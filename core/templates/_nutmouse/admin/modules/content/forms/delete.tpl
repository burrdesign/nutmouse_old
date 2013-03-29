<?php
	
	$key = $_REQUEST['removeForm'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Formulars
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeForm'){
		//Formular (inkl. aller Elemente) löschen
		if($this->_['post']['formKey']){
		
			$sql->setQuery("
				DELETE FROM bd_main_form_element
				WHERE elementFormKey = {{key}}
				");
			$sql->bindParam("{{key}}",$key);
			$sql->execute();
			$sql->delete("bd_main_form",$this->_['post']);
			
			//Formularcache löschen
			Cache::clearCache("form:" . $this->_['post']['formKey']);
			
			$messages['ok'] = 'Das Formular wurde aus der Datenbank entfernt!';
			
			//Übersicht ausgeben
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/forms/overview.tpl');
			
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeForm'){
	 
		/*
		 * Formular laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_main_form
				WHERE formKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$forminfo = $sql->result();
			
			if(!$forminfo['formKey']){
				$messages['error'] = 'Formular konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Formular konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Formular wirklich l&ouml;schen?
	</h2>
	<p>Soll das Formular <span class="urlpath"><?php echo $forminfo['formName']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang wirkt sich sofort auf das Frontend aus und kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeForm={$key}","post");
		
		$form->row->printHidden("do","removeForm");
		$form->row->printHidden("formKey",$forminfo['formKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?page=1");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>