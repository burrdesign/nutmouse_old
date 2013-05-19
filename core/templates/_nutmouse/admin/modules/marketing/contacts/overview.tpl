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
	
	//Suchfilter für die Session setzen
	if(isset($_REQUEST['s_keywords'])){
		$_SESSION['prefs']['contacts']['s_keywords'] = $_REQUEST['s_keywords'];
	}
	if(isset($_REQUEST['s_group'])){
		$_SESSION['prefs']['contacts']['s_group'] = $_REQUEST['s_group'];
	}
	if(isset($_REQUEST['s_clear'])){
		unset($_SESSION['prefs']['contacts']['s_keywords']);
		unset($_SESSION['prefs']['contacts']['s_group']);
	}
	
	/*
	 * Kontaktgruppen laden
	 */
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT g.*, COUNT(c.contactKey) AS groupUserCnt FROM bd_main_contact_group g
		LEFT JOIN bd_main_contact c ON (c.contactGroupKey = g.groupKey)
		GROUP BY g.groupKey
		ORDER BY g.groupName
		");
	$groups = $sql->execute();
	$groupcnt = $sql->getLineCount("bd_main_contact_group");
	
	/*
	 * Kontakte laden (inkl. Suchfilter-Bedingungen)
	 */
	$where = "1=1";
	if(!empty($_SESSION['prefs']['contacts']['s_keywords'])){
		$keywords = split(" ", $_SESSION['prefs']['contacts']['s_keywords']);
		foreach($keywords as $keyword){
			$where .= " AND ( contactName LIKE '%" . $sql->escape($keyword) . "%'
				OR contactLastName LIKE '%" . $sql->escape($keyword) . "%'
				)";
		}
	}
	if(!empty($_SESSION['prefs']['contacts']['s_group'])){
		$where .= " AND contactGroupKey = " . $sql->escape($_SESSION['prefs']['contacts']['s_group'], "int");
	}
		
	$sql->setQuery("
		SELECT * FROM bd_main_contact
		WHERE {$where}
		LIMIT {{limit}}, {{winsize}}
		");
	$sql->bindParam("{{winsize}}",$winsize,"int");
	$sql->bindParam("{{limit}}",$limit,"int");
	$contacts = $sql->execute();
	
	//Anzahl ermitteln
	$sql->setQuery("
		SELECT COUNT(*) AS anzahl FROM bd_main_contact
		WHERE {$where}
		");
	$result = $sql->result();
	$contactcnt = $result['anzahl'];
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-user"></span> Kontakte</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie neue Kontakte und Kontaktgruppen anlegen, sowie vorhandene Kontakte verwalten. Sortieren Sie Ihre Kontakte Gruppen zu, um den &Uuml;berblick zu behalten.</p>
</div>

<div class="mask_left mask_list">
	
	<?php 
		//Suchformular
		echo "<div class=\"mask_search\">";
		$form = new Form();
		$form->start("","get");
		$form->element->printTextfield("s_keywords",$_SESSION['prefs']['users']['s_keywords'],"search_keywords","","","","Geben Sie hier Ihren Suchbegriff ein...");
		$form->element->printSubmit("suchen");
		$form->end();
		echo "</div>";
	
		if($contactcnt > 0) echo "\t<p>Es wurden <b>{$contactcnt}</b> Kontakte gefunden.</p>\n";

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
			//Kontakte ausgeben
			if($contactcnt == 0){
				echo "<p><i>Es wurden keine Kontakte gefunden!</i></p>\n";
			} else {
				//Paging
				if($contactcnt > $winsize){
					echo "
						\t<div class=\"list_paging\">\n
						\t\t<span class=\"title\">Seite:</span>\n";
					for($i=1; $i<=ceil($contactcnt/$winsize); $i++){
						$class = "";
						if($i == $page + 1){
							$class = "active";
						}
						echo "\t\t<a href=\"?page={$i}\" title=\"Gehe zu Seite {$i}\" class=\"{$class}\">{$i}</a>\n";
					}
					echo "\t</div>\n";
				}
				echo "\t<table class=\"list list_menus\" cellpadding=0 cellspacing=0>\n";
				while($contact = mysql_fetch_array($contacts)){
					echo "
						\t\t<tr class=\"\">\n
						\t\t\t<td class=\"key first width_30 align_center\">{$contact['contactKey']}</td>\n
						\t\t\t<td class=\"name width_200\">{$contact['contactName']} {$contact['contactLastName']}</td>\n
						\t\t\t<td class=\"action\"><a href=\"?editContact={$contact['contactKey']}\" class=\"icon icon-pencil\" title=\"Kontakt bearbeiten\"></a></td>\n
						\t\t\t<td class=\"action\"><a href=\"?removeContact={$contact['contactKey']}\" class=\"icon icon-cancel-circle\" title=\"Kontakt l&ouml;schen\"></a></td>\n
						\t\t</tr>\n";
				}
				echo "\t</table>\n";
			}
				
			//Neuen Kontakt anlegen
			$form = new Form();
			$form->element->printSubmitLink("Neuen Kontakt anlegen","?editContact=new");
		?>
	</div>
</div>

<div class="mask_right mask_groups">
	
	<div class="mask_intro" style="margin-top:30px; width:100%; float:left;">
		<h2 class="mask_title">
			<span class="icon icon-users"> Kontaktgruppen</span>
		</h2>
	</div>
	
	<div class="mask_table wrap_groupfilter">

		<?php 
			if($groupcnt == 0){
				echo "\t<p><i>Es wurden keine Kontaktgruppen gefunden!</i></p>\n";
			} else {
				echo "\t<table class=\"list list_admingroups list_filter\" cellpadding=0 cellspacing=0>\n";
				while($group = mysql_fetch_array($groups)){
					echo "
						\t\t<tr class=\"\">\n
						\t\t\t<td class=\"first title\">{$group['groupName']} ({$group['groupUserCnt']})</td>\n
						\t\t\t<td class=\"action\"><a href=\"?editContactGroup={$group['groupKey']}\" class=\"icon icon-pencil\" title=\"Gruppe bearbeiten\"></a></td>\n
						\t\t\t<td class=\"action\"><a href=\"?removeContactGroup={$group['groupKey']}\" class=\"icon icon-cancel-circle\" title=\"Gruppe l&ouml;schen\"></a></td>\n
						\t\t</tr>\n";
						$class = '';
				}
				echo "\t</table>\n";
			}
		
			$form = new Form();
			$form->element->printSubmitLink("Neue Kontaktgruppe anlegen","?editContactGroup=new");
		?>
		
	</div>
</div>