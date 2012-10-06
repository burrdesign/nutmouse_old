<?php

	/****************************************************************
	Modul zum ausgeben der userspez. Quicklist in der Administration
	Version 0.1
	Copyright by Julian Burr - 31.07.2012
	****************************************************************/
	
	$sql = new SQLManager();
	$sql->setQuery("
		SELECT * FROM bd_admin_quicklist
		WHERE qlistAdminUser = '{{user}}' 
		ORDER BY qlistAddedDate");
	$sql->bindParam("{{user}}",$_SESSION['BURRDESIGN']['ADMIN']['user']);
	$quicklist_res = $sql->execute();
?>
<div class="box_inner">

	<h2>Quicklist</h2>
    
    <?php
		if(mysql_num_rows($quicklist_res) <= 0){
			echo "<p class=\"noresult\">Es befinden sich zur Zeit keine Funktionen in der Quicklist.</p>";
		}
	?>

</div>