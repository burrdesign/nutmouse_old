<div class="inner_content">
	<?php echo $this->_['content']; ?>
</div>

<div class="wrap_form" id="form1">
	<?php
		//Vorbereitung
		$sql = new SqlManager();
		$sql->setQuery("
			SELECT * FROM bd_main_form
			WHERE formKey = 1
			");
		$forminfo = $sql->result();
		
		$sql->setQuery("
			SELECT * FROM bd_main_form_element
			JOIN bd_main_form_element_type ON ( typeKey = elementType )
			WHERE elementActive = 1 AND elementFormKey = 1
			ORDER BY elementPos
			");
		$elements = $sql->execute();
		
		//Formularaction
		$missing = array();
		$msg = array();
		
		if($_REQUEST['do'] == "send"){
			while($element = mysql_fetch_array($elements)){
				if($element['elementRequired'] == 1){
					if(empty($_REQUEST[$element['elementName']])){
						$missing[] = $element['elementName'];
					}
				}
			}
			
			mysql_data_seek($elements,0);
			
			if(count($missing) > 0){
				//Fehlermeldung
				$msg['error'] = "Bitte geben Sie alle benötigten Felder an!";
			} else {
				//Alles in Ordnung
				if($forminfo['formSendTo']){
					$forminfo_new = array();
					foreach($forminfo as $key => $value){
						$text = $value;
						$vars = array();
						preg_match_all("/\{(.*)\}/",$value,$vars);
						foreach($vars[0] as $varkey => $varvalue){
							$req = $_REQUEST[$vars[1][$varkey]];
							$text = str_replace($vars[0][$varkey], $req, $text);
						}
						$forminfo[$key] = $text;						
					}
					
					$from = $forminfo['formSendFrom'];
					$cc = $forminfo['formSendCC'];
					$bcc = $forminfo['formSendBCC'];
					$to = $forminfo['formSendTo'];
					$cc = $forminfo['formSendCC'];
					$subject = $forminfo['formSendSubject'];
					$text = wordwrap($forminfo['formSendText']);
					
					$header = "From: {$from}\r\n";
					if($cc) $header .= "Cc: {$cc}\r\n";
					if($bcc) $header .= "Bcc: {$bcc}\r\n";
					$header .= "Content-type: text/html; charset=iso-8859-1\r\n";
					
					mail($to, $subject, $text, $header);
				}
				$msg['ok'] = "Formular wurde abgeschickt!";
			}
			
			foreach($msg as $type => $text){
				echo "<div class=\"msg msg_{$type}\"><p>{$text}</p></div>";
			}
		}
		
		//Formularausgabe		
		$enctype = "";
		if($forminfo['formMethod'] == "post"){
			$enctype = "multipart/form-data";
		}
		
		$form = new Form();
		$form->start($forminfo['formAction'],$forminfo['formMethod'],$enctype);
		$form->row->printHidden("do","send");
		
		while($element = mysql_fetch_array($elements)){
			//echo "<pre>";
			//print_r($element);
			//echo "</pre>";
			switch($element['typeTag']){
				case "text":
					$class = "";
					if(in_array($element['elementName'],$missing)){
						$class = "missing";
					}
					$form->row->printTextfield($element['elementLabel'], $element['elementName'], $_REQUEST[$element['elementName']], $class);
					break;
				case "textarea":
					$form->row->printTextarea($element['elementLabel'], $element['elementName'], $_REQUEST[$element['elementName']]);
					break;
				case "radio":
					//eigentlich SELECT!
					$list = array();
					$list = split(",",$element['elementOptions']);
					$options = array();
					$labels = array();
					foreach($list as $option){
						$label = array();
						$label = split(":",$option);
						if(count($label) > 1){
							$labels[$label[0]] = $label[1];
						}
						$options[] = $label[0];
					}
					$form->row->printSelect($element['elementLabel'], $element['elementName'], $_REQUEST[$element['elementName']], $options, $labels);
					break;
				case "select":
					$list = array();
					$list = split(",",$element['elementOptions']);
					$options = array();
					$labels = array();
					foreach($list as $option){
						$label = array();
						$label = split(":",$option);
						if(count($label) > 1){
							$labels[$label[0]] = $label[1];
						}
						$options[] = $label[0];
					}
					$form->row->printSelect($element['elementLabel'], $element['elementName'], $_REQUEST[$element['elementName']], $options, $labels);
					break;
				case "submit":
					$form->row->start();
					$form->element->printSubmit($element['elementLabel']);
					$form->row->end();
					break;
			}
		}
		
		$form->end();
	?>
</div>