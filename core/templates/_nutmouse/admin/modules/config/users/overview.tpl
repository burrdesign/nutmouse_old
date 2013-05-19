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
		$_SESSION['prefs']['users']['s_keywords'] = $_REQUEST['s_keywords'];
	}
	if(isset($_REQUEST['s_group'])){
		$_SESSION['prefs']['users']['s_group'] = $_REQUEST['s_group'];
	}
	if(isset($_REQUEST['s_clear'])){
		unset($_SESSION['prefs']['users']['s_keywords']);
		unset($_SESSION['prefs']['users']['s_group']);
	}
	
	/*
	 * Benutzergruppen laden
	 */
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT g.*, COUNT(u.adminKey) AS groupUserCnt FROM bd_sys_admin_group g
		LEFT JOIN bd_sys_admin_user u ON (u.adminGroupKey = g.groupKey)
		GROUP BY g.groupKey
		ORDER BY g.groupName
		");
	$groups = $sql->execute();
	$groupcnt = $sql->getLineCount("bd_sys_admin_group");
	
	/*
	 * Benutzer laden (inkl. Suchfilter-Bedingungen)
	 */
	$where = "1=1";
	if(!empty($_SESSION['prefs']['users']['s_keywords'])){
		$keywords = split(" ", $_SESSION['prefs']['users']['s_keywords']);
		foreach($keywords as $keyword){
			$where .= " AND ( adminLogin LIKE '%" . $sql->escape($keyword) . "%' 
				OR adminName LIKE '%" . $sql->escape($keyword) . "%'
				OR adminLastName LIKE '%" . $sql->escape($keyword) . "%'
				)";
		}
	}
	if(!empty($_SESSION['prefs']['users']['s_group'])){
		$where .= " AND adminGroupKey = " . $sql->escape($_SESSION['prefs']['users']['s_group'], "int");
	}
		
	$sql->setQuery("
		SELECT * FROM bd_sys_admin_user
		WHERE {$where}
		LIMIT {{limit}}, {{winsize}}
		");
	$sql->bindParam("{{winsize}}",$winsize,"int");
	$sql->bindParam("{{limit}}",$limit,"int");
	$admins = $sql->execute();
	
	//Anzahl ermitteln
	$sql->setQuery("
		SELECT COUNT(*) AS anzahl FROM bd_sys_admin_user
		WHERE {$where}
		");
	$result = $sql->result();
	$admincnt = $result['anzahl'];
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-user"></span> Benutzerverwaltung</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie neue Benutzergruppen und Benutzer anlegen, sowie vorhandene Benutzer verwalten. Außerdem haben Sie hier die Möglichkeit, einzelnen Benutzergruppen bestimmte Rechte zuzuweisen.</p>
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
	
		if($admincnt > 0) echo "\t<p>Es wurden <b>{$admincnt}</b> Benutzer gefunden.</p>\n";

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
			//Adminuser ausgeben
			if($admincnt == 0){
				echo "<p><i>Es wurden keine Benutzer gefunden!</i></p>\n";
			} else {
				//Paging
				if($admincnt > $winsize){
					echo "
						\t<div class=\"list_paging\">\n
						\t\t<span class=\"title\">Seite:</span>\n";
					for($i=1; $i<=ceil($admincnt/$winsize); $i++){
						$class = "";
						if($i == $page + 1){
							$class = "active";
						}
						echo "\t\t<a href=\"?page={$i}\" title=\"Gehe zu Seite {$i}\" class=\"{$class}\">{$i}</a>\n";
					}
					echo "\t</div>\n";
				}
				echo "\t<table class=\"list list_menus\" cellpadding=0 cellspacing=0>\n";
				while($user = mysql_fetch_array($admins)){
					echo "
						\t\t<tr class=\"\">\n
						\t\t\t<td class=\"key first width_30 align_center\">{$user['adminKey']}</td>\n
						\t\t\t<td class=\"login\">{$user['adminLogin']}</td>\n
						\t\t\t<td class=\"name width_200 font_small hide_1050 align_left\">{$user['adminName']} {$user['adminLastName']}</td>\n
						\t\t\t<td class=\"lastlogin width_120 font_small hide_1050 align_center\">" . date("D, j. M Y", strtotime($user['adminLastLogin'])) . "</td>\n
						\t\t\t<td class=\"action\"><a href=\"?editUser={$user['adminKey']}\" class=\"icon icon-pencil\" title=\"Benutzer bearbeiten\"></a></td>\n
						\t\t\t<td class=\"action\"><a href=\"?removeUser={$user['adminKey']}\" class=\"icon icon-cancel-circle\" title=\"Benutzer l&ouml;schen\"></a></td>\n
						\t\t</tr>\n";
				}
				echo "\t</table>\n";
			}
				
			//Neuen Benutzer anlegen
			$form = new Form();
			$form->element->printSubmitLink("Neuen Benutzer anlegen","?editUser=new");
		?>
	</div>
</div>

<div class="mask_right mask_groups">
	
	<div class="mask_intro" style="margin-top:30px; width:100%; float:left;">
		<h2 class="mask_title">
			<span class="icon icon-users"> Benutzergruppen</span>
		</h2>
	</div>
	
	<div class="mask_table wrap_groupfilter">

		<?php 
			if($groupcnt == 0){
				echo "\t<p><i>Es wurden keine Benutzergruppen gefunden!</i></p>\n";
			} else {				
				echo "\t<table class=\"list list_admingroups list_filter\" cellpadding=0 cellspacing=0>\n";
				while($group = mysql_fetch_array($groups)){
					echo "
						\t\t<tr class=\"\">\n
						\t\t\t<td class=\"first title\">{$group['groupName']} ({$group['groupUserCnt']})</td>\n
						\t\t\t<td class=\"action\"><a href=\"?editUserGroup={$group['groupKey']}\" class=\"icon icon-pencil\" title=\"Gruppe bearbeiten\"></a></td>\n
						\t\t\t<td class=\"action\"><a href=\"?removeUserGroup={$group['groupKey']}\" class=\"icon icon-cancel-circle\" title=\"Gruppe l&ouml;schen\"></a></td>\n
						\t\t</tr>\n";
						$class = '';
				}
				echo "\t</table>\n";
			}
		
			$form = new Form();
			$form->element->printSubmitLink("Neue Benutzergruppe anlegen","?editUserGroup=new");
		?>
		
	</div>
</div>