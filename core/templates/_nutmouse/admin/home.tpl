<!doctype html>
<html>
<head>
	<?php include($_SERVER['DOCUMENT_ROOT']."/core/templates/_nutmouse/admin/page/head.tpl"); ?>
</head>
<body class="default">

	<div class="wrap_all">
	
		<div class="wrap_head">
			<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/page/menu/mainmenu.tpl'); ?>
		</div>
		
		<div class="wrap_content">
			<div class="wrap_content_inner">
				<?php echo $this->_['admin_content']; ?>
			</div>
		</div>
	
	</div>
</body>
</html>