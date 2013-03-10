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
	 * Benutzergruppen laden
	 */
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT g.*, COUNT(u.adminKey) AS groupUserCnt FROM bd_sys_admin_group g
		LEFT JOIN bd_sys_admin_user u ON (u.adminGroupKey = g.groupKey)
		GROUP BY g.groupKey
		ORDER BY g.groupName
		LIMIT {{limit}}, {{winsize}}
		");
	$sql->bindParam("{{winsize}}",$winsize,"int");
	$sql->bindParam("{{limit}}",$limit,"int");
	$groups = $sql->execute();
	$groupcnt = $sql->getLineCount("bd_sys_admin_group");
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-users"></span> Benutzergruppen</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie neue Benutzergruppen und Benutzer anlegen, sowie vorhandene Benutzer verwalten. Außerdem haben Sie hier die Möglichkeit, einzelnen Benutzergruppen bestimmte Rechte zuzuweisen.</p>
	<?php if($groupcnt > 0) echo "\t<p>Es wurden <b>{$groupcnt}</b> Benutzergruppen gefunden.</p>\n"; ?>
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
		if($groupcnt == 0){
			echo "\t<p><i>Es wurden keine Benutzergruppen gefunden!</i></p>\n";
		} else {			
			//Paging
			if($groupcnt > $winsize){
				echo "
					\t<div class=\"list_paging\">\n
					\t\t<span class=\"title\">Seite:</span>\n";
				for($i=1; $i<=ceil($groupcnt/$winsize); $i++){
					$class = "";
					if($i == $page + 1){
						$class = "active";
					}
					echo "\t\t<a href=\"?page={$i}\" title=\"Gehe zu Seite {$i}\" class=\"{$class}\">{$i}</a>\n";
				}
				echo "\t</div>\n";
			}
			
			echo "\t<table class=\"list list_menus\" cellpadding=0 cellspacing=0>\n";
			while($group = mysql_fetch_array($groups)){
				echo "
					\t\t<tr class=\"{$class}\">\n
					\t\t\t<td class=\"key first width_30 align_center\">{$group['groupKey']}</td>\n
					\t\t\t<td class=\"title\">{$group['groupName']}</td>\n
					\t\t\t<td class=\"cnt width_200 font_small hide_1050 align_right\">{$group['groupUserCnt']} Benutzer zugeordnet</td>\n
					\t\t\t<td class=\"action\"><a href=\"?editUserGroup={$group['groupKey']}\" class=\"icon icon-pencil\" title=\"Bildergalerie bearbeiten\"></a></td>\n
					\t\t\t<td class=\"action\"><a href=\"?removeUserGroup={$group['groupKey']}\" class=\"icon icon-cancel-circle\" title=\"Bildergalerie l&ouml;schen\"></a></td>\n
					\t\t</tr>\n";
					$class = '';
			}
			echo "\t</table>\n";
		}
	
		$form = new Form();
		$form->element->printSubmitLink("Neue Benutzergruppe anlegen","?editUserGroup=new");
	?>
	
</div>