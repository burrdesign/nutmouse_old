<?php
	
	$page = $_REQUEST['page'] - 1;
	if(!$page || $page < 0){
		$page = 0;
	}
	
	$winsize = $_REQUEST['winsize'];
	if(!$winsize){
		$winsize = 10;
	}
	
	$limit = $page * $winsize;
	
	/*
	 * Neuigkeiten laden
	 */
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT * FROM bd_main_news
		ORDER BY newsReleaseDate DESC
		LIMIT {{limit}}, {{winsize}}
		");
	$sql->bindParam("{{winsize}}",$winsize,"int");
	$sql->bindParam("{{limit}}",$limit,"int");
	$newsquery = $sql->execute();
	$newscnt = $sql->getLineCount("bd_main_news");
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-newspaper"></span> News</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie Neuigkeiten anlegen und verwalten. Durch Neuigkeiten k&ouml;nnen Sie die Besucher Ihrer Website immer auf dem Laufenden halten.</p>
	<?php if($newscnt > 0) echo "\t<p>Es wurden <b>{$newscnt}</b> News gefunden.</p>\n"; ?>
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
		if($newscnt == 0){
			echo "\t<p><i>Es wurden keine News gefunden!</i></p>\n";
		} else {			
			//Paging
			if($newscnt > $winsize){
				echo "
					\t<div class=\"list_paging\">\n
					\t\t<span class=\"title\">Seite:</span>\n";
				for($i=1; $i<=ceil($newscnt/$winsize); $i++){
					$class = "";
					if($i == $page + 1){
						$class = "active";
					}
					echo "\t\t<a href=\"?page={$i}\" title=\"Gehe zu Seite {$i}\" class=\"{$class}\">{$i}</a>\n";
				}
				echo "\t</div>\n";
			}
			
			echo "\t<table class=\"list list_news\" cellpadding=0 cellspacing=0>\n";
			while($news = mysql_fetch_array($newsquery)){ 
				echo "
					\t\t<tr class=\"{$class}\">\n
					\t\t\t<td class=\"key first width_30 align_center\">{$news['newsKey']}</td>\n
					\t\t\t<td class=\"title\">{$news['newsTitle']}</td>\n
					\t\t\t<td class=\"releasedate width_120 font_small hide_650 align_right\">" . date("D, j. M Y", strtotime($news['newsReleaseDate'])) . "</td>\n
					\t\t\t<td class=\"action\"><a href=\"?editNews={$news['newsKey']}\" class=\"icon icon-pencil\" title=\"News bearbeiten\"></a></td>\n
					\t\t\t<td class=\"action\"><a href=\"?removeNews={$news['newsKey']}\" class=\"icon icon-cancel-circle\" title=\"News l&ouml;schen\"></a></td>\n
					\t\t</tr>\n";
					$class = '';
			}
			echo "\t</table>\n";
		}
	
		$form = new Form();
		$form->element->printSubmitLink("Neue News anlegen","?editNews=new");
	?>
	
</div>