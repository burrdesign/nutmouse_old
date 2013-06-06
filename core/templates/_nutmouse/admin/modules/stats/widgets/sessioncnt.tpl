<?php
	//Daten in Array laden
	$from = $_SESSION['prefs']['stats']['date_from'];
	$to = $_SESSION['prefs']['stats']['date_to'];
	$stats_sessions = Stats::getStatsSessionCnt($from, $to);
?>

<script type="text/javascript">
	$(function () {
		$('#chart_diagramm_sessioncnt').highcharts({
			chart: { 
				type: 'column' 
			},
			xAxis: {
				type: 'datetime',
				labels: {
					formatter: function() {
						return Highcharts.dateFormat('%a %e %b', this.value);                  
					}
				}
			},
			yAxis: {
				min: 0,
				minRange: 1,
				title: {
					text: 'Besucherzahl'
				}
			},
			tooltip: {
				headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
				pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
					'<td style="padding:0"><b>{point.y:.0f}</b></td></tr>',
				footerFormat: '</table>',
				shared: true,
				useHTML: true
			},
			plotOptions: {
				column: {
					pointPadding: 0.2,
					borderWidth: 0
				}
			},
			series: [{
				name: 'Besucher',
				data: [ <?php
						$sep = "";
						$date = $_SESSION['prefs']['stats']['date_from'];
						while($date <= date("Y-m-d", strtotime($_SESSION['prefs']['stats']['date_to']))){
							echo "{$sep}" . (int)$stats_sessions['stats'][$date];
							$sep = ",";
							$date = date("Y-m-d", strtotime($date . ' + 1 day'));
						}
					?> ],
				<?php
					$point_start_year = date("Y", strtotime($_SESSION['prefs']['stats']['date_from']));
					$point_start_month = date("n", strtotime($_SESSION['prefs']['stats']['date_from']));
					$point_start_month = (int)$point_start_month - 1;
					$point_start_day = date("j", strtotime($_SESSION['prefs']['stats']['date_from']));
				?>
				pointStart: Date.UTC(<?php echo "{$point_start_year},{$point_start_month},{$point_start_day}"; ?>),
				pointInterval: 24 * 3600 * 1000
			}]
		});
	});
</script>

<h2 style="margin:20px; text-align:center;">Anzahl eindeutiger Besucher</h2>
<div id="chart_diagramm_sessioncnt" style="padding:0 20px 20px 20px; height:250px;"></div>