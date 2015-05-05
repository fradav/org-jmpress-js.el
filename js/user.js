$(function() {			// Apply only after loading DOM

    ////////////////////////////////////////////////////////
    // First Part, DOM handling
    ////////////////////////////////////////////////////////
    var title = $(".title").detach(); // Moving the title
    var postamble = $("#postamble").detach(); // Moving the postamble
    if (title.length) {
	var titlepage = $('<div/>',
			  {id:'title',
			   class:'step'});
	titlepage = postamble.length ? titlepage.prepend(postamble) : titlepage;
	$('#content').prepend(titlepage.prepend(title));
    }

    ////////////////////////////////////////////////////////
    // Second Part, Applying step and slide classes
    ////////////////////////////////////////////////////////
    $("#title, #table-of-contents, .outline-2").each(function(i){
	var custom_id = $(this).find(":first-child").attr("id");
	if (custom_id != "unnumbered-"+(i+1))  {
	    $(this).attr("id",custom_id);
	}
	$(this).addClass("step slide");
    });

    ////////////////////////////////////////////////////////
    // Third Part, Applying transform rules by templates
    ////////////////////////////////////////////////////////    
    var numSlides = $('.slide.step').length; // How many slide do we
					     // have?
    var slideWidth = $('.slide').width();    // How wide are they ?

    var stepArray = new Array(numSlides);
    for	(i = 0; i < numSlides; i++) {
	// The main idea is to make a rotating carrousel with the
	// slides.  
    	stepArray[i] = {
	    // We calculate the required radius of the disc,
    	    r:(numSlides*slideWidth*1.7)/(2*Math.PI),
	    // using polar coordinates, place each slide at
	    // corresponding angle
    	    phi:i*(360/numSlides),
	    // and rotate them at 90° on the x axis so their plane is
	    // made perpendicular to the disc, and finally we rotate
	    // them all on the y axis to make them tangent to the disc
    	    rotate: { x:90,
		      y:i*(360/numSlides) }
    	};
    }
    // We apply the templates array to the slides
    $.jmpress("apply", '.slide', stepArray);

    // Finally, we launch the jmpress main().
    $('#content').jmpress();
});
