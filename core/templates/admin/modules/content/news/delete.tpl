<?php
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/db/SqlManager.php');
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/admin/Form.php');
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/system/Cache.php');
	
	$key = $_REQUEST['removeNews'];
	
	/*
	 * ACTIONPHASE:
	 * Löschen der Neuigkeit
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeNews'){
		//Neuigkeit löschen
		if($this->_['post']['newsKey']){
		
			$sql->delete("bd_main_news",$this->_['post']);
			
			//Seitencache löschen
			Cache::clearCache("news:" . $this->_['post']['newsKey']);
			
			$messages['ok'] = 'Die Neuigkeit wurde aus der Datenbank entfernt!';
			
			//Übersicht ausgeben
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/modules/content/news/overview.tpl');
			
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	 
	/*
	 * Seite laden
	 */
	if((int)$key > 0){
		$sql->setQuery("
			SELECT * FROM bd_main_news
			WHERE newsKey = {{key}}
			LIMIT 1
			");
		$sql->bindParam("{{key}}",$key,"int");
		$news = $sql->result();
		
		if(!$news['newsKey']){
			$messages['error'] = 'News konnte nicht gefunden werden!';
		}
	} else {
		$messages['error'] = 'News konnte nicht gefunden werden!';
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeNews'){
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> News wirklich l&ouml;schen?
	</h2>
	<p>Soll die News <span class="urlpath"><?php echo $news['newsTitle']; ?></span> wirklich gel&ouml;scht werden? Dieser Vorgang wirkt sich sofort auf das Frontend aus und kann nicht r&uuml;ckg&auml;ngig gemacht werden!</p>

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
		
		$form->start("?removeNews={$key}","post");
		
		$form->row->printHidden("do","removeNews");
		$form->row->printHidden("newsKey",$news['newsKey']);
		
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