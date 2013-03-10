<?php
	
	$key = $_REQUEST['removeUserGroup'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen der Benutzergruppe
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeUserGroup'){
		//Menü löschen
		if($this->_['post']['groupKey']){
			//Prüfen, ob die Gruppe auch keine Benutzer mehr enthält
			$sql->setQuery("
				SELECT * FROM bd_sys_admin_user
				WHERE adminGroupKey = {{key}}
				LIMIT 1");
			$sql->bindParam("{{key}}",$key,"int");
			$test = $sql->result();
			
			if($test['adminKey']){
				$messages['error'] = 'Die Gruppe enth&auml;lt noch Benutzer!';
			} else {
				$sql->delete("bd_sys_admin_group",$this->_['post']);
				$messages['ok'] = 'Die Benutzergruppe wurde erfolgreich gel&ouml;scht!';
				
				//Übersicht ausgeben
				include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/config/users/overview.tpl');
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeUserGroup'){
	 
		/*
		 * Benutzer laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_sys_admin_group
				WHERE groupKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$group = $sql->result();
			
			if(!$group['groupKey']){
				$messages['error'] = 'Benutzergruppe konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Benutzergruppe konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Benutzergruppe wirklich l&ouml;schen?
	</h2>
	<p>Soll der Benutzergruppe <span class="urlpath"><?php echo $group['groupName']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang kann nicht r&uuml;ckg&auml;ngig gemacht werden! Benutzergruppen k&ouml;nnen nur gel&ouml;scht werden, wenn Sie keine Benutzer mehr enthalten. Ordnen Sie die Benutzer also zuerst anderen Gruppen zu, bevor Sie die Gruppe l&ouml;schen.</p>

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
		
		$form->start("?removeUserGroup={$key}","post");
		
		$form->row->printHidden("do","removeUserGroup");
		$form->row->printHidden("groupKey",$group['groupKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?editUserGroup={$group['groupKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>