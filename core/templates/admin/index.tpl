<!doctype html>
<html>
<head>
	<title>NutMouse v0.1 Administration</title>
	<link rel="stylesheet" href="/css/admin/style.css">
	
	<link rel="stylesheet" href="/img/icons/iconfont/style.css">
	<!--[if lte IE 7]><script type="text/javascript" src="/img/icons/iconfont/lte-ie7.js"></script><![endif]-->
</head>
<body class="default">

	<div class="wrap_all">
	
		<div class="wrap_head">
			<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/mainmenu.tpl'); ?>
		</div>
		
		<div class="wrap_content">
			<div class="wrap_submenu">
				<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/submenu.tpl'); ?>
			</div>
			
			<div class="wrap_mask">
				<div class="wrap_mask_inner">
					<?php echo $this->_['admin_content']; ?>
				</div>
			</div>
		</div>
	
	</div>
</body>
</html>