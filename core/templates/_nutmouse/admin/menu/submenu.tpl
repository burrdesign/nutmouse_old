<ul class="submenu">

<?php
	include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Db/SqlManager.php');
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT * FROM bd_sys_admin_menu
		WHERE menuParent > 0 AND ( menuType IS NULL OR menuType = '' ) AND menuActive = 1 AND menuParent = {{mainmenu}}
		ORDER BY menuPos
		");
	$sql->bindParam("{{mainmenu}}",$this->_['mainmenu'],"int");
	$menus = $sql->execute();
	while($menu = mysql_fetch_array($menus)){
		$class = 'submenu_' . $menu['menuKey'];
		if($this->_['submenu'] == $menu['menuKey']){
			$class .= ' active';
		}
		echo '<li><a href="/admin' . $menu['menuLink'] . '" class="' . $class . '"><span>' . $menu['menuLabel'] . '</span></a></li>';
	}
?>

</ul>