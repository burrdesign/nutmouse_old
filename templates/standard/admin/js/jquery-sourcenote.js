$(function(){
	$("div.wrap_input div.wrap_sourcenote").hide();
	$("div.wrap_input div.wrap_sourceinfo div.note a").click(function(){
		if($(this).hasClass("active")){
			//ausblenden
			$(this).removeClass("active");
			$("div.wrap_input div.wrap_sourcenote").slideUp();
		} else {
			//ausklappen
			$(this).addClass("active");
			$("div.wrap_input div.wrap_sourcenote").slideDown();
		}
		return false;
	});
});