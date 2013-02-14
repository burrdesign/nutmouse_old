<div class="logo"></div>

<ul class="mainmenu">

<li class="trenner"></li>

<?php
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/db/SqlManager.php');
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT * FROM bd_sys_admin_menu
		WHERE menuParent IS NULL AND ( menuType IS NULL OR menuType = '' ) AND menuActive = 1
		ORDER BY menuPos
		");
	$menus = $sql->execute();
	while($menu = mysql_fetch_array($menus)){
		$class = 'mainmenu_'.$menu['menuKey'];
		if($this->_['mainmenu'] == $menu['menuKey']){
			$class .= ' active';
		}
		echo '<li><a href="/admin' . $menu['menuLink'] . '" class="' . $class . '"><span>' . $menu['menuLabel'] . '</span></a></li>';
	}
?>

</ul>

<ul class="icons">

<li class="trenner"></li>

<?php
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT * FROM bd_sys_admin_menu
		WHERE menuParent IS NULL AND menuType = 'icon' AND menuActive = 1
		ORDER BY menuPos
		");
	$menus = $sql->execute();
	while($menu = mysql_fetch_array($menus)){
		$lowercase = strtolower($menu['menuLabel']);
		$lowercase = str_replace(" ", "_", $lowercase);
		$class = 'icon_' . $menu['menuKey'] . ' icon_'.$lowercase;
		if($this->_['mainmenu'] == $menu['menuKey']){
			$class .= ' active';
		}
		echo '<li><a href="/admin' . $menu['menuLink'] . '" class="' . $class . '"><span class="icon"></span><span class="title">' . $menu['menuLabel'] . '</span></a></li>';
	}
?>

<li><a href="/admin/logout" class="icon_logout"><span class="icon"></span><span class="title">Logout</span></a></li>
	
</ul>