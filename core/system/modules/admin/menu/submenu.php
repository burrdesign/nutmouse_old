<?php
	//Untermenüs laden
	$submenu_res = sqlquery("
		SELECT * FROM bd_admin_menu
		WHERE adminMenuActive = 1 AND adminMenuParent = '".(int)$_SESSION['BURRDESIGN']['ADMIN']['current_page']['mainmenu_info']['adminMenuKey']."'
			AND (adminMenuType IS NULL OR adminMenuType = '') 
		ORDER BY adminMenuPos");
?>
<div class="desc">
	<div class="box_inner">
        <?php echo $_SESSION['BURRDESIGN']['ADMIN']['current_page']['mainmenu_info']['adminMenuDesc']; ?>
    </div>
</div>
<ul>
	<?php	
		while($submenu = mysql_fetch_array($submenu_res)){
				$class = "";
			if($submenu['adminMenuKey'] == $_SESSION['BURRDESIGN']['ADMIN']['current_page']['menu_info']['adminMenuKey']){
				$class = "active";
			}
			echo "\t<li class=\"$class\" id=\"subnav_li_".$submenu['adminMenuId']."\">
				<a href=\"".$submenu['adminMenuLinkHref']."\"><span class=\"label\">
				".$submenu['adminMenuLabel']."</span></a></li>\n";
		}
	?>
</ul>