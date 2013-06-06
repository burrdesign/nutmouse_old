/**
 * Nutmouse theme for Highcharts JS
 * @author BurrDesign
 */

Highcharts.theme = {
	colors: ["#9ACD32", "#514F78", "#42A07B", "#9B5E4A", "#72727F", "#1F949A", "#82914E", "#86777F", "#42A07B"],
	chart: {
		className: 'nutmouse',
		borderWidth: 0,
		plotBorderWidth: 1,
		backgroundColor: '#eee'
	},
	title: {
		text: null,
		style: {
			color: '#000',
			font: '16px Open Sans, Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
		}
	},
	subtitle: {
		style: {
			color: '#000',
			font: '12px Open Sans, Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
		}
	},
	xAxis: {
		gridLineWidth: 0,
		lineColor: '#ddd',
		tickColor: '#ddd',
		labels: {
			style: {
				color: '#333',
				fontWeight: 'normal'
			},
			y: 20
		},
		title: {
			style: {
				color: '#333',
				font: '12px Open Sans, Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
			}
		}
	},
	yAxis: {
		lineColor: '#ddd',
		tickColor: '#ddd',
		tickWidth: 1,
		labels: {
			style: {
				color: '#333'
			}
		},
		title: {
			style: {
				color: '#333',
				font: '12px Open Sans, Lucida Grande, Lucida Sans Unicode, Verdana, Arial, Helvetica, sans-serif'
			}
		}
	},
	legend: {
		itemStyle: {
			font: '9pt Open Sans, Trebuchet MS, Verdana, sans-serif',
			color: '#333'
		},
		itemHoverStyle: {
			color: 'black'
		},
		itemHiddenStyle: {
			color: 'silver'
		}
	},
	labels: {
		style: {
			color: '#333'
		}
	},
	credits: { 
		enabled: false 
	},
	legend: { 
		enabled: false 
	}
};

// Apply the theme
var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
