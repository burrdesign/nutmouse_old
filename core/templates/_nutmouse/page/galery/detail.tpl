<div class="wrap_galery">
	<div class="inner">
		<div class="galery_date">
			<p>
				<?php 
					echo DateLib::fmt("l, d. F Y", strtotime($this->_['galeryData']['galeryDate']));
				?>
			</p>
		</div>
		
		<div class="galery_imagecnt">
			<p><?php echo (int)$this->_['galeryData']['galeryImageCnt']; ?> Bilder</p>
		</div>
		
		<div class="galery_title">
			<h1><?php echo $this->_['galeryData']['galeryTitle']; ?></h1>
		</div>
		
		<?php
			if($this->_['galeryData']['galeryDesc']){
				echo "<div class=\"galery_desc\">{$this->_['galeryData']['galeryDesc']}</div>";
			}
		?>
	</div>
</div>

<?php
	//Vorbereitung für Spaltenlayout
	$column = array();
	$column[0] = array();
	$column[1] = array();
	$column[2] = array();
	
	$cnt = 0;
	while($image = mysql_fetch_array($this->_['galeryData']['galeryImageQuery'])){
		if($cnt < 0 || $cnt > 2) $cnt = 0;
		$column[$cnt][] = $image;
		$cnt++;
	}
?>

<div class="wrap_galery_images">
	<div class="column column1">
		<?php
			foreach($column[0] as $image){
				echo "<div class=\"wrap_galery_image\">\n";
				echo "\t<a class=\"zoomable\" rel=\"galery\" href=\"/core/files/galeries/{$this->_['galeryData']['galeryKey']}/{$image['imageFilename']}\" target=\"_blank\">\n";
				echo "\t\t<img src=\"/core/files/galeries/{$this->_['galeryData']['galeryKey']}/{$image['imageFilename']}\" alt=\"{$image['imageFilename']}\">\n";
				echo "\t</a>\n";
				echo "</div>\n";
			}
		?>
	</div>
	
	<div class="column column2">
		<?php
			foreach($column[1] as $image){
				echo "<div class=\"wrap_galery_image\">\n";
				echo "\t<a class=\"zoomable\" rel=\"galery\" href=\"/core/files/galeries/{$this->_['galeryData']['galeryKey']}/{$image['imageFilename']}\" target=\"_blank\">\n";
				echo "\t\t<img src=\"/core/files/galeries/{$this->_['galeryData']['galeryKey']}/{$image['imageFilename']}\" alt=\"{$image['imageFilename']}\">\n";
				echo "\t</a>\n";
				echo "</div>\n";
			}
		?>
	</div>
	
	<div class="column column3">
		<?php
			foreach($column[2] as $image){
				echo "<div class=\"wrap_galery_image\">\n";
				echo "\t<a class=\"zoomable\" rel=\"galery\" href=\"/core/files/galeries/{$this->_['galeryData']['galeryKey']}/{$image['imageFilename']}\" target=\"_blank\">\n";
				echo "\t\t<img src=\"/core/files/galeries/{$this->_['galeryData']['galeryKey']}/{$image['imageFilename']}\" alt=\"{$image['imageFilename']}\">\n";
				echo "\t</a>\n";
				echo "</div>\n";
			}
		?>
	</div>
</div>