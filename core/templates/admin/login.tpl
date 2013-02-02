<!doctype html>
<html>
<head>
	<title>NutMouse v0.1 Administration</title>
	<link rel="stylesheet" href="/css/admin/style.css">
	
	<link rel="stylesheet" href="/img/icons/iconfont/style.css">
	<!--[if lte IE 7]><script type="text/javascript" src="/img/icons/iconfont/lte-ie7.js"></script><![endif]-->
</head>
<body class="login">

	<div class="wrap_all">
	
		<div class="wrap_loginmask">
			<div class="loginmask_intro">
				<h2><span class="icon"></span> NutMouse CMS</h2>
			</div>
			<div class="loginmask_message">
				<?php
					if($this->_['login_message']){
						echo "<div class=\"message message_".$this->_['login_message']['type']."\"><span class=\"icon\"></span><span class=\"text\">".$this->_['login_message']['text']."</span>";
					}
				?>
			</div>
			<div class="loginmask_form">
				<form action="<?php echo $this->_['path']; ?>" method="post">
				<input type="hidden" name="do" value="LogUserIn">
				<div class="form_row">
					<div class="form_label">
						<label for="login_user">Benutzername:</label>
					</div>
					<div class="form_element">
						<input name="login_user" id="login_user" type="text" class="text" value="<?php $this->_['request']['login_user']; ?>">
					</div>
				</div>
				<div class="form_row">
					<div class="form_label">
						<label for="login_password">Passwort:</label>
					</div>
					<div class="form_element">
						<input name="login_password" id="login_password" type="password" class="text" value="">
					</div>
				</div>
				<div class="form_row">
					<div class="form_label"></div>
					<div class="form_element">
						<input type="submit" class="submit" value="Einloggen">
					</div>
				</div>
				</form>
			</div>
		</div>
		
	</div>
</body>
</html>