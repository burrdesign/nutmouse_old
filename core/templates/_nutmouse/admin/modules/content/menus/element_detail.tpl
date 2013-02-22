<?php

	$key = $_REQUEST['editMenuElement'];
	$menukey = $_REQUEST['editMenu'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern des Menüelements
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveMenuElement'){
		//Menüelement speichern
		if($this->_['post']['elementKey'] && $this->_['post']['elementMenuKey']){
			if($this->_['post']['elementKey'] == "new"){
				//Neues Menüelement anlegen
				$sql->insert("bd_main_menu_element",$this->_['post']);
				$key = $sql->getLastInsertID();
				$messages['ok'] = 'Men&uuml;element erfolgreich angelegt!';
			} else {
				//vorhandenes Menüelement updaten
				$sql->update("bd_main_menu_element",$this->_['post']);
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
				
				//Menü löschen
				Cache::clearCache("menu:" . $this->_['post']['elementMenuKey']);
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	 
	/*
	 * Menüelement laden
	 */
	if($messages['error']){
		$element = $this->_['post'];
	} elseif($key == "new"){
		$element['elementKey'] = "new";
		$element['elementMenuKey'] = $menukey;
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_menu_element
			WHERE elementKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$element = $sql->result();
		if(!$element['elementKey']){
			$messages['error'] = 'Men&uuml;element konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Men&uuml;element konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neues Men&uuml;element anlegen';
			} else {
				echo 'Men&uuml;element bearbeiten';
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
		
		$form->start("?editMenuElement={$key}","post");
		
		$form->row->printHidden("do","saveMenuElement");
		
		if($key != "new") $form->row->printHidden("elementKey",$element['elementKey'],true,"ID");
		else $form->row->printHidden("elementKey",$element['elementKey']);
		$form->row->printHidden("elementMenuKey",$element['elementMenuKey']);
		
		$form->row->printTextfield("Element-Name", "elementLabel", $element['elementLabel'],"","width:200px;");
		$form->row->printTextfield("Position", "elementPos", $element['elementPos']);
		
		$form->row->printTextfield("Link", "elementLink", $element['elementLink']);
		$form->row->printTextfield("Link-Ziel", "elementLinkTarget", $element['elementLinkTarget']);
		
		//verfügbare Parent-Menüs ermitteln für SELECT-Auswahl
		$sql = new SqlManager();
		$sql->setQuery("
			SELECT * FROM bd_main_menu_element
			WHERE elementMenuKey = {{menu}} AND elementKey != {{key}}
			");
		$sql->bindParam("{{menu}}",$element['elementMenuKey'],"int");
		$sql->bindParam("{{key}}",$element['elementKey'],"int");
		$parents = $sql->execute();
		
		$form->row->printSelectFromQuery("Eltern-Men&uuml;eintrag", "elementParent", $element['elementParent'], $parents, "elementKey", "elementLabel");
		
		$form->row->printEnable("Aktiv", "elementActive", $element['elementActive']);
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeMenu=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zum Men&uuml;","?editMenu={$element['elementMenuKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>


