<?php
	if($_SESSION['BURRDESIGN']['ADMIN']['login_errormsg']){
		echo "<div class=\"errormsg\">".$_SESSION['BURRDESIGN']['ADMIN']['login_errormsg']."</div>";
	}
	
	//Nach Logout die Action auf die Admin-Startseite setzen
	$action = "";
	if($_REQUEST['page'] == "admin/logout"){
		$action = "/admin/";
	}
?>

<form action="<?php echo $action; ?>" method="post">
	<label>Benutzer:</label>
    <input class="text" type="text" name="adminlogin_user" value="<?php echo $_REQUEST['adminlogin_user']; ?>" />
    <label>Passwort:</label>
    <input class="text" type="password" name="adminlogin_password" />
    <input class="submit" type="submit" name="adminlogin_submit" value="anmelden" />
</form>