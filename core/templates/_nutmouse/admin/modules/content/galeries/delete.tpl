<?php
	
	$key = $_REQUEST['removeGalery'];
	$galerypath = 'core/files/galeries';
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Galeriebildes
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeGalery'){
		//Menü löschen
		if($this->_['post']['galeryKey']){
		
			$galerydir = $_SERVER['DOCUMENT_ROOT'] . '/' . $galerypath . '/' . $this->_['post']['galeryKey'] . '/';
			
			//Datei löschen
			if(is_dir($galerydir)){
				Lib::recursiveRmdir($galerydir);
				
				//Datenbankeinträge löschen
				$sql->setQuery("
					DELETE FROM bd_main_galery_image
					WHERE imageGaleryKey = {{key}}
					");
				$sql->bindParam("{{key}}", $this->_['post']['galeryKey']);
				$sql->execute();
				$sql->delete("bd_main_galery",$this->_['post']);
				$messages['ok'] = 'Die Bildergalerie wurde erfolgreich gel&ouml;scht!';
				
				//Übersicht ausgeben
				include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/galeries/overview.tpl');
			} else {
				$messages['error'] = 'Es ist ein Fehler aufgetreten!';
			}
			
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeGalery'){
	 
		/*
		 * Galerie laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_main_galery
				WHERE galeryKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$galery = $sql->result();
			
			if(!$galery['galeryKey']){
				$messages['error'] = 'Bildergalerie konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Bildergalerie konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Bildergalerie wirklich l&ouml;schen?
	</h2>
	<p>Soll die Bildergalerie <span class="urlpath"><?php echo $galery['galeryTitle']; ?></span> wirklich gel&ouml;scht werden? Dabei werden automatisch auch alle Bilder dieser Galerie vom Server entfernt. Dieser Vorgang wirkt sich sofort auf das Frontend aus und kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeGalery={$key}","post");
		
		$form->row->printHidden("do","removeGalery");
		$form->row->printHidden("galeryKey",$galery['galeryKey']);
		
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