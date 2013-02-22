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
	 * Galerie laden
	 */
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT g.*, COUNT(i.imageKey) AS galeryImageCnt FROM bd_main_galery g
		LEFT JOIN bd_main_galery_image i ON (g.galeryKey = i.imageGaleryKey)
		GROUP BY galeryKey
		ORDER BY galeryDate DESC
		LIMIT {{limit}}, {{winsize}}
		");
	$sql->bindParam("{{winsize}}",$winsize,"int");
	$sql->bindParam("{{limit}}",$limit,"int");
	$galeryquery = $sql->execute();
	$galerycnt = $sql->getLineCount("bd_main_galery");
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-image"></span> Bildergalerien</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie Bildergalerien anlegen und verwalten. Diese k&ouml;nnen Sie sowohl mit Bildern, als auch mit erg&auml;nzenden Texten versehen.</p>
	<?php if($galerycnt > 0) echo "\t<p>Es wurden <b>{$galerycnt}</b> Bildergalerien gefunden.</p>\n"; ?>
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
		if($galerycnt == 0){
			echo "\t<p><i>Es wurden keine Bildergalerien gefunden!</i></p>\n";
		} else {			
			//Paging
			if($galerycnt > $winsize){
				echo "
					\t<div class=\"list_paging\">\n
					\t\t<span class=\"title\">Seite:</span>\n";
				for($i=1; $i<=ceil($menucnt/$winsize); $i++){
					$class = "";
					if($i == $page + 1){
						$class = "active";
					}
					echo "\t\t<a href=\"?page={$i}\" title=\"Gehe zu Seite {$i}\" class=\"{$class}\">{$i}</a>\n";
				}
				echo "\t</div>\n";
			}
			
			echo "\t<table class=\"list list_menus\" cellpadding=0 cellspacing=0>\n";
			while($galery = mysql_fetch_array($galeryquery)){
				$active_text = "<i>inaktiv</i>";
				if($galery['galeryActive'] == 1){
					$active_text = "aktiv";
				}
				echo "
					\t\t<tr class=\"{$class}\">\n
					\t\t\t<td class=\"key first width_30 align_center\">{$galery['galeryKey']}</td>\n
					\t\t\t<td class=\"title\">{$galery['galeryTitle']}</td>\n
					\t\t\t<td class=\"date width_120 font_small hide_650 align_center\">" . date("D, j. M Y", strtotime($galery['galeryDate'])) . "</td>\n
					\t\t\t<td class=\"cnt width_90 font_small hide_1050 align_center\">{$galery['galeryImageCnt']} Bilder</td>\n
					\t\t\t<td class=\"active width_30 font_small hide_650 align_center\">{$active_text}</td>\n
					\t\t\t<td class=\"action\"><a href=\"?editGalery={$galery['galeryKey']}\" class=\"icon icon-pencil\" title=\"Bildergalerie bearbeiten\"></a></td>\n
					\t\t\t<td class=\"action\"><a href=\"?removeGalery={$galery['galeryKey']}\" class=\"icon icon-cancel-circle\" title=\"Bildergalerie l&ouml;schen\"></a></td>\n
					\t\t</tr>\n";
					$class = '';
			}
			echo "\t</table>\n";
		}
	
		$form = new Form();
		$form->element->printSubmitLink("Neue Galerien anlegen","?editGalery=new");
	?>
	
</div>