<?php
	if($this->_['newsData']['commentCnt'] > 0){
?>

<div class="news_comments_list">

	<?php
		while($comment = mysql_fetch_array($this->_['newsData']['commentQuery'])){
	?>	
	
	<div class="wrap_comment" id="comment_<?php echo $comment['commentKey']; ?>">
		<div class="inner_box">
			<h3><?php echo $comment['commentSubject']; ?></h3>
			<div class="comment_text">
				<?php echo $comment['commentText']; ?>
			</div>
		</div>
	</div>
	
	<?php	
		}
	?>

</div>

<?php
	}
?>

<div class="news_newcomment" id="newcomment">
	<h3>Neuen Kommentar verfassen:</h3>
	<p>Hier sollte dann ein Formular stehen</p>
</div>