<?php
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/db/SqlManager.php');
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/admin/Form.php');
	
	$path = $_REQUEST['tree'];
	$split = split('/',$path);
	$subpath = str_replace($split[count($split)-2] . '/','',$path);
	
	/*
	 * Seiteninhalte laden
	 */
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT * FROM bd_main_content
		LEFT JOIN bd_main_content_version ON (contentKey = versionContentKey)
		WHERE contentPath LIKE '{{path}}%'
		GROUP BY contentPath
		");
	$sql->bindParam("{{path}}",$path);
	$sites = $sql->execute();
	
	$contents = array();
	while($site = mysql_fetch_array($sites)){
		$contents[] = $site;
	}
	
	//und nach Verzeichnissen untersuchen und aufteilen
	$sites = array();
	$dirs = array();
	
	foreach($contents as $content){ 
		$rel_path = str_replace($path,"",$content['contentPath']);
		$split = split('/', $rel_path);
		if(count($split) > 1){
			//geladerener Content ist in einem tieferen Verzeichnis
			$dirs[$split[0]] = $content;
		} else {
			$sites[$rel_path] = $content;
		}
	}
?>
	
<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-file-3"></span> Seiteninhalte</h2>
	<p class="mask_desc">Bearbeiten und verwalten Sie hier Ihre Seiteninhalte der Website. &Auml;nderungen, die Sie hier vornehmen, werden sofort wirksam und im Frontend sichtbar.</p>
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
					\t\t\t<td class=\"path\"><a href=\"?tree={$subpath}\">..</a></td>\n
					\t\t\t<td class=\"title\"></td>\n
					\t\t\t<td class=\"lastchanged\"></td>\n
					\t\t\t<td class=\"size\"></td>\n
					\t\t\t<td class=\"action\"></td>\n
					\t\t\t<td class=\"action\"></td>\n
					\t\t</tr>\n";
					$class = '';
			}
			foreach($dirs as $dirname => $dir){ 
				echo "
					\t\t<tr class=\"{$class}\">\n
					\t\t\t<td class=\"icon\"><span class=\"icon icon-folder\"></span></td>\n
					\t\t\t<td class=\"path\"><a href=\"?tree={$path}{$dirname}/\">{$dirname}</a></td>\n
					\t\t\t<td class=\"title\"></td>\n
					\t\t\t<td class=\"lastchanged\"></td>\n
					\t\t\t<td class=\"size\"></td>\n
					\t\t\t<td class=\"action\"></td>\n
					\t\t\t<td class=\"action\"></td>\n
					\t\t</tr>\n";
					$class = '';
			}
			foreach($sites as $rel_path => $content){ 
				echo "
					\t\t<tr class=\"{$class}\">\n
					\t\t\t<td class=\"icon\"><span class=\"icon icon-file\"></span></td>\n
					\t\t\t<td class=\"path\">{$rel_path}</td>\n
					\t\t\t<td class=\"title\">{$content['contentTitle']}</td>\n
					\t\t\t<td class=\"lastchanged\">" . date("D, j. M Y", strtotime($content['versionLastChanged'])) . "</td>\n
					\t\t\t<td class=\"size\">" . strlen($content['versionText']) . " byte</td>\n
					\t\t\t<td class=\"action\"><a href=\"?editFile={$content['contentKey']}\" class=\"icon icon-pencil\" title=\"Inhalt bearbeiten\"></span></td>\n
					\t\t\t<td class=\"action\"><a href=\"?removeFile={$content['contentKey']}\" class=\"icon icon-cancel-circle\" title=\"Inhalt l&ouml;schen\"></a></td>\n
					\t\t</tr>\n";
					$class = '';
			}
		?>
	</table>
	
	<?php
		$form = new Form();
		$form->element->printSubmitLink("Neuen Seiteninhalt anlegen","?editFile=new");
	?>
</div>