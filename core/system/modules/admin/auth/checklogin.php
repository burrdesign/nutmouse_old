<?php
	$_SESSION['BURRDESIGN']['ADMIN']['login_errormsg'] = "";

	if($_SESSION['BURRDESIGN']['ADMIN']['loggedin']){
		//Admin ist bereits erfolgreich eingeloggt
		return;
	}
	
	if($_POST['adminlogin_submit']){
		//Loginformular wurde abgesendet => verarbeiten + ggf. Anmeldung initialisieren
		$admin_user = sqlresult("
			SELECT * FROM bd_admin_user
			WHERE adminUserName = '".$_POST['adminlogin_user']."' AND adminUserPassword = '".md5($_POST['adminlogin_password'])."'
			LIMIT 1");
		
		if($admin_user['adminUserKey']){
			$_SESSION['BURRDESIGN']['ADMIN']['loggedin'] = $admin_user['adminUserKey'];
			$_SESSION['BURRDESIGN']['ADMIN']['user'] = $admin_user['adminUserName'];
			$_SESSION['BURRDESIGN']['ADMIN']['lastlogin'] = $admin_user['adminUserLastLogin'];
		} else {
			$_SESSION['BURRDESIGN']['ADMIN']['login_errormsg'] = "<p>Der angegebene Username oder das Passwort ist falsch!</p>";
		}
	}
?>