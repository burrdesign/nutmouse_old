<!doctype html>
<html>
<head>
	<?php include($_SERVER['DOCUMENT_ROOT']."/core/templates/_nutmouse/page/head.tpl"); ?>
</head>
<body class="default">

	<div class="wrap_all">
	
		<div class="wrap_head">
			<div class="inner">			
				<div class="logo">
					<h1><span class="bold">Golfshop</span> Gut Berge</h1>
				</div>
				<div class="head_info">
					<ul>
						<li class="place"><a href="/map">Berkenberg 1, 58285 Gevelsberg</a></li>
						<li class="contact">02332 913755 - <a href="mailto:info@gutberge.de">info@gutberge.de</a></li>
						<li class="open">Dienstag-Samstag: 9-20 Uhr - Sonntag/Montag/Feiertag: 9-18 Uhr</li>
					</ul>
				</div>
			</div>
			<div class="shadow shadow_bottom"></div>
		</div>
		
		<?php echo $this->_['page_content']; ?>
		
		<div class="wrap_footer">
			<div class="shadow shadow_top"></div>
			<div class="inner">
				<div class="footer_copyright">
					<p>&copy; 2012 - Proshop Golfshopanlage Gut Berge</p>
				</div>
				<div class="footer_nav">
					<ul>
						<li><a href="/">Aktuelles Top-Angebot</a></li>
						<li><a href="/impressum">Impressum</a></li>
					</ul>
				</div>
			</div>
		</div>
	
	</div>
</body>
</html>