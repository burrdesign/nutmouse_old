<?php
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Db/SqlManager.php');
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Form.php');
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Cache.php');
	
	$key = $_REQUEST['editFile'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern der Seite
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveSite'){
		//Seiteninhalt speichern
		if($this->_['post']['contentKey'] && $this->_['post']['versionKey']){
		
			//Versionsverwaltung erstmal nicht implementiert
			$this->_['post']['versionNumber'] = 1;
			$this->_['post']['versionActive'] = 1;
			
			$this->_['post']['versionLastChanged'] = date("Y-m-d H:i:s", time());
			
			if($this->_['post']['contentKey'] == "new"){
				//Neue Seite anlegen
				unset($this->_['post']['contentKey']);
				unset($this->_['post']['versionKey']);
				$this->_['post']['versionCreated'] = date("Y-m-d H:i:s", time());
				$sql->insert("bd_main_content",$this->_['post']);
				$key = $sql->getLastInsertID();
				$this->_['post']['versionContentKey'] = $key;
				$sql->insert("bd_main_content_version",$this->_['post']);
				$messages['ok'] = 'Die Seite wurde erfolgreich angelegt!';
			} else {
				//Vorhandene Seite update
				if($this->_['post']['oldContentPath'] != $this->_['post']['contentPath']){
					//der URL-Pfad wurde geändert
					$sql->setQuery("
						SELECT * FROM bd_main_content
						WHERE contentPath = '{{path}}'
						LIMIT 1
						");
					$sql->bindParam("{{path}}",$this->_['post']['contentPath']);
					$test = $sql->result();
					if($test['contentKey']){
						$messages['error'] = 'Der angegebene Pfad wird bereits verwendet!';
					} else {
						//Seitenpfad wird umbenannt, also Cache der alten Seite löschen
						Cache::clearCache("content:" . $this->_['post']['oldContentPath']);
					}
				}
				//Nur speichern, wenn kein Fehler aufgetreten ist
				if(!$messages['error']){
					$sql->update("bd_main_content",$this->_['post']);
					$sql->update("bd_main_content_version",$this->_['post']);
					$messages['ok'] = 'Die &Auml;nderungen wurden erfolgreich gespeichert!';
					
					//Seitencache löschen
					Cache::clearCache("content:" . $this->_['post']['contentPath']);
				}
			}
			
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	 
	/*
	 * Seite laden
	 */
	if($messages['error']){
		$site = $this->_['post'];
		$p = split('/',$site['contentPath']);
		$tree = substr($site['contentPath'], 0, -1 * strlen($p[count($p)-1]));
	} elseif($key == "new"){
		$site['contentKey'] = "new";
		$site['versionKey'] = "new";
		$tree = $this->_['request']['tree'];
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_content
			LEFT JOIN bd_main_content_version ON (contentKey = versionContentKey)
			WHERE contentKey = {{key}} AND versionActive = 1
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$site = $sql->result();
		$p = split('/',$site['contentPath']);
		$tree = substr($site['contentPath'], 0, -1 * strlen($p[count($p)-1]));
		if(!$site['contentKey']){
			$messages['error'] = 'Inhalt konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Der Inhalt konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neuen Seiteninhalt anlegen';
			} else {
				echo 'Seiteninhalt bearbeiten';
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
		
		$form->start("?editFile={$key}","post");
		
		$form->row->printHidden("do","saveSite");
		$form->row->printHidden("contentKey",$site['contentKey']);
		$form->row->printHidden("versionKey",$site['versionKey']);
		
		$form->row->printHidden("oldContentPath",$site['contentPath']);
		
		$form->row->printTextfield("URL-Pfad", "contentPath", $site['contentPath'],"","","http://" . $_SERVER['SERVER_NAME'] . "/ ");
		$form->row->printTextfield("Seitentitel", "contentTitle", $site['contentTitle'],"","width:200px;");
		
		//Seiteninhalts-Feld ohne Label ausgeben
		echo "
			\t<div class=\"input_row\" style=\"margin-top:10px;\">\n
			\t\t<textarea class=\"wysiwyg-editor\" name=\"versionText\" style=\"width:99%; height:250px;\">{$site['versionText']}</textarea>\n
			\t</div>
			";
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeFile=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?tree=" . $tree);
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>