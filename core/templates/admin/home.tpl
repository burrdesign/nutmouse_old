<!doctype html>
<html>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
	
	<title>NutMouse v0.1 Administration</title>
	
	<link rel="stylesheet" href="/css/admin/style.css">
	<link rel="stylesheet" href="/css/admin/1050style.css" media="only screen and (max-width:1050px)" />
	<link rel="stylesheet" href="/css/admin/650style.css" media="only screen and (max-width:650px)" />
	
	<link rel="stylesheet" href="/img/icons/iconfont/style.css">
	<!--[if lte IE 7]><script type="text/javascript" src="/img/icons/iconfont/lte-ie7.js"></script><![endif]-->
	
	<script type="text/javascript" src="/js/jquery.min.js"></script>
	<script type="text/javascript" src="/js/admin/mainmenu-jquery.js"></script>
</head>
<body class="default">

	<div class="wrap_all">
	
		<div class="wrap_head">
			<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/core/templates/admin/menu/mainmenu.tpl'); ?>
		</div>
		
		<div class="wrap_content">
			<div class="wrap_content_inner">
					<?php echo $this->_['admin_content']; ?>
			</div>
		</div>
	
	</div>
</body>
</html>