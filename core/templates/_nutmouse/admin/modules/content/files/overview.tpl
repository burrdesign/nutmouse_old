<?php
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/System/Form.php');
	
	$path = $_REQUEST['tree'];
	$split = split('/',$path);
	$subpath = substr($path, 0, (-1 * strlen($split[count($split)-2])) - 1);
	
	/*
	 * ACTION-PHASE
	 */
	if($this->_['post']['do'] == "createDir" && !empty($this->_['post']['dirName'])){
		//neues Verzeichnis erstellen
		$dirpath = $_SERVER['DOCUMENT_ROOT'] . '/' . $path . $this->_['post']['dirName'];
		if(!is_dir($dirpath)){
			mkdir($dirpath);
			$messages['ok'] = 'Verzeichnis wurde erfolgreich angelegt!';
		} else {
			//Verzeichnis existiert bereits
			$messages['error'] = 'Das gew&uuml;nschte Verzeichnis existiert bereits!';
		}
	}
	
	if($this->_['post']['do'] == "uploadFile" && !empty($_FILES['file']['name'])){
		//neue Datei hochladen
		$filepath = $_SERVER['DOCUMENT_ROOT'] . '/' . $path . $_FILES['file']['name'];
		if(!is_file($filepath)){
			move_uploaded_file($_FILES['file']['tmp_name'], $filepath);
			$messages['ok'] = 'Datei wurde erfolgreich hochgeladen!';
		} else {
			//Datei existiert bereits
			$messages['error'] = 'Das gew&uuml;nschte Datei existiert bereits!';
		}
	}
	
	/*
	 * Verzeichnisinhalt laden
	 */
	$handle = opendir($_SERVER['DOCUMENT_ROOT'] . '/' . $path);
	
	//nach Verzeichnissen untersuchen und aufteilen
	$files = array();
	$dirs = array();
	
	while($file = readdir($handle)){ 
		$filepath = $_SERVER['DOCUMENT_ROOT'] . '/' . $path . $file;
		if(is_file($filepath)){
			$files[$file] = array();
			$files[$file]['name'] = $file;
			$files[$file]['lastchanged'] = date("Y-m-d H:i:s",filemtime($filepath));
			$files[$file]['size'] = filesize($filepath);
			$files[$file]['type'] = mime_content_type($filepath);
		} elseif($file != "." && $file != ".."){
			$dirs[$file] = $file;
		}
	}
?>
	
<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-drawer"></span> Dateiverwaltung</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie die Dateien auf dem Server bearbeiten und verwalten. Wählen Sie einfach ein Verzeichnis auf, um sich alle entsprechenden Dateien und Unterverzeichnisse ausgeben zu lassen.</p>
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

<div class="mask_table">

	<div class="filetree_path">
		<span class="path_title">Pfad:</span>
		<?php
			//Grundverzeichnis ausgeben
			if($path > ''){
				echo "<a class=\"root\" href=\"?tree=\">http://{$_SERVER['SERVER_NAME']}/</a>";
			} else {
				echo "<span class=\"root active\">http://{$_SERVER['SERVER_NAME']}/</span>";
			}
			
			//aktuellen Verzeichnispfad ausgeben
			if($path > ""){
				$sum_path = '';
				$split = split('/',$path);
				foreach($split as $dir){
					$sum_path .= $dir . '/';
					if($sum_path == $path){
						echo "<span class=\"active\">{$dir}/</span>";
						break;
					} else {
						echo "<a href=\"?tree={$sum_path}\">{$dir}/</a>";
					}
				}
			}
		?>
	</div>

	<table class="filetree" cellpadding=0 cellspacing=0>
		<?php
			$class = 'first';
			if($path > ''){
				echo "
					\t\t<tr class=\"{$class}\">\n
					\t\t\t<td class=\"icon\"></td>\n
					\t\t\t<td class=\"path\" style=\"width:auto;\"><a href=\"?tree={$subpath}\">..</a></td>\n
					\t\t\t<td class=\"lastchanged\"></td>\n
					\t\t\t<td class=\"size\"></td>\n
					\t\t\t<td class=\"type width_90 align_center hide_1050\"></td>\n
					\t\t\t<td class=\"action\"></td>\n
					\t\t\t<td class=\"action\"></td>\n
					\t\t</tr>\n";
					$class = '';
			}
			foreach($dirs as $dirname => $dir){ 
				echo "
					\t\t<tr class=\"{$class}\">\n
					\t\t\t<td class=\"icon\"><span class=\"icon icon-folder\"></span></td>\n
					\t\t\t<td class=\"path\" style=\"width:auto;\"><a href=\"?tree={$path}{$dirname}/\">{$dirname}</a></td>\n
					\t\t\t<td class=\"lastchanged\"></td>\n
					\t\t\t<td class=\"size\"></td>\n
					\t\t\t<td class=\"type width_90 align_center hide_1050\"></td>\n
					\t\t\t<td class=\"action\"></td>\n
					\t\t\t<td class=\"action\"><a href=\"?removeFile={$path}{$dirname}/\" class=\"icon icon-cancel-circle\" title=\"Verzeichnis l&ouml;schen\"></a></td>\n
					\t\t</tr>\n";
					$class = '';
			}
			foreach($files as $file){ 
				echo "
					\t\t<tr class=\"{$class}\">\n
					\t\t\t<td class=\"icon\"><span class=\"icon icon-file\"></span></td>\n
					\t\t\t<td class=\"path\" style=\"width:auto;\">{$file['name']}</td>\n
					\t\t\t<td class=\"lastchanged\">" . date("D, j. M Y", strtotime($file['lastchanged'])) . "</td>\n
					\t\t\t<td class=\"size\">{$file['size']} byte</td>\n
					\t\t\t<td class=\"type font_small width_90 align_center hide_1050\">{$file['type']}</td>\n
					\t\t\t<td class=\"action\"><a href=\"?tree={$path}{$file['name']}\" class=\"icon icon-pencil\" title=\"Datei bearbeiten\"></span></td>\n
					\t\t\t<td class=\"action\"><a href=\"?removeFile={$path}{$file['name']}\" class=\"icon icon-cancel-circle\" title=\"Datei l&ouml;schen\"></a></td>\n
					\t\t</tr>\n";
					$class = '';
			}
		?>
	</table>
	
</div>

<div class="mask_form">
	
	<?php
		$form = new Form();
		
		//Neues Verzeichnis anlegen
		$form->start("?tree={$path}","post");
		
		$form->row->printHidden("do","createDir");
		$form->row->start();
			$form->element->printTextfield("dirName","","","float:left; margin:0 10px 5px 0;");
			$form->element->printSubmit("Neues Verzeichnis anlegen","","","margin:0;");
		$form->row->end();
		
		$form->end();
		
		//Neues Datei hochladen
		$form->start("?tree={$path}","post","multipart/form-data");
		
		$form->row->printHidden("do","uploadFile");
		$form->row->start();
			$form->element->printUpload("file","","","float:left; margin:0 10px 5px 0;");
			$form->element->printSubmit("Neue Datei hochladen","","","margin:0;");
		$form->row->end();
		
		$form->end();
	?>

</div>