<div class="wrap_main wrap_news">
	<div class="inner">
		<div class="padding_box">
			<div class="news_date">
				<p><?php echo date("d.m.Y H:i:m",strtotime($this->_['newsData']['newsReleaseDate'])); ?> Uhr</p>
			</div>
			
			<div class="news_comments">
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
</div>