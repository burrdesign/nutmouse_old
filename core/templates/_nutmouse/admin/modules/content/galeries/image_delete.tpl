<?php
	
	$key = $_REQUEST['removeGaleryImage'];
	$galerypath = 'core/files/galeries';
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Galeriebildes
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeGaleryImage'){
		//Menü löschen
		if($this->_['post']['imageKey'] && $this->_['post']['imageFilename'] && $this->_['post']['imageGaleryKey']){
		
			$galerydir = $galerypath . '/' . $this->_['post']['imageGaleryKey'];
			
			//Datei löschen
			$filepath = $_SERVER['DOCUMENT_ROOT'] . '/' . $galerydir . '/' . $this->_['post']['imageFilename'];
			if(is_file($filepath)){
				unlink($filepath);
				$sql->delete("bd_main_galery_image",$this->_['post']);
				
				$messages['ok'] = 'Das Bild wurde erfolgreich gel&ouml;scht!';
				
				//Übersicht ausgeben
				$_REQUEST['editGalery'] = $this->_['post']['imageGaleryKey'];
				include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/galeries/detail.tpl');
			} else {
				$messages['error'] = 'Es ist ein Fehler aufgetreten!';
			}
			
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeGaleryImage'){
	 
		/*
		 * Bild laden
		 */
		if((int)$key > 0){
			$sql->setQuery("
				SELECT * FROM bd_main_galery_image
				WHERE imageKey = {{key}}
				LIMIT 1
				");
			$sql->bindParam("{{key}}",$key,"int");
			$image = $sql->result();
			
			if(!$image['imageKey']){
				$messages['error'] = 'Bild konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Bild konnte nicht gefunden werden!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Bild wirklich l&ouml;schen?
	</h2>
	<p>Soll das Bild <span class="urlpath"><?php echo $image['imageFilename']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang wirkt sich sofort auf das Frontend aus und kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeGaleryImage={$key}","post");
		
		$form->row->printHidden("do","removeGaleryImage");
		$form->row->printHidden("imageKey",$image['imageKey']);
		$form->row->printHidden("imageGaleryKey",$image['imageGaleryKey']);
		$form->row->printHidden("imageFilename",$image['imageFilename']);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?editGalery={$image['imageGaleryKey']}");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>