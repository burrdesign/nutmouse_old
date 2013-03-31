<div class="inner_content">
	<?php echo $this->_['content']; ?>
</div>

<div class="wrap_galerylist">
	<?php
		$sql = new SqlManager();
		$sql->setQuery("
			SELECT * FROM bd_main_galery
			LEFT JOIN bd_main_galery_image ON ( galeryKey = imageGaleryKey )
			WHERE galeryActive = 1 AND galeryDate < NOW()
			GROUP BY galeryKey
			ORDER BY galeryDate DESC, imagePos, imageCreated
			");
		$galerylist = $sql->execute();
		
		while($galery = mysql_fetch_array($galerylist)){
			$imagepath = $_SERVER['DOCUMENT_ROOT'] . "/core/files/galeries/" . $galery['galeryKey'] . "/" . $galery['imageFilename'];
			$imagesize = array();
			$imageclass = "";
			if(is_file($imagepath)){
				$imagesize = getimagesize($imagepath);
				if($imagesize[0] > $imagesize[1]){
					$imageclass = "horizontal";
				} else {
					$imageclass = "vertical";
				}
			} else {
				//Defaultimage
				$imageclass = "notfound";
			}
		
			echo "<div class=\"wrap_galerydetail\">\n";
			echo "\t<div class=\"wrap_image\"><img class=\"{$imageclass}\" alt=\"{$galery['imageFilename']}\" src=\"/core/files/galeries/{$galery['galeryKey']}/{$galery['imageFilename']}\"></div>\n";
			echo "\t<a href=\"" . Lib::getCanonicalUrl("galery",$galery['galeryKey'],$galery['galeryTitle']) . "\" class=\"absolute\"><span>" . DateLib::fmt("l, d. F Y", strtotime($galery['galeryDate'])) . "<br><b>{$galery['galeryTitle']}</b></span></a>\n";
			echo "</div>\n\n";
		}
	?>
</div>