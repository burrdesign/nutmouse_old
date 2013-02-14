<?php
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/admin/Form.php');
	
	$path = $_REQUEST['tree'];
	$split = split('/',$path);
	$subpath = substr($path, 0, (-1 * strlen($split[count($split)-1])));
	
	/*
	 * ACTIONPHASE:
	 * Speichern der Datei
	 */
	if($this->_['post']['do'] == "saveFile"){
		if($this->_['post']['filePath'] > ""){
			if($this->_['post']['filePath'] != $this->_['post']['oldFilePath']){
				//Dateipfad wurde geändert => prüfen ob Datei bereits existiert
				if(!is_file($_SERVER['DOCUMENT_ROOT'] . '/'. $this->_['post']['filePath'])){
					//Datei noch nicht vorhanden, kann also verschoben werden
					$oldpath = $_SERVER['DOCUMENT_ROOT'] . '/'. $this->_['post']['oldFilePath'];
					$newpath = $_SERVER['DOCUMENT_ROOT'] . '/'. $this->_['post']['filePath'];
					rename($oldpath,$newpath);
					$path = $this->_['post']['filePath'];
				} else {
					//Datei schon vorhanden
					$messages['error'] = 'Die gewünschte Datei ist bereits vorhanden!';
				}
			}
			if(!$messages['error']){
				//Änderungen nur speichern, wenn noch kein Fehler aufgetreten ist
				if(isset($this->_['post']['fileContent'])){
					file_put_contents($_SERVER['DOCUMENT_ROOT'] . '/' . $this->_['post']['filePath'], $this->_['post']['fileContent']);
				}
				$messages['ok'] = 'Die &Auml;nderungen wurden erfolgreich gespeichert!';
			}
		} else {
			//kein Dateipfad angegeben
			$messages['error'] = 'Es muss ein Datei-Pfad angegeben werden!';
		}
	}
	
	$file=array();
	$filepath = $_SERVER['DOCUMENT_ROOT']. '/' . $path;
	
	/*
	 * Datei laden
	 */
	if($messages['error']){
		$file = $this->_['post'];
		$file['filePath'] = $path;
	} elseif(is_file($filepath)){
		$file['filePath'] = $path;
		$file['fileSize'] = filesize($filepath) . ' byte';
		$file['fileLastChanged'] = date("D, j. M Y",filemtime($filepath));
		$file['fileContent'] = file_get_contents($filepath);
		$file['fileType'] = mime_content_type($filepath);
	} else {
		$messages['error'] = 'Datei konnte nicht gefunden werden!';
	}
?>

<div class="mask_intro">
	<h2 class="mask_title">
		<span class="icon icon-pencil"></span> Datei bearbeiten
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
		
		$form->start("?tree={$path}","post","multipart/form-data");
		
		$form->row->printHidden("do","saveFile");
		$form->row->printHidden("oldFilePath",$path);
		
		
		$form->row->printTextfield("Datei-Pfad", "filePath", $file['filePath'],"","","http://" . $_SERVER['SERVER_NAME'] . "/ ");
		$form->row->printHidden("fileType", $file['fileType'],true,"Datei-Typ");
		$form->row->printHidden("fileSize", $file['fileSize'],true,"Datei-Gr&ouml;&szlig;e");
		$form->row->printHidden("fileLastChanged", $file['fileLastChanged'],true,"Zuletzt ge&auml;ndert am");
		
		if(strpos($file['fileType'],'text/') !== false){
			//direkte Bearbeitung
			$form->row->start("","","nolabel");
				$form->element->printTextarea("fileContent",$file['fileContent'],"","width:99%; height:250px;");
			$form->row->end();
		} else {
			//Upload-Möglichkeit
			$form->row->printUpload("Ersetzen durch","fileUpload","","","display:block; margin:3px 0 0 0;");
		}
		$form->row->printInfo("Download", "<a href=\"http://{$_SERVER['SERVER_NAME']}/{$path}\" target=\"_blank\">{$_SERVER['SERVER_NAME']}/{$path}</a>");
		
		$form->row->start();
			$form->element->printSubmit("Speichern");
			$form->element->printSubmitLink("<span class=\"icon icon-remove\"></span> Löschen","?removeFile=" . $path, "", "", "margin-right:30px;");
			$form->element->printSubmitLink("Zur&uuml;ck zur &Uuml;bersicht","?tree=" . $subpath);
		$form->row->end();
		
		$form->end();
	
	?>
	
</div>