// JavaScript Document

$(function(){
	var config_auto_slide = 1;
	var config_auto_slidetime = 6000;
	
	var banner_origin_width = 180;
	
	var auto;
	
	initBanner();
	$(window).resize(function(){
		initBanner();
	});
	
	var banner_cnt = $("div.wrap_sliders div.slider").length;
	var banner_height = $("div.wrap_sliders div.slider").height();
	var banner_width = $("div.wrap_sliders div.slider").width();
	var all_width = banner_width * banner_cnt;
	var all_height = banner_height * 1;
	var slogan_prop;
	var slogan_fontsize;
	
	$("div.wrap_sliders").css("width",all_width);
	$("div.wrap_sliders div.slider").css("width",banner_width);
	
	$("div.marken").css("overflow","hidden");
	var margin_top = 0;
	var margin_left = 0;
	var current_nmb = 1;
	var max_nmb = banner_cnt;
	
	doSlide(current_nmb);
	
	if(config_auto_slide == 1){
		var auto = setInterval(function(){ current_nmb++; current_nmb = doSlide(current_nmb); }, config_auto_slidetime);
	}
	
	$("div.slidernav a").click(function(){
		current_nmb = doSlide($(this).attr("rel"));
		clearInterval(auto);
		return false;
	});
	
	$("div.wrap_sliders div.slider").css("opacity",0.4).hover(function(){ 
		$(this).css("opacity",1); 
	}, function(){
		$(this).css("opacity",0.4); 
	});
	
	function initBanner(){
		banner_width = $("div.wrap_sliders div.slider").width();
		all_width = banner_width * banner_cnt;
		margin_left = banner_width * (current_nmb - 1) * (-1);
		$("div.wrap_sliders").css("width",all_width).css("margin-left",margin_left);
	}
	
	function doSlide(nmb){
		if(nmb < 1 || nmb > max_nmb - 2){
			nmb = 1;
		}
		margin_left = banner_width * (nmb - 1) * (-1);
		$("div.wrap_sliders").animate({ "margin-left":margin_left });
		$("div.slidernav a").removeClass("active");
		$("div.slidernav a.banner" + nmb).addClass("active");
		
		return nmb;
	}
});