<?php

	$key = $_REQUEST['editUserGroup'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern der Benutzergruppe
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveUserGroup'){
	
		//Benutzergruppe speichern
		if($this->_['post']['groupKey']){
			if($this->_['post']['groupKey'] == "new"){
				//Neue Benutzergruppe anlegen
				$sql->insert("bd_sys_admin_group",$this->_['post']);
				$key = $sql->getLastInsertID();
				
				//Rechte speichern
				$insert = array();
				$insert['rightGroupKey'] = $this->_['post']['groupKey'];
				foreach($this->_['post'] as $k => $v){
					if(strpos($k, "moduleRight") == 0 && strpos($k, "moduleRight") !== false){
						$insert['rightModuleKey'] = str_replace("moduleRight","",$k);
						$insert['rightAccess'] = (int)$v;
						$sql->insert("bd_sys_admin_right", $insert);
					}
				}
				
				$messages['ok'] = 'Benutzergruppe erfolgreich angelegt!';
			} else {
				//vorhandene Benutzergruppe updaten
				$sql->update("bd_sys_admin_group",$this->_['post']);
				
				//Rechte löschen (als Vorbereitung)
				$sql->setQuery("
					DELETE FROM bd_sys_admin_right
					WHERE rightGroupKey = {{key}}");
				$sql->bindParam("{{key}}",$key,"int");
				$sql->execute();
				
				//neue Rechte speichern
				foreach($this->_['post'] as $k => $v){
					if(strpos($k, "moduleRight") == 0 && strpos($k, "moduleRight") !== false){
						$insert = array();
						$insert['rightGroupKey'] = $this->_['post']['groupKey'];
						$insert['rightModuleKey'] = str_replace("moduleRight","",$k);
						$insert['rightAccess'] = (int)$v;
						$sql->insert("bd_sys_admin_right", $insert);
					}
				}
				
				//eigene Rechte ggf. neu initialisieren
				if($this->_['post']['groupKey'] == $_SESSION['BD']['ADMIN']['user']['adminGroupKey']){
					$_SESSION['BD']['ADMIN']['user']['rights'] = array();
					$sql->setQuery("
						SELECT * FROM bd_sys_admin_right
						WHERE rightGroupKey = {{group}}"
						);
					$sql->bindParam("{{group}}",$_SESSION['BD']['ADMIN']['user']['adminGroupKey'],"int");
					$rights = $sql->execute();
					while($right = mysql_fetch_array($rights)){
						$_SESSION['BD']['ADMIN']['user']['rights'][$right['rightModuleKey']] = $right['rightAccess'];
					}
				}
				
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
		
	}
	 
	/*
	 * Benutzergruppe laden
	 */
	if($messages['error']){
		$group = $this->_['post'];
	} elseif($key == "new"){
		$group['groupKey'] = "new";
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_sys_admin_group
			WHERE groupKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$group = $sql->result();
		
		//Prüfen, ob Galerie geladen werden konnte
		if(!$group['groupKey']){
			$messages['error'] = 'Benutzergruppe konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Benutzergruppe konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neue Benutzergruppe anlegen';
			} else {
				echo 'Benutzergruppe bearbeiten';
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
		
		$form->start("?editUserGroup={$key}","post");
		
		$form->row->printHidden("do","saveUserGroup");
		
		if($key != "new") $form->row->printHidden("groupKey",$group['groupKey'],true,"ID");
		else $form->row->printHidden("groupKey",$group['groupKey']);
		
		$form->row->printTextfield("Gruppen-Name", "groupName", $group['groupName'],"","width:200px;");
		
		$form->row->start("Rechte");
			$sql->setQuery("
			SELECT * FROM bd_sys_admin_module
			WHERE moduleActive = 1
			ORDER BY moduleName");
			$modules = $sql->execute();
			
			$rights = array();
			$sql->setQuery("
				SELECT * FROM bd_sys_admin_right
				WHERE rightGroupKey = {{key}}"
				);
			$sql->bindParam("{{key}}",$key,"int");
			$result = $sql->execute();
			while($right = mysql_fetch_array($result)){
				$rights[$right['rightModuleKey']] = $right['rightAccess'];
			}
			
			while($module = mysql_fetch_array($modules)){
				$form->element->printEnable("moduleRight{$module['moduleKey']}", $rights[$module['moduleKey']], 1, 0,"", "", "<div style=\"clear:both;\">", "<span style=\"float:left; margin:5px 0 0 5px;\">{$module['moduleName']}</span></div>");
			}
		$form->row->end();

		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeUserGroup=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?page=1");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>


<?php
	if($key != "new"){
?>

<div class="mask_intro" style="margin-top:30px; width:100%; float:left;">
	<h2 class="mask_title">
		<span class="icon icon-user"> Benutzer dieser Gruppe</span>
	</h2>
</div>

<div class="mask_table">

<?php
	//Bilder laden
	$sql->setQuery("
		SELECT * FROM bd_sys_admin_user
		WHERE adminGroupKey = {{key}}
		ORDER BY adminLogin
		");
	$sql->bindParam("{{key}}",$key,"int");
	$users = $sql->execute();
	
	//Elemente ausgeben
	if(mysql_num_rows($users) == 0){
		echo "<p><i>Es wurden keine Benutzer in dieser Gruppe gefunden!</i></p>\n";
	} else {
		echo "\t<table class=\"list list_menus\" cellpadding=0 cellspacing=0>\n";
		while($user = mysql_fetch_array($users)){
			echo "
				\t\t<tr class=\"\">\n
				\t\t\t<td class=\"key first width_30 align_center\">{$user['adminKey']}</td>\n
				\t\t\t<td class=\"login\">{$user['adminLogin']}</td>\n
				\t\t\t<td class=\"name width_200 font_small hide_650 align_left\">{$user['adminName']} {$user['adminLastName']}</td>\n
				\t\t\t<td class=\"lastlogin width_120 font_small hide_1050 align_center\">" . date("D, j. M Y", strtotime($user['adminLastLogin'])) . "</td>\n
				\t\t\t<td class=\"action\"><a href=\"?editUser={$user['adminKey']}\" class=\"icon icon-pencil\" title=\"Bild bearbeiten\"></a></td>\n
				\t\t\t<td class=\"action\"><a href=\"?removeUser={$user['adminKey']}\" class=\"icon icon-cancel-circle\" title=\"Bild l&ouml;schen\"></a></td>\n
				\t\t</tr>\n";
		}
		echo "\t</table>\n";
	}
		
	//Neuen Benutzer hochladen
	$form = new Form();
	$form->element->printSubmitLink("Neuen Benutzer anlegen","?editUser=new&userGroup={$key}");

?>
	
</div>

<?php
	} //endif
?>

