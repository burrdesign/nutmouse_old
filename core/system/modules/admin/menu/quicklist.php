<?php
	//Quicklist laden
	$quicklist_res = sqlquery("
		SELECT * FROM bd_admin_quicklist
		WHERE qlistAdminUser = '".$_SESSION['BURRDESIGN']['ADMIN']['user']."' 
		ORDER BY qlistAddedDate");
?>
<div class="box_inner">

	<h2>Quicklist</h2>
    
    <?php
		if(mysql_num_rows($quicklist_res) <= 0){
			echo "<p class=\"noresult\">Es befinden sich zur Zeit keine Funktionen in der Quicklist.</p>";
		}
	?>

</div>