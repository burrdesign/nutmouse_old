<?php

	if(!empty($_REQUEST['date_from'])){
		$_SESSION['prefs']['stats']['date_from'] = date("Y-m-d", strtotime($_REQUEST['date_from']));
	}
	if(!empty($_REQUEST['date_to'])){
		$_SESSION['prefs']['stats']['date_to'] = date("Y-m-d", strtotime($_REQUEST['date_to']));
	}
	
	if(empty($_SESSION['prefs']['stats']['date_to'])){
		$_SESSION['prefs']['stats']['date_to'] = date("Y-m-d", time());
	}
	if(empty($_SESSION['prefs']['stats']['date_from'])){
		$_SESSION['prefs']['stats']['date_from'] = date("Y-m-d", strtotime("- 1 month", strtotime($_SESSION['prefs']['stats']['date_to'])));
	}

?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-pie"></span> Besucherstatistiken</h2>
	<p class="mask_desc">Hier sehen Sie eine &Uuml;bersicht &uuml;ber die Besucherzugriffe auf die Seite innerhalb des definierbaren Zeitraums. Dabei filtert das System automatisch Robots etc. aus. Neben den Zugriffszahlen werden hier auch noch einige weitere Informationen dargestellt.</p>
</div>

<div class="mask_form" style="margin-top:0;">
	<?php
		$form = new Form();
		
		$form->start($_SERVER['SELF_PATH'],"post");
		
		$form->row->start("Zeitraum angeben");
		$form->element->printTextfield("date_from", $_SESSION['prefs']['stats']['date_from'], "", "float:left; width:100px;");
		echo "<span style='display:block; float:left; height:30px; line-height:30px; text-align:center; width:20px;'> - </span>";
		$form->element->printTextfield("date_to", $_SESSION['prefs']['stats']['date_to'], "", "float:left; width:100px;");
		$form->element->printSubmit("Statistik laden", "", "", "margin-top:0; margin-left:5px;");
		$form->row->end();
		
		$form->end();
	?>
</div>

<div class="wrap_diagramm wrap_diagramm_sessioncnt wrap_diagramm_box_full" style="margin-top:20px;">
	<!-- Besucherzahlen -->
	<?php include($_SERVER['DOCUMENT_ROOT'] . "/core/templates/_nutmouse/admin/modules/stats/widgets/sessioncnt.tpl"); ?>
</div>

<div class="wrap_diagramm wrap_diagramm_browsercnt wrap_diagramm_box_half wrap_diagramm_box_half_left">
	<!-- Browserverteilung -->
	<?php include($_SERVER['DOCUMENT_ROOT'] . "/core/templates/_nutmouse/admin/modules/stats/widgets/browsercnt.tpl"); ?>
</div>

<div class="wrap_diagramm wrap_diagramm_pagespersession wrap_diagramm_box_half wrap_diagramm_box_half_right">
	<!-- Browserverteilung -->
	<?php include($_SERVER['DOCUMENT_ROOT'] . "/core/templates/_nutmouse/admin/modules/stats/widgets/pagespersession.tpl"); ?>
</div>
