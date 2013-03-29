<div class="wrap_news_comments" id="comments">

	<h2>Kommentare</h2>
	
	<?php
		if((int)$this->_['newsData']['commentCnt'] <= 0){
			echo "<p><i>Keine Kommentare gefunden.</i></p>";
		} else {
			$cnt = $this->_['newsData']['commentCnt'];
			while($comment = mysql_fetch_array($this->_['newsData']['commentQuery'])){
				echo "
					<div class=\"wrap_comment\">\n
					\t<div class=\"comment_head\">\n
					\t\t<span class=\"comment_key\">Kommentar #{$cnt}</span>\n
					\t\t<span class=\"comment_name\">von {$comment['commentName']}</span>\n
					\t\t<span class=\"comment_date\">vom " . DateLib::fmt("l, d. F Y H:i:s", strtotime($this->_['newsData']['newsReleaseDate'])) . " Uhr</span>\n
					\t</div>\n
					\t<div class=\"comment_title\">\n
					\t\t<span class=\"title\">{$comment['commentSubject']}</span>\n
					\t</div>\n
					\t<div class=\"comment_text\">\n
					\t\t<div class=\"text\">{$comment['commentText']}</div>\n
					\t</div>\n
					</div>\n";
				$cnt--;
			}
		}
	?>

</div>

<?php
	if(Config::get("news_enable_comments") != 1){
		//return;
	}
?>

<div class="wrap_newcomment_form">
	<h3>Neuen Kommentar schreiben</h3>
	
	<?php
		if($errormsg){
			echo "<div class=\"errormsg\">{$errormsg}</div>";
		}
	?>

	<form name="newcomment" action="#comments" method="post">
	
	<input type="hidden" name="action" value="saveComment">
	<input type="hidden" name="commentNewsKey" value="<?php echo $this->_['newsData']['newsKey']; ?>">
	
	<input type="text" class="text commentName" name="commentName" value="<?php echo $this->_['request']['commentName']; ?>" placeholder="Name">
	<input type="text" class="text commentEmail" name="commentEmail" value="<?php echo $this->_['request']['commentEmail']; ?>" placeholder="Emailadresse">
	<input type="text" class="text commentSubject" name="commentSubject" value="<?php echo $this->_['request']['commentSubject']; ?>"  placeholder="Betreff">
	
	<textarea class="textarea commentText" name="commentText" placeholder="Die eigentliche Nachricht des Kommentars..."><?php echo $this->_['request']['commentText']; ?></textarea>
	
	<input type="submit" class="submit commentSubmit" value="Kommentar speichern">
	
	</form>
</div>