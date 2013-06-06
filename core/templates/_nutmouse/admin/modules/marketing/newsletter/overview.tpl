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
		$_SESSION['prefs']['newsletter']['s_keywords'] = $_REQUEST['s_keywords'];
	}
	if(isset($_REQUEST['s_theme'])){
		$_SESSION['prefs']['newsletter']['s_theme'] = $_REQUEST['s_theme'];
	}
	if(isset($_REQUEST['s_clear'])){
		unset($_SESSION['prefs']['newsletter']['s_keywords']);
		unset($_SESSION['prefs']['newsletter']['s_theme']);
	}
	
	/*
	 * Newsletter-Themen laden
	 */
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT t.*, COUNT(n.newsletterKey) AS themeNewsletterCnt FROM bd_main_newsletter_theme t
		LEFT JOIN bd_main_newsletter n ON (n.newsletterThemeKey = t.themeKey)
		GROUP BY t.themeKey
		ORDER BY t.themeName
		");
	$themes = $sql->execute();
	$themecnt = $sql->getLineCount("bd_main_newsletter_theme");
	
	/*
	 * Newsletter laden (inkl. Suchfilter-Bedingungen)
	 */
	$where = "1=1";
	if(!empty($_SESSION['prefs']['newsletter']['s_keywords'])){
		$keywords = split(" ", $_SESSION['prefs']['newsletter']['s_keywords']);
		foreach($keywords as $keyword){
			$where .= " AND ( newsletterSubject LIKE '%" . $sql->escape($keyword) . "%'
				OR newsletterText LIKE '%" . $sql->escape($keyword) . "%'
				)";
		}
	}
	if(!empty($_SESSION['prefs']['newsletter']['s_theme'])){
		$where .= " AND newsletterThemeKey = " . $sql->escape($_SESSION['prefs']['newsletter']['s_theme'], "int");
	}
		
	$sql->setQuery("
		SELECT * FROM bd_main_newsletter
		WHERE {$where}
		ORDER BY newsletterDate
		LIMIT {{limit}}, {{winsize}}
		");
	$sql->bindParam("{{winsize}}",$winsize,"int");
	$sql->bindParam("{{limit}}",$limit,"int");
	$newsletters = $sql->execute();
	
	//Anzahl ermitteln
	$sql->setQuery("
		SELECT COUNT(*) AS anzahl FROM bd_main_newsletter
		WHERE {$where}
		");
	$result = $sql->result();
	$newslettercnt = $result['anzahl'];
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-bullhorn"></span> Newsletterverwaltung</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie neue Newsletter und Newsletter-Themen anlegen, sowie vorhandene Newsletter verwalten. Des weiteren k&ouml;nnen Sie hier Newsletter den Themen zuordnen, sie versenden und archivieren.</p>
</div>

<div class="mask_left mask_list">
	
	<?php 
		//Suchformular
		echo "<div class=\"mask_search\">";
		$form = new Form();
		$form->start("","get");
		$form->element->printTextfield("s_keywords",$_SESSION['prefs']['newsletter']['s_keywords'],"search_keywords","","","","Geben Sie hier Ihren Suchbegriff ein...");
		$form->element->printSubmit("suchen");
		$form->end();
		echo "</div>";
	
		if($newslettercnt > 0) echo "\t<p>Es wurden <b>{$newslettercnt}</b> Newsletter gefunden.</p>\n";

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
			//Newsletter ausgeben
			if($newslettercnt == 0){
				echo "<p><i>Es wurden keine Newsletter gefunden!</i></p>\n";
			} else {
				//Paging
				if($newslettercnt > $winsize){
					echo "
						\t<div class=\"list_paging\">\n
						\t\t<span class=\"title\">Seite:</span>\n";
					for($i=1; $i<=ceil($newslettercnt/$winsize); $i++){
						$class = "";
						if($i == $page + 1){
							$class = "active";
						}
						echo "\t\t<a href=\"?page={$i}\" title=\"Gehe zu Seite {$i}\" class=\"{$class}\">{$i}</a>\n";
					}
					echo "\t</div>\n";
				}
				echo "\t<table class=\"list list_menus\" cellpadding=0 cellspacing=0>\n";
				while($newsletter = mysql_fetch_array($newsletters)){
					echo "
						\t\t<tr class=\"\">\n
						\t\t\t<td class=\"key first width_30 align_center\">{$newsletter['newsletterKey']}</td>\n
						\t\t\t<td class=\"date font_small width_120 align_center hide_650\">" . date("D, j. M Y", strtotime($newsletter['newsletterDate'])) . "</td>\n
						\t\t\t<td class=\"subject\">{$newsletter['newsletterSubject']}</td>\n
						\t\t\t<td class=\"action\"><a href=\"?editNewsletter={$newsletter['newsletterKey']}\" class=\"icon icon-pencil\" title=\"Newsletter bearbeiten\"></a></td>\n
						\t\t\t<td class=\"action\"><a href=\"?removeNewsletter={$newsletter['newsletterKey']}\" class=\"icon icon-cancel-circle\" title=\"Newsletter l&ouml;schen\"></a></td>\n
						\t\t</tr>\n";
				}
				echo "\t</table>\n";
			}
				
			//Neuen Newsletter anlegen
			$form = new Form();
			$form->element->printSubmitLink("Neuen Newsletter anlegen","?editNewsletter=new");
		?>
	</div>
</div>

<div class="mask_right mask_groups">
	
	<div class="mask_intro" style="margin-top:30px; width:100%; float:left;">
		<h2 class="mask_title">
			<span class="icon icon-bookmarks"> Themen</span>
		</h2>
	</div>
	
	<div class="mask_table wrap_groupfilter">

		<?php 
			if($themecnt == 0){
				echo "\t<p><i>Es wurden keine Newsletter-Themen gefunden!</i></p>\n";
			} else {
				echo "\t<table class=\"list list_admingroups list_filter\" cellpadding=0 cellspacing=0>\n";
				while($theme = mysql_fetch_array($themes)){
					echo "
						\t\t<tr class=\"\">\n
						\t\t\t<td class=\"first title\">{$theme['themeName']} ({$theme['themeNewsletterCnt']})</td>\n
						\t\t\t<td class=\"action\"><a href=\"?editNewsletterTheme={$theme['themeKey']}\" class=\"icon icon-pencil\" title=\"Thema bearbeiten\"></a></td>\n
						\t\t\t<td class=\"action\"><a href=\"?removeNewsletterTheme={$theme['themeKey']}\" class=\"icon icon-cancel-circle\" title=\"Thema l&ouml;schen\"></a></td>\n
						\t\t</tr>\n";
						$class = '';
				}
				echo "\t</table>\n";
			}
		
			$form = new Form();
			$form->element->printSubmitLink("Neues Thema anlegen","?editNewsletterTheme=new");
		?>
		
	</div>
</div>