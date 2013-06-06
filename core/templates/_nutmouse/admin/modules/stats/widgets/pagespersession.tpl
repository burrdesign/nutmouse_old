<?php
	//Daten in Array laden
	$from = $_SESSION['prefs']['stats']['date_from'];
	$to = $_SESSION['prefs']['stats']['date_to'];
	$stats_pagecnt = Stats::getStatsPagesPerSession($from, $to);
?>

<script type="text/javascript">
	$(function(){
		$('#chart_diagramm_pagespersession').highcharts({
			chart: {
				plotBackgroundColor: null,
				plotBorderWidth: null,
				plotShadow: false
			},
			tooltip: {
				pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>',
				percentageDecimals: 1
			},
			plotOptions: {
				pie: {
					allowPointSelect: true,
					cursor: 'pointer',
					dataLabels: {
						enabled: true,
						color: '#000000',
						connectorColor: '#000000',
						formatter: function() {
							return this.point.name;
						}
					}
				}
			},
			series: [{
				type: 'pie',
				name: 'Pages per Session',
				data: [
					<?php
						$sep = "";
						foreach($stats_pagecnt['stats'] as $pages => $cnt){
							echo "{$sep}['{$pages}', " . (int)$cnt . "]";
							$sep = ",";
						}
					?>
				]
			}],
			legend: { 
				enabled: true 
			}
		});
	});
</script>

<h2 style="margin:20px; text-align:center;">Seitenaufrufe pro Besucher</h2>
<div id="chart_diagramm_pagespersession" style="width:98%; height:250px; float:left;"></div>