<?php

	$key = $_REQUEST['editNews'];
	
	/*
	 * ACTIONPHASE:
	 * Speichern der Neuigkeit
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'saveNews'){
		//Neuigkeit speichern
		if($this->_['post']['newsKey']){
			$this->_['post']['newsLastChanged'] = date("Y-m-d H:i:s", time());
			if($this->_['post']['newsKey'] == "new"){
				//Neue Neuigkeit anlegen
				$this->_['post']['newsCreated'] = date("Y-m-d H:i:s", time());
				$sql->insert("bd_main_news",$this->_['post']);
				$key = $sql->getLastInsertID();
				$messages['ok'] = 'News erfolgreich angelegt!';
			} else {
				//vorhandene Neuigkeit updaten
				$sql->update("bd_main_news",$this->_['post']);
				$messages['ok'] = '&Auml;nderungen wurden erfolgreich gespeichert!';
				
				//Newscache löschen
				Cache::clearCache("news:" . $this->_['post']['newsKey']);
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	 
	/*
	 * Neuigkeit laden
	 */
	if($messages['error']){
		$news = $this->_['post'];
	} elseif($key == "new"){
		$news['newsKey'] = "new";
	} elseif((int)$key > 0){
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
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> 
		<?php
			if($key == 'new'){
				echo 'Neue News anlegen';
			} else {
				echo 'News bearbeiten';
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
		
		$form->start("?editNews={$key}","post");
		
		$form->row->printHidden("do","saveNews");
		
		$form->row->printHidden("oldNewsPath",$news['newsPath']);
		
		if($key != "new") $form->row->printHidden("newsKey",$news['newsKey'],true,"ID");
		else $form->row->printHidden("newsKey",$news['newsKey']);
		$form->row->printTextfield("News-Titel", "newsTitle", $news['newsTitle'],"","width:200px;");
		$form->row->printTextfield("Veröffentlichen am", "newsReleaseDate", $news['newsReleaseDate'],"datetime");
		
		$form->row->start("","","nolabel");
			$form->element->printTextarea("newsText",$news['newsText'],"wysiwyg-editor","width:100%; height:250px;");
		$form->row->end();
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			if($key != "new") $form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeNews=" . $key, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?page=1");
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>