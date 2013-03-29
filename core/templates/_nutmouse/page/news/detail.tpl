<?php include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/page/news/actions.tpl'); ?>
<div class="wrap_news">
	<div class="inner">
		<div class="news_date">
			<p><?php echo DateLib::fmt("l, d. F Y H:i", strtotime($this->_['newsData']['newsReleaseDate'])); ?> Uhr</p>
		</div>
		
		<div class="news_commentcnt">
			<p><?php echo (int)$this->_['newsData']['commentCnt']; ?> Kommentare</p>
		</div>
		
		<div class="news_title">
			<h1><?php echo $this->_['newsData']['newsTitle']; ?></h1>
		</div>
		
		<?php
			if($this->_['newsData']['newsTeaser']){
				echo "\t\t\t<div class=\"news_teaser\">" . $this->_['newsData']['newsTeaser'] . "</div>\n";
			}
		?>
		
		<div class="news_text">
			<?php echo $this->_['newsData']['newsText']; ?>
		</div>
		
		<div class="news_comments">
			<?php include($_SERVER['DOCUMENT_ROOT'] . '/core/templates/_nutmouse/page/news/comments.tpl'); ?>
		</div>
	</div>
</div>