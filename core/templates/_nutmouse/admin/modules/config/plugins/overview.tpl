<?php
	$pluginpath = $_SERVER['DOCUMENT_ROOT'] . '/core/classes/Plugins/';
	
	$page = $_REQUEST['page'] - 1;
	if(!$page || $page < 0){
		$page = 0;
	}
	
	$winsize = $_REQUEST['winsize'];
	if(!$winsize){
		$winsize = 10;
	}
	
	$limit = $page * $winsize;
	
	/**
	 * ACTIONPHASE
	 */
	if($this->_['post']['do'] == "uploadPlugin" && !empty($_FILES['file']['name'])){
		//neue Datei hochladen
		if(strpos($_FILES['file']['name'], ".zip") !== false){
			$pluginname = str_replace(".zip", "", $_FILES['file']['name']);
			$plugindir = $pluginpath . $pluginname . '/';
			$filepath = $plugindir . $_FILES['file']['name'];
			if(!is_dir($plugindir)){
				mkdir($plugindir); 
				move_uploaded_file($_FILES['file']['tmp_name'], $filepath);
				$zip = new ZipArchive();
				if($zip->open($filepath) === true){
					$zip->extractTo($plugindir);
					$zip->close();
					unlink($filepath);
					$messages['ok'] = 'Das Plugin wurde erfolgreich hochgeladen und entpackt!';
				} else {
					$messages['error'] = 'ZIP-Datei konnte nicht entpackt werden!';
				}
			} else {
				//Datei existiert bereits
				$messages['error'] = 'Das gew&uuml;nschte Plugin existiert bereits!';
			}
		} else {
			$messages['error'] = 'Bitte laden Sie nur ZIP-Dateien hoch!';
		}
	} elseif(!empty($this->_['get']['install'])){
		//Plugin installieren
		$installpath = $pluginpath . $this->_['get']['install'] . '/' . $this->_['get']['install'] . '.php';
		if(is_file($installpath)){
			include_once($installpath);
			$plugin = new $this->_['get']['install']();
			if(method_exists($plugin, 'install')){
				$plugin->install();
				$messages['ok'] = 'Das Plugin wurde erfolgreich installiert!';
			} else {
				$messages['error'] = 'Das Plugin konnte nicht installiert werden!';
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	} elseif(!empty($this->_['get']['uninstall'])){
		//Plugin deinstallieren
		$uninstallpath = $pluginpath . $this->_['get']['uninstall'] . '/' . $this->_['get']['uninstall'] . '.php';
		if(is_file($uninstallpath)){
			include_once($uninstallpath);
			$plugin = new $this->_['get']['uninstall']();
			if(method_exists($plugin, 'uninstall')){
				$plugin->uninstall();
				$messages['ok'] = 'Das Plugin wurde erfolgreich deinstalliert!';
			} else {
				$messages['error'] = 'Das Plugin konnte nicht deinstalliert werden!';
			}
		} else {
			$messages['error'] = 'Es ist ein Fehler aufgetreten!';
		}
	} 
	 
	/**
	 * vorhandene Plugins laden
	 */
	$pluginlist = array();
	if(is_dir($pluginpath)){
		$handle = opendir($pluginpath);
		while($plugin = readdir($handle)){
			$test = $pluginpath . $plugin;
			if(is_dir($test) && $plugin != "." && $plugin != ".."){
				$pluginlist[] = $plugin;
			}
		}
	} else {
		$messages['error'] = 'Pluginverzeichnis konnte nicht gefunden werden!';
	}
	$plugincnt = count($pluginlist);
	
	if($limit >= $plugincnt){
		$limit = 0;
	}
	
	/**
	 * installierte Plugins laden
	 */
	$installedplugin = array();
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT * FROM bd_sys_plugin
		");
	$query = $sql->execute();
	while($p = mysql_fetch_array($query)){
		$installedplugin[$p['pluginName']] = $p;
	}
	
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-lab"></span> Plugins</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie Plugins installieren, hochladen und verwalten. Plugins k&ouml;nnen verwendet werden, um die Systemfunktionen nach eigenen W&uuml;nschen und Vorhaben zu erweitern.</p>
	<?php if($plugincnt > 0) echo "\t<p>Es wurden <b>{$plugincnt}</b> Plugins gefunden.</p>\n"; ?>
</div>

<?php
	if(is_array($messages)){
		echo "<div class=\"mask_messages\">\n";
		foreach($messages as $msg_type => $msg_text){
			echo "\t<span class=\"clear\"></span>\n";
			echo "\t<div class=\"message message_{$msg_type}\"><span class=\"icon\"></span><span class=\"text\">{$msg_text}</span></div>\n";
		}
		echo "</div>\n";
	}
?>

<div class="mask_table">

	<?php 
		if($plugincnt == 0){
			echo "\t<p><i>Es wurden keine Plugins gefunden!</i></p>\n";
		} else {			
			//Paging
			if($plugincnt > $winsize){
				echo "
					\t<div class=\"list_paging\">\n
					\t\t<span class=\"title\">Seite:</span>\n";
				for($i=1; $i<=ceil($plugincnt/$winsize); $i++){
					$class = "";
					if($i == $page + 1){
						$class = "active";
					}
					echo "\t\t<a href=\"?page={$i}\" title=\"Gehe zu Seite {$i}\" class=\"{$class}\">{$i}</a>\n";
				}
				echo "\t</div>\n";
			}
			
			echo "\t<table class=\"list list_news\" cellpadding=0 cellspacing=0>\n";
			for($i=$limit; $i<$limit+$winsize; $i++){
				if($i >= $plugincnt){
					break;
				}
			
				echo "\t\t<tr class=\"{$class}\">\n";
				
				//prüfen, ob Plugin bereits installiert ist
				if(is_array($installedplugin[$pluginlist[$i]])){
					$plugin = $installedplugin[$pluginlist[$i]];
					echo "
						\t\t\t<td class=\"title first width_200\">{$plugin['pluginName']}</td>\n
						\t\t\t<td class=\"desc font_small hide_650 align_left\">{$plugin['pluginDesc']}</td>\n
						\t\t\t<td class=\"installdate width_120 font_small hide_1050 align_right\">" . date("D, j. M Y", strtotime($plugin['pluginInstalled'])) . "</td>\n
						\t\t\t<td class=\"action\"></td>\n
						\t\t\t<td class=\"action\"><a href=\"?page={$_REQUEST['page']}&uninstall={$plugin['pluginName']}\" class=\"icon icon-arrow-down\" title=\"Plugin deinstallieren\"></a></td>\n";
					
				} else {
					$plugin['pluginName'] = $pluginlist[$i];
					
					echo "
						\t\t\t<td class=\"title first width_200\">{$plugin['pluginName']}</td>\n
						\t\t\t<td class=\"desc font_small hide_650 align_left\"></td>\n
						\t\t\t<td class=\"installdate width_120 font_small hide_1050 align_right\"></td>\n
						\t\t\t<td class=\"action\"><a href=\"?page={$_REQUEST['page']}&install={$plugin['pluginName']}\" class=\"icon icon-arrow-up\" title=\"Plugin installieren\"></a></td>\n
						\t\t\t<td class=\"action\"><a href=\"?page={$_REQUEST['page']}&removePlugin={$plugin['pluginName']}\" class=\"icon icon-cancel-circle\" title=\"Plugin entfernen\"></a></td>\n";
				}

				echo "\t\t</tr>\n";
				$class = '';
			}
			echo "\t</table>\n";
		}
	?>
	
	
</div>

<div class="mask_form">

	<?php
		//Neues Plugin hochladen
		$form = new Form();
		$form->start("?page={$_REQUEST['page']}","post","multipart/form-data");
		
		$form->row->printHidden("do","uploadPlugin");
		$form->row->start();
			$form->element->printUpload("file","","","float:left; margin:0 10px 5px 0;");
			$form->element->printSubmit("Plugin hochladen","","","margin:0;");
		$form->row->end();
		
		$form->end();
	?>
	

</div>