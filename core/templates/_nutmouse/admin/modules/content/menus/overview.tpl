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
		SELECT * FROM bd_main_menu
		ORDER BY menuName
		LIMIT {{limit}}, {{winsize}}
		");
	$sql->bindParam("{{winsize}}",$winsize,"int");
	$sql->bindParam("{{limit}}",$limit,"int");
	$menuquery = $sql->execute();
	$menucnt = $sql->getLineCount("bd_main_menu");
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-tree"></span> Men&uuml;s</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie Men&uuml;s anlegen und verwalten, die Sie dann sp&auml;ter in Ihre Website einbinden k&ouml;nnen. Men&uuml;s dienen in erster Linie der Strukturierung Ihrer Website und der Navigation des Users. Die Men&uuml;s können aus beliebig vielen Men&uuml;elementen bestehen, die wiederum in einer Baumstruktur beliebig tief verschachtelt sein k&ouml;nnen.</p>
	<?php if($menucnt > 0) echo "\t<p>Es wurden <b>{$menucnt}</b> Men&uuml; gefunden.</p>\n"; ?>
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
		if($menucnt == 0){
			echo "\t<p><i>Es wurden keine Men&uuml;s gefunden!</i></p>\n";
		} else {			
			//Paging
			if($menucnt > $winsize){
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
			while($menu = mysql_fetch_array($menuquery)){
				$active_text = "<i>inaktiv</i>";
				if($menu['menuActive'] == 1){
					$active_text = "aktiv";
				}
				echo "
					\t\t<tr class=\"{$class}\">\n
					\t\t\t<td class=\"key first width_30 align_center\">{$menu['menuKey']}</td>\n
					\t\t\t<td class=\"title\">{$menu['menuName']}</td>\n
					\t\t\t<td class=\"active width_30 font_small hide_650 align_center\">{$active_text}</td>\n
					\t\t\t<td class=\"action\"><a href=\"?editMenu={$menu['menuKey']}\" class=\"icon icon-pencil\" title=\"Men&uuml; bearbeiten\"></a></td>\n
					\t\t\t<td class=\"action\"><a href=\"?removeMenu={$menu['menuKey']}\" class=\"icon icon-cancel-circle\" title=\"Men&uuml; l&ouml;schen\"></a></td>\n
					\t\t</tr>\n";
					$class = '';
			}
			echo "\t</table>\n";
		}
	
		$form = new Form();
		$form->element->printSubmitLink("Neues Men&uuml; anlegen","?editMenu=new");
	?>
	
</div>