<?php

$errormsg = "";
if($_POST['action'] == "saveComment"){

	//Pflichtfelder überprüfen
	$reqs = array("commentNewsKey","commentName","commentEmail","commentSubject","commentText");
	foreach($reqs as $req){
		if(empty($req)){
			$errormsg = "<p>Bitte geben Sie alle notwendigen Felder ein!</p>";
			break;
		}
	}
	
	if(!$errormsg){
		//Kommentar speichern
		$insert = array();
		$insert = $_POST;
		$insert['commentDate'] = date("Y-m-d H:i:s", time());
		$insert['commentSession'] = session_id();
		$insert['commentIP'] = $_SERVER['REMOTE_ADDR'];
		$sql = new SqlManager();
		$sql->insert("bd_main_news_comment", $insert);
	
		//Kommentare laden
		$sql = new SqlManager();
		$sql->setQuery("
			SELECT * FROM bd_main_news_comment
			WHERE commentNewsKey = {{key}}
			ORDER BY commentDate DESC
			");
		$sql->bindParam("{{key}}",$this->_['newsData']['newsKey'],"int");
		$this->_['newsData']['commentQuery'] = $sql->execute();
		$this->_['newsData']['commentCnt'] = mysql_num_rows($this->_['newsData']['commentQuery']);
	}
	
}