<?php
	
	$key = $_REQUEST['removeMenu'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Menüs
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeMenu'){
		//Menü löschen
		if($this->_['post']['menuKey']){
		
			$sql->delete("bd_main_menu",$this->_['post']);
			
			//Menücache löschen
			Cache::clearCache("menu:" . $this->_['post']['menuKey']);
			
			$messages['ok'] = 'Das Men&uuml; wurde aus der Datenbank entfernt!';
			
			//Übersicht ausgeben
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/menus/overview.tpl');
			
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeMenu'){
	 
		/*
		 * Menü laden
		 */
		if((int)$key > 0){
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
		<span class="icon icon-remove"></span> Men&uuml; wirklich l&ouml;schen?
	</h2>
	<p>Soll das Men&uuml; <span class="urlpath"><?php echo $menu['menuName']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang wirkt sich sofort auf das Frontend aus und kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeMenu={$key}","post");
		
		$form->row->printHidden("do","removeMenu");
		$form->row->printHidden("menuKey",$menu['menuKey']);
		
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