<?php

	//Login-Session löschen
	unset($_SESSION['BURRDESIGN']['ADMIN']);
	unset($_SESSION['BURRDESIGN']['CONFIG']);
	
	echo "<div class=\"okmsg\">Sie wurden erfolgreich abgemeldet!</div>";
	
	//Loginformular einblenden
	include($_SERVER['DOCUMENT_ROOT']."core/system/modules/admin/auth/loginform.php");
	
?>