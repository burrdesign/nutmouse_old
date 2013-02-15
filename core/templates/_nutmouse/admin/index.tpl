<!doctype html>
<html>
<head>
	<?php include($_SERVER['DOCUMENT_ROOT']."/core/templates/_nutmouse/admin/page/head.tpl"); ?>
</head>
<body class="default">

	<div class="wrap_all">
	
		<div class="wrap_head">
			<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/menu/mainmenu.tpl'); ?>
		</div>
		
		<div class="wrap_content">
			<div class="wrap_submenu">
				<?php include_once($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/admin/menu/submenu.tpl'); ?>
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