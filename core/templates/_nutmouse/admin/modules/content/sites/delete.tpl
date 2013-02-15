<?php
	$key = $_REQUEST['removeFile'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen der Seite
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeSite'){
		//Seiteninhalt löschen
		if($this->_['post']['contentKey']){
		
			$sql->delete("bd_main_content",$this->_['post']);
			
			//Versionsverwaltung erstmal nicht implementiert, also alle Versionsdatensätze löschen
			$sql->setQuery("
				DELETE FROM bd_main_content_version
				WHERE versionContentKey = {{key}}
				");
			$sql->bindParam("{{key}}",$this->_['post']['contentKey'],"int");
			$sql->execute();
			
			//Seitencache löschen
			Cache::clearCache("content:" . $this->_['post']['contentPath']);
			
			$messages['ok'] = 'Die Seite wurde aus der Datenbank entfernt!';
			
			//Übersicht ausgeben
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/sites/overview.tpl');
			
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeSite'){
	 
		/*
		 * Seite laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_main_content
				WHERE contentKey = {{key}}
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
		<span class="icon icon-remove"></span> Seiteninhalt wirklich l&ouml;schen?
	</h2>
	<p>Soll der Inhalt <span class="urlpath"><?php echo "http://" . $_SERVER['SERVER_NAME'] . "/" . $site['contentPath']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang wirkt sich sofort auf das Frontend aus und kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeFile={$key}","post");
		
		$form->row->printHidden("do","removeSite");
		$form->row->printHidden("contentKey",$site['contentKey']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?tree=" . $tree);
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>