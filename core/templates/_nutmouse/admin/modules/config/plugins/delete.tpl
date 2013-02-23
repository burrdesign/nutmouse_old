<?php
	$name = $_REQUEST['removePlugin'];
	$pluginpath = $_SERVER['DOCUMENT_ROOT'] . '/core/classes/Plugins/';
	
	/*
	 * ACTIONPHASE:
	 * Löschen des Plugins
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removePlugin'){
		//Plugin komplett entfernen
		if(is_dir($pluginpath . $this->_['post']['pluginName'] . '/')){
			Lib::recursiveRmdir($pluginpath . $this->_['post']['pluginName'] . '/');
			$messages['ok'] = 'Das Plugin wurde erfolgreich entfernt!';
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/config/plugins/overview.tpl');
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removePlugin'){
	 
		/*
		 * Plugin laden
		 */
		if($name != ""){
			if(!is_dir($pluginpath . $name . '/')){
				$messages['error'] = 'Plugin konnte nicht gefunden werden!';
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-remove"></span> Plugin wirklich l&ouml;schen?
	</h2>
	<p>Soll das Plugin <span class="urlpath"><?php echo $name; ?></span> wirklich gel&ouml;scht werden?</p>

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
		
		$form->start("?removePlugin={$name}","post");
		
		$form->row->printHidden("do","removePlugin");
		$form->row->printHidden("pluginName",$name);
		
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