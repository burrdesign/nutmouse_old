<?php
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Form.php');
	
	$path = $_REQUEST['removeFile'];
	$split = split('/',$path);
	if(is_file($_SERVER['DOCUMENT_ROOT'] . '/' . $path)){
		$subpath = substr($path, 0, (-1 * strlen($split[count($split)-1])));
	} else {
		$subpath = substr($path, 0, (-1 * strlen($split[count($split)-2])) - 1);
	}
	
	/*
	 * ACTIONPHASE:
	 * Löschen der Datei
	 */
	$sql = new SqlManager();
	if($this->_['post']['do'] == 'removeFile'){
		//Datei löschen
		if(is_file($_SERVER['DOCUMENT_ROOT'] . '/' . $this->_['post']['filePath'])){
		
			unlink($_SERVER['DOCUMENT_ROOT'] . '/' . $this->_['post']['filePath']);
			$messages['ok'] = 'Die Datei wurde gel&ouml;scht!';
			
			//Übersicht ausgeben
			include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/files/overview.tpl');
			
		} elseif(is_dir($_SERVER['DOCUMENT_ROOT'] . '/' . $this->_['post']['filePath'])){
		
			//prüfen ob Verzeichnis leer ist
			$handle = opendir($_SERVER['DOCUMENT_ROOT'] . '/' . $this->_['post']['filePath']);
			$cnt = 0;
			while($line = readdir($handle)){
				if($line != "." && $line != ".."){
					$cnt++;
				}
			}
			if($cnt > 0){
				//Es sind Datein im Verzeichnis => nicht löschen
				$messages['error'] = 'Es k&ouml;nnen nur leere Verzeichnisse gel&ouml;scht werden!';
			} else {
				//Verzeichnis löschen
				rmdir($_SERVER['DOCUMENT_ROOT'] . '/' . $this->_['post']['filePath']);
				$messages['ok'] = 'Verzeichnis wurde gel&ouml;scht!';
				
				//Übersicht ausgeben
				include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/modules/content/files/overview.tpl');
			}
		
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	}
	
	if($messages['error'] || $this->_['post']['do'] != 'removeFile'){
	 
		/*
		 * Datei laden
		 */
		if(!is_file($_SERVER['DOCUMENT_ROOT'] . '/' . $path) && !is_dir($_SERVER['DOCUMENT_ROOT'] . '/' . $path)){
			$messages['error'] = 'Pfad ist ung&uuml;ltig!';
		}
?>

<div class="mask_intro">

	<?php
		if(is_file($_SERVER['DOCUMENT_ROOT'] . '/' . $path)){
			echo "
				<h2 class=\"mask_title\">
					<span class=\"icon icon-remove\"></span> Datei wirklich l&ouml;schen?
				</h2>
				<p>Soll die Datei <span class=\"urlpath\">http://" . $_SERVER['SERVER_NAME'] . "/" . $path ."</span> wirklich gel&ouml;scht werden? Die Datei wird komplett vom Server entfernt und kann nicht wiederhergestellt werden!</p>
				";
		} else {
			echo "
				<h2 class=\"mask_title\">
					<span class=\"icon icon-remove\"></span> Verzeichnis wirklich l&ouml;schen?
				</h2>
				<p>Soll das Verzeichnis <span class=\"urlpath\">http://" . $_SERVER['SERVER_NAME'] . "/" . $path ."</span> wirklich gel&ouml;scht werden? Verzeichnisse k&ouml;nnen nur gel&ouml;scht werden, wenn sie keine Dateien mehr enthalten! Gel&ouml;schte Verzeichnisse werden komplett vom Server entfernt und k&ouml;nnen nicht wiederhergestellt werden!</p>
				";
		}
	
		if(is_array($messages)){
			echo "<div class=\"mask_messages\">\n";
			foreach($messages as $msg_type => $msg_text){
				echo "\t<br class=\"clear\" />\n";
				echo "\t<div class=\"message message_{$msg_type}\"><span class=\"icon\"></span><span class=\"text\">{$msg_text}</span></div>\n";
			}
			echo "</div>\n";
		}
		
		
		$form = new Form();
		
		$form->start("?removeFile={$path}","post");
		
		$form->row->printHidden("do","removeFile");
		$form->row->printHidden("filePath",$path);
		
		$form->row->start();
			if(!$messages['error']) $form->element->printSubmit("Ja, wirklich löschen");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?tree=" . $subpath);
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>

<?php
	} //endif
?>