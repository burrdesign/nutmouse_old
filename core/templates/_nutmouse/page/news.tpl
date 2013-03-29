<div class="inner_content">
	<?php echo $this->_['content']; ?>
</div>

<div class="wrap_newslist">
	<?php
		$sql = new SqlManager();
		/*$sql->setQuery("
			SELECT n.*, COUNT(c.commentKey) AS newsCommentCnt FROM bd_main_news n
			LEFT JOIN bd_main_news_comment c ON ( c.commentNewsKey = n.newsKey )
			WHERE n.newsReleaseDate < NOW()
			ORDER BY n.newsReleaseDate DESC
			");*/
		$sql->setQuery("
			SELECT * FROM bd_main_news
			WHERE newsReleaseDate < NOW()
			ORDER BY newsReleaseDate DESC
			");
		$newslist = $sql->execute();
		
		$datehead = "";
		while($news = mysql_fetch_array($newslist)){
			$ts = strtotime($news['newsReleaseDate']);
			$newsdatehead = DateLib::fmt("l, d. F Y", strtotime($news['newsReleaseDate']));
			$newstime = date("H:i",strtotime($news['newsReleaseDate']));
			if($newsdatehead != $datehead){
				echo "\n\n<div class=\"date_trenner\"><h3 class=\"date\">{$newsdatehead}</h3></div>\n";
			}
			echo "<div class=\"wrap_newsdetail\">\n";
			echo "\t<div class=\"news_time\"><span>{$newstime} Uhr</span></div>\n";
			echo "\t<div class=\"news_title\"><a href=\"" . Lib::getCanonicalUrl("news",$news['newsKey'],$news['newsTitle']) . "\">{$news['newsTitle']}</a></div>\n";
			echo "</div>";
			$datehead = $newsdatehead;
		}
	?>
</div>