<?php

	$key = $_REQUEST['editForm'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern des Formulars
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveForm'){
		//Formular speichern
		if($this->_['post']['formKey']){
			if($this->_['post']['formKey'] == "new"){
				//Neues Formular anlegen
				$sql->insert("bd_main_form",$this->_['post']);
				$key = $sql->getLastInsertID();
				$messages['ok'] = 'Formular erfolgreich angelegt!';
			} else {
				//vorhandenes Formular updaten
				$sql->update("bd_main_form",$this->_['post']);
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
				
				//Formularcache löschen
				Cache::clearCache("form:" . $this->_['post']['formKey']);
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	 
	/*
	 * Formular laden
	 */
	if($messages['error']){
		$forminfo = $this->_['post'];
	} elseif($key == "new"){
		$forminfo['formKey'] = "new";
	} elseif((int)$key > 0){
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
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neues Formular anlegen';
			} else {
				echo 'Formular bearbeiten';
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
		
		$form->start("?editForm={$key}","post");
		
		$form->row->printHidden("do","saveForm");
		
		if($key != "new") $form->row->printHidden("formKey",$forminfo['formKey'],true,"ID");
		else $form->row->printHidden("formKey",$forminfo['formKey']);
		
		$form->row->printTextfield("Formular-Name", "formName", $forminfo['formName'],"","width:200px;");
		$form->row->printSelect("Methode", "formMethod", $forminfo['formMethod'], array("get","post"), array("get"=>"GET","post"=>"POST"));	
		$form->row->printTextfield("Action", "formAction", $forminfo['formAction'],"","width:200px;");
		
		$form->row->printTextfield("Email senden an", "formSendTo", $forminfo['formSendTo'],"","width:200px;");
		$form->row->printTextfield("Email (CC)", "formSendCC", $forminfo['formSendCC'],"","width:200px;");
		$form->row->printTextfield("Email (BCC)", "formSendBCC", $forminfo['formSendBCC'],"","width:200px;");
		$form->row->printTextfield("Email-Absender", "formSendFrom", $forminfo['formSendFrom'],"","width:200px;");
		
		$form->row->printTextfield("Email-Betreff", "formSendSubject", $forminfo['formSendSubject'],"","width:200px;");
		$form->row->start("Email-Text","","nolabel");
			$form->element->printTextarea("formSendText",$forminfo['formSendText'],"","width:100%; height:120px;");
		$form->row->end();
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeForm=" . $key, "", "", "margin-right:30px;");
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
				SELECT * FROM bd_main_form_element
				JOIN bd_main_form_element_type ON ( typeKey = elementType )
				WHERE elementFormKey = {{key}}
				ORDER BY elementPos
				");
			$sql->bindParam("{{key}}",$key,"int");
			$elements = $sql->execute();
			
			//Elemente ausgeben
			if(mysql_num_rows($elements) == 0){
				echo "<p><i>Es wurden keine Formularelemente gefunden!</i></p>\n";
			} else {
				echo "\t<table class=\"list list_menus\" cellpadding=0 cellspacing=0>\n";
				while($element = mysql_fetch_array($elements)){
					echo "
						\t\t<tr class=\"\">\n
						\t\t\t<td class=\"first filename width_120\">{$element['elementName']}</td>\n
						\t\t\t<td class=\"title width_120\">{$element['elementLabel']}</td>\n
						\t\t\t<td class=\"date width_120 font_small hide_650 align_center\">{$element['typeLabel']}</td>\n
						\t\t\t<td class=\"action\"><a href=\"?editFormElement={$element['elementKey']}\" class=\"icon icon-pencil\" title=\"Element bearbeiten\"></a></td>\n
						\t\t\t<td class=\"action\"><a href=\"?removeFormElement={$element['elementKey']}\" class=\"icon icon-cancel-circle\" title=\"Element l&ouml;schen\"></a></td>\n
						\t\t</tr>\n";
				}
				echo "\t</table>\n";
			}
				
			//Neue Datei hochladen
			$form->element->printSubmitLink("Neues Formularelement anlegen","?editForm={$key}&editFormElement=new");
		}
	
	?>
	
</div>



