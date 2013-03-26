<!doctype html>
<html>
<head>
	<?php include($_SERVER['DOCUMENT_ROOT']."/core/templates/_nutmouse/modules/head.tpl"); ?>
</head>
<body class="default">

	<div class="forkme">
		<a href="https://github.com/burrdesign/nutmouse" target="_blank">
			<img src="/core/templates/_nutmouse/img/github/forkme_left_red_aa0000.png" alt="Fork me on Github"/>
		</a>
	</div>

	<div class="wrap_all">
	
		<div class="wrap_head">
			<div class="inner">			
				<div class="logo">
					<a href="/"><span class="bold">NutMouse</span> CMS System v0.2</a>
				</div>
			</div>
		</div>
		
		<div class="wrap_content">
			<?php echo $this->_['page_content']; ?>
		</div>
		
		<div class="wrap_footer">
			<div class="inner">
				<div class="footer_nav">
					<?php include($_SERVER['DOCUMENT_ROOT']."/core/templates/_nutmouse/modules/menu/footermenu.tpl"); ?>
				</div>
				<div class="footer_copyright">
					<p>&copy; <?php echo date("Y",time()); ?> - Burr Design</p>
				</div>
			</div>
		</div>
	
	</div>
	
</body>
</html>