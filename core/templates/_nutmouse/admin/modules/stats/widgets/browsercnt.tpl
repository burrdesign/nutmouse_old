<?php
	//Daten in Array laden
	$from = $_SESSION['prefs']['stats']['date_from'];
	$to = $_SESSION['prefs']['stats']['date_to'];
	$stats_browsers = Stats::getStatsBrowserCnt($from, $to);
?>

<script type="text/javascript">
	$(function(){
		$('#chart_diagramm_browsercnt').highcharts({
			chart: {
				plotBackgroundColor: null,
				plotBorderWidth: null,
				plotShadow: false
			},
			tooltip: {
				pointFormat: '{series.name}: <b>{point.percentage:.2f}% ({point.y})</b>',
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
				name: 'Browser share',
				data: [
					<?php
						$sep = "";
						foreach($stats_browsers['stats'] as $browser => $cnt){
							echo "{$sep}['{$browser}', " . (int)$cnt . "]";
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

<h2 style="margin:20px; text-align:center;">Verwendete Browser</h2>
<div id="chart_diagramm_browsercnt" style="width:98%; height:250px; float:left;"></div>