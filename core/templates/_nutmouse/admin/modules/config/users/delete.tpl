<?php
	
	$key = $_REQUEST['removeUser'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Benutzers
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeUser'){
		//Benutzer löschen
		if($this->_['post']['adminKey']){
			//prüfen, ob es sich um den angemeldeten User handelt
			if($this->_['post']['adminKey'] == $_SESSION['BD']['ADMIN']['user']['adminKey']){
				$messages['error'] = 'Bitte begehen Sie keinen Suizid!';
			} else {
				$sql->delete("bd_sys_admin_user",$this->_['post']);
				$messages['ok'] = 'Der Benutzer wurde erfolgreich gel&ouml;scht!';
				
				//Übersicht ausgeben
				include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/config/users/overview.tpl');
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeUser'){
	 
		/*
		 * Benutzer laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_sys_admin_user
				WHERE adminKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$user = $sql->result();
			
			if(!$user['adminKey']){
				$messages['error'] = 'Benutzer konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Benutzer konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Benutzer wirklich l&ouml;schen?
	</h2>
	<p>Soll der Benutzer <span class="urlpath"><?php echo $user['adminLogin']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeUser={$key}","post");
		
		$form->row->printHidden("do","removeUser");
		$form->row->printHidden("adminKey",$user['adminKey']);
		$form->row->printHidden("adminGroupKey",$user['adminGroupKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zum Benutzer","?editUser={$user['adminUser']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>