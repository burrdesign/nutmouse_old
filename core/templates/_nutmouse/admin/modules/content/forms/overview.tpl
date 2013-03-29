<?php
	
	$page = $_REQUEST['page'] - 1;
	if(!$page || $page < 0){
		$page = 0;
	}
	
	$winsize = $_REQUEST['winsize'];
	if(!$winsize){
		$winsize = 10;
	}
	
	$limit = $page * $winsize;
	
	/*
	 * Formulare laden
	 */
	$sql = new SqlManager();
	$sql->setQuery("
		SELECT * FROM bd_main_form
		LIMIT {{limit}}, {{winsize}}
		");
	$sql->bindParam("{{winsize}}",$winsize,"int");
	$sql->bindParam("{{limit}}",$limit,"int");
	$formsquery = $sql->execute();
	$formscnt = $sql->getLineCount("bd_main_form");
?>

<div class="mask_intro">
	<h2 class="mask_title"><span class="icon icon-bubbles-3 "></span> Formulare</h2>
	<p class="mask_desc">Hier k&ouml;nnen Sie Formulare anlegen und verwalten. Mithilfe von Formularen können Sie Informationen von Usern Ihrer Website erhalten, bspw. in Form von Feedback-, Kontakt- oder Adressformularen. Für jedes Formular können Sie frei die anzuzeigenden Felder bestimmen, sowie was beim Absenden des Formulars passieren soll.</p>
	<?php if($formscnt > 0) echo "\t<p>Es wurden <b>{$formscnt}</b> Formulare gefunden.</p>\n"; ?>
</div>

<?php
	if(is_array($messages)){
		echo "<div class=\"mask_messages\">\n";
		foreach($messages as $msg_type => $msg_text){
			echo "\t<span class=\"clear\"></span>\n";
			echo "\t<div class=\"message message_{$msg_type}\"><span class=\"icon\"></span><span class=\"text\">{$msg_text}</span></div>\n";
		}
		echo "</div>\n";
	}
?>

<div class="mask_table">

	<?php 
		if($formscnt == 0){
			echo "\t<p><i>Es wurden keine Formulare gefunden!</i></p>\n";
		} else {			
			//Paging
			if($formscnt > $winsize){
				echo "
					\t<div class=\"list_paging\">\n
					\t\t<span class=\"title\">Seite:</span>\n";
				for($i=1; $i<=ceil($formscnt/$winsize); $i++){
					$class = "";
					if($i == $page + 1){
						$class = "active";
					}
					echo "\t\t<a href=\"?page={$i}\" title=\"Gehe zu Seite {$i}\" class=\"{$class}\">{$i}</a>\n";
				}
				echo "\t</div>\n";
			}
			
			echo "\t<table class=\"list list_news\" cellpadding=0 cellspacing=0>\n";
			while($form = mysql_fetch_array($formsquery)){ 
				echo "
					\t\t<tr class=\"{$class}\">\n
					\t\t\t<td class=\"key first width_30 align_center\">{$form['formKey']}</td>\n
					\t\t\t<td class=\"title\">{$form['formName']}</td>\n
					\t\t\t<td class=\"action\"><a href=\"?editForm={$form['formKey']}\" class=\"icon icon-pencil\" title=\"Formular bearbeiten\"></a></td>\n
					\t\t\t<td class=\"action\"><a href=\"?removeForm={$form['formKey']}\" class=\"icon icon-cancel-circle\" title=\"Formular l&ouml;schen\"></a></td>\n
					\t\t</tr>\n";
					$class = '';
			}
			echo "\t</table>\n";
		}
	
		$form = new Form();
		$form->element->printSubmitLink("Neues Formular anlegen","?editForm=new");
	?>
	
</div>