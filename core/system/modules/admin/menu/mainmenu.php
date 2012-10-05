<?php

	/*************************************************************
	Modul zum ausgeben des Admin-Hauptmenüs dynamisch aus der DB
	Version 1.0
	Copyright by Julian Burr - 31.07.2012
	*************************************************************/

	//Menüeinträge laden
	$mainmenu_res = sqlquery("
		SELECT * FROM bd_admin_menu
		WHERE adminMenuActive = 1 AND (adminMenuParent IS NULL OR adminMenuParent = '') 
			AND (adminMenuType IS NULL OR adminMenuType = '') 
		ORDER BY adminMenuPos");
	//Apps laden
	$mainapps_res = sqlquery("
		SELECT * FROM bd_admin_menu
		WHERE adminMenuActive = 1 AND (adminMenuParent IS NULL OR adminMenuParent = '') 
			AND adminMenuType = 'app' 
		ORDER BY adminMenuPos");
?>
<ul>
	<!-- Nutmouse 1.0 (c) Burr Design - Julian Burr -->
	<li id="mainnav_li_bdlogo"><a href="/admin/info" class="lightbox" rel="version_info">BurrDesign</a></li>
	<?php	
		//Hauptmenü ausgeben
		while($mainmenu = mysql_fetch_array($mainmenu_res)){
				$class = "";
			if($mainmenu['adminMenuKey'] == $_SESSION['BURRDESIGN']['ADMIN']['current_page']['mainmenu_info']['adminMenuKey']){
				$class = "active";
			}
			echo "\t<li class=\"$class\" id=\"mainnav_li_".$mainmenu['adminMenuId']."\">
				<a href=\"".$mainmenu['adminMenuLinkHref']."\">
				".$mainmenu['adminMenuLabel']."</a></li>\n";
		}
	?>
</ul>
<ul class="apps">
	<?php
		//Apps ausgeben (getrennt, um sie bspw. anders zu floaten)
		while($mainapp = mysql_fetch_array($mainapps_res)){
			$class = "";
			if($mainapp['adminMenuKey'] == $_SESSION['BURRDESIGN']['ADMIN']['current_page']['mainmenu_info']['adminMenuKey']){
				$class = "active";
			}
			echo "\t<li class=\"$class\" id=\"mainnav_app_".$mainapp['adminMenuId']."\">
				<a href=\"".$mainapp['adminMenuLinkHref']."\" title=\"".$mainapp['adminMenuLabel']."\">
				".$mainapp['adminMenuLabel']."</a></li>\n";
		}
	?>
</ul>