<?php

	$key = $_REQUEST['editMenu'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern des Menüs
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveMenu'){
		//Menü speichern
		if($this->_['post']['menuKey']){
			if($this->_['post']['menuKey'] == "new"){
				//Neues Menü anlegen
				$sql->insert("bd_main_menu",$this->_['post']);
				$key = $sql->getLastInsertID();
				$messages['ok'] = 'Men&uuml; erfolgreich angelegt!';
			} else {
				//vorhandenes Menü updaten
				$sql->update("bd_main_menu",$this->_['post']);
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
				
				//Menücache löschen
				Cache::clearCache("menu:" . $this->_['post']['menuKey']);
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	 
	/*
	 * Menü laden
	 */
	if($messages['error']){
		$menu = $this->_['post'];
	} elseif($key == "new"){
		$menu['menuKey'] = "new";
	} elseif((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_menu
			WHERE menuKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$menu = $sql->result();
		if(!$menu['menuKey']){
			$messages['error'] = 'Men&uuml; konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'Men&uuml; konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neues Men&uuml; anlegen';
			} else {
				echo 'Men&uuml; und -elemente bearbeiten';
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
		
		$form->start("?editMenu={$key}","post");
		
		$form->row->printHidden("do","saveMenu");
		
		if($key != "new") $form->row->printHidden("menuKey",$menu['menuKey'],true,"ID");
		else $form->row->printHidden("menuKey",$menu['menuKey']);
		$form->row->printTextfield("Men&uuml;-Name", "menuName", $menu['menuName'],"","width:200px;");
		$form->row->printEnable("Aktiv", "menuActive", $menu['menuActive']);
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeMenu=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?page=1");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>


<div class="mask_table" style="margin-top:30px; width:100%; float:left;">

	<?php
	
		if($key != "new"){
			//Menüelemente
			$sql->setQuery("
				SELECT * FROM bd_main_menu_element
				WHERE elementMenuKey = {{key}} AND ( elementParent = '' OR elementParent = 0 OR elementParent IS NULL )
				ORDER BY elementPos
				");
			$sql->bindParam("{{key}}",$key,"int");
			$elementquery = $sql->execute();
			
			//Elemente ausgeben
			if(mysql_num_rows($elementquery) == 0){
				echo "<p><i>Es wurden keine Men&uuml;elemente gefunden!</i></p>\n";
			} else {
				echo "\t<table class=\"list list_menus\" cellpadding=0 cellspacing=0>\n";
				printMenuTree($elementquery);
				echo "\t</table>\n";
			}
				
			$form->element->printSubmitLink("Neues Men&uuml;element anlegen","?editMenu={$key}&editMenuElement=new");
		}
		
		
		//Hilfsfunktion zum Ausgaben der Menü-Baum-Struktur
		function printMenuTree($query,$parent=null,$level=0){		
			while($element = mysql_fetch_array($query)){
				$active_text = "<i>inaktiv</i>";
				if($element['elementActive'] == 1){
					$active_text = "aktiv";
				}
				$pre = "";
				for($i=0; $i<$level; $i++){
					$pre .= "-- ";
				}
				echo "
					\t\t<tr class=\"level_{$level}\">\n
					\t\t\t<td class=\"key first width_30 align_center\">{$element['elementKey']}</td>\n
					\t\t\t<td class=\"title\">{$pre}{$element['elementLabel']}</td>\n
					\t\t\t<td class=\"link width_120 font_small hide_650\">{$element['elementLink']}</td>\n
					\t\t\t<td class=\"active width_30 font_small hide_650 align_center\">{$active_text}</td>\n
					\t\t\t<td class=\"action\"><a href=\"?editMenuElement={$element['elementKey']}\" class=\"icon icon-pencil\" title=\"Men&uuml;element bearbeiten\"></a></td>\n
					\t\t\t<td class=\"action\"><a href=\"?removeMenuElement={$element['elementKey']}\" class=\"icon icon-cancel-circle\" title=\"Men&uuml;element l&ouml;schen\"></a></td>\n
					\t\t</tr>\n";
				
				$sql = new SqlManager();
				$sql->setQuery("
					SELECT * FROM bd_main_menu_element
					WHERE elementMenuKey = {{key}} AND elementParent = {{parent}}
					ORDER BY elementPos
					");
				$sql->bindParam("{{key}}",$element['elementMenuKey'],"int");
				$sql->bindParam("{{parent}}",$element['elementKey'],"int");
				$parentquery = $sql->execute();
				
				//rekursiver Aufruf
				printMenuTree($parentquery,$element['elementKey'],$level+1);
				
			}
		}
	
	?>
	
</div>


