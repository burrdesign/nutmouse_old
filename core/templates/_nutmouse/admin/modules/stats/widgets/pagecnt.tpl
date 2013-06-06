<?php
	//Daten in Array laden
	$from = $_SESSION['prefs']['stats']['date_from'];
	$to = $_SESSION['prefs']['stats']['date_to'];
	$stats_pages = Stats::getStatsPageCnt($from, $to);
?>

<script type="text/javascript">
	$(function () {
		$('#chart_diagramm_sessioncnt').highcharts({
			chart: { 
				type: 'bar' 
			},
			xAxis: {
				categories: [ <?php
						$sep = "";
						foreach($stats_pages['stats'] as $page => $cnt){
							echo "{$sep}'{$page}'";
							$sep = ",";
						}
					?> ],
				labels: {
					y: 3
				}
			},
			yAxis: {
				min: 0,
				title: {
                    text: false
                }
			},
			legend: {
				reversed: true
			},
			series: [{
				name: 'Besucher',
				data: [ <?php
						$sep = "";
						foreach($stats_pages['stats'] as $page => $cnt){
							echo "{$sep}" . (int)$cnt;
							$sep = ",";
						}
					?> ]
			}]
		});
	});
</script>

<h2 style="margin:20px; text-align:center;">Häufigste Seitenaufrufe</h2>
<div id="chart_diagramm_sessioncnt" style="padding:0 20px 20px 20px; height:350px;"></div>