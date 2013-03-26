<ul>

<?php
	
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT * FROM bd_main_menu_element
		WHERE elementMenuKey = 4 AND ( elementParent IS NULL OR elementParent = '' OR elementParent = 0 )
		ORDER BY elementPos
		");
	$elements = $sql->execute();
	
	while($element = mysql_fetch_array($elements)){
		echo "\t<li><a href=\"{$element['elementLink']}\">{$element['elementLabel']}</a></li>\n";
	}
	
?>

</ul>