<?php
	
	$key = $_REQUEST['removeMenuElement'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Menüselements
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeMenuElement'){
		//Menü löschen
		if($this->_['post']['elementKey']){
		
			$sql->delete("bd_main_menu_element",$this->_['post']);
			
			//Menücache löschen
			Cache::clearCache("menu:" . $this->_['post']['elementMenuKey']);
			
			$messages['ok'] = 'Das Men&uuml;element wurde aus der Datenbank entfernt!';
			
			//Übersicht ausgeben
			$_REQUEST['editMenu'] = $this->_['post']['elementMenuKey'];
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/menus/detail.tpl');
			
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeMenuElement'){
	 
		/*
		 * Menü laden
		 */
		if((int)$key > 0){
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
		<span class="icon icon-remove"></span> Men&uuml;element wirklich l&ouml;schen?
	</h2>
	<p>Soll das Men&uuml;element <span class="urlpath"><?php echo $element['elementLabel']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang wirkt sich sofort auf das Frontend aus und kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeMenuElement={$key}","post");
		
		$form->row->printHidden("do","removeMenuElement");
		$form->row->printHidden("elementKey",$element['elementKey']);
		$form->row->printHidden("elementMenuKey",$element['elementMenuKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?editMenu={$element['elementMenuKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>