$(function() {			// Apply only after loading DOM

    ////////////////////////////////////////////////////////
    // First Part, DOM handling
    ////////////////////////////////////////////////////////
    var title = $(".title").detach(); // Moving the title
    var postamble = $("#postamble").detach(); // Moving the postamble
    if (title.length) {
	var titlepage = $('<div/>',
			  {id:'title'// ,
			   // class:'step'
			  });
	titlepage = postamble.length ? titlepage.prepend(postamble) : titlepage;
	$('#content').prepend(titlepage.prepend(title));
    }


    $.getScript("js/jquery-ui/jquery-ui.min.js", function() {
	console.log( "Load of jquery-ui was performed." );

	$("a[href$='.jpg'],a[href$='.bmp'],a[href$='.png'], a[href$='.svg']").click(function() {
	    console.log("image was clicked");
	    $( this ).append('<div/>');
	    var img = $('<img/>', {
		src: $( this ).attr('href'),
		class: 'imgbox'
	    });
	    $( this ).children("div").append(img).dialog({
		modal: true,
		show: "fade",
		hide: "fade",
	    });
	    return false;
	});
	
	$('a[href^="http://"]').click(function() {
	    console.log("url was clicked");
	    $( this ).append('<div/>');
	    var ifr = $('<iframe/>', {
		src: $( this ).attr('href'),
	    });
	    $( this ).children("div").append(ifr).dialog({
		modal: true,
		show: "fade",
		hide: "fade",
		width:'auto',
		height:'auto'
	    });

	    return false;
	});

	$('a[href^="https://"]').attr("target","_blank");
    });
    
    
    ////////////////////////////////////////////////////////
    // Second Part, Applying step and slide classes
    ////////////////////////////////////////////////////////
    var slidesSelector = "#title, #table-of-contents, .outline-2";

    $(slidesSelector).each(function(i){
	var custom_id = $(this).find(":first-child").attr("id");
	if (custom_id !== undefined &&
	    custom_id != "" &&
	    !custom_id.match(/^orgheadline\d+$/))  {
	    console.log("new id :"+custom_id);
	    var old_id = $(this).find(":first-child>a").attr("id");
	    $(this).find(":first-child").attr("id","");
	    console.log("old id :"+old_id);
	    $(this).attr("id",custom_id);
	    $( "a[href=#"+old_id+"]" ).attr("href","#"+custom_id);
	}
    });

    ////////////////////////////////////////////////////////
    // Third Part, Applying transform rules by templates
    ////////////////////////////////////////////////////////    
    var numSlides = $(slidesSelector).length; // How many slide do we
					     // have?
    var slideWidth = $(".outline-2").width();    // How wide are they ?

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
    $.jmpress("apply", slidesSelector, stepArray);

    // Finally, we launch the jmpress main().
    $('#content').jmpress({
	stepSelector: slidesSelector
    });
});
