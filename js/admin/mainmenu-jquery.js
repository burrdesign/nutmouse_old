$(function(){

	//Select so ändern, dass beim ändern die entsprechende Adminseite aufgerufen wird
	$("#mainmenu_select_goto").live("change", function(){
		console.log("TEST");
		var href = $(this).val();
		window.location=("/admin" + href);
	});

});