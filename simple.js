$(function() {
    var title = $(".title").detach();
    var postamble = $("#postamble").detach();
    if (title.length) {
	var titlepage = $('<div/>',
			  {id:'title',
			   class:'step'});
	titlepage = postamble.length ? titlepage.prepend(postamble) : titlepage;
	$('#content').prepend(titlepage.prepend(title));
    }
    $("#title, #table-of-contents, .outline-2").each(function(i){
	var custom_id = $(this).find(":first-child").attr("id");
	if (custom_id != "unnumbered-"+(i+1))  {
	    $(this).attr("id",custom_id);
	}
	$(this).addClass("step slide");
    });

    var numSlides = $('.slide.step').length;
    var slideWidth = $('.slide').width();

    var stepArray = new Array(numSlides);
    for	(i = 0; i < numSlides; i++) {
    	stepArray[i] = {
    	    r:(numSlides*slideWidth*1.7)/(2*Math.PI),
    	    phi:i*(360/numSlides),
    	    rotate: { x:90, y:i*(360/numSlides) }
    	};
    }
    $.jmpress("apply", '.slide', stepArray);
    
    $('#content').jmpress();
});
