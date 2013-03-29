<title><?php echo $this->_['title']; ?></title>

<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
<meta charset="windows-1252">

<?php
	if(!empty($this->_['canonical'])){
		echo "<link rel=\"canonical\" href=\"http://{$this->_['canonical']}\" />";
	}
?>

<link rel="stylesheet" href="/core/templates/_nutmouse/css/style.css">
<link rel="stylesheet" href="/core/templates/_nutmouse/css/950style.css" media="only screen and (max-width:950px)" />
<link rel="stylesheet" href="/core/templates/_nutmouse/css/650style.css" media="only screen and (max-width:650px)" />

<script type="text/javascript" src="/core/templates/_nutmouse/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/core/templates/_nutmouse/js/jquery.mousewheel-3.0.6.pack.js"></script>

<!-- Fancybox -->
<link rel="stylesheet" href="/core/templates/_nutmouse/fancybox/jquery.fancybox.css?v=2.1.4" type="text/css" media="screen" />
<script type="text/javascript" src="/core/templates/_nutmouse/fancybox/jquery.fancybox.pack.js?v=2.1.4"></script>

<link rel="stylesheet" href="/core/templates/_nutmouse/fancybox/helpers/jquery.fancybox-buttons.css?v=1.0.5" type="text/css" media="screen" />
<script type="text/javascript" src="/core/templates/_nutmouse/fancybox/helpers/jquery.fancybox-buttons.js?v=1.0.5"></script>
<script type="text/javascript" src="/core/templates/_nutmouse/fancybox/helpers/jquery.fancybox-media.js?v=1.0.5"></script>

<link rel="stylesheet" href="/core/templates/_nutmouse/fancybox/helpers/jquery.fancybox-thumbs.css?v=1.0.7" type="text/css" media="screen" />
<script type="text/javascript" src="/core/templates/_nutmouse/fancybox/helpers/jquery.fancybox-thumbs.js?v=1.0.7"></script>

<!-- eigene JS-Skripte -->
<script type="text/javascript" src="/core/templates/_nutmouse/js/custom.js"></script>