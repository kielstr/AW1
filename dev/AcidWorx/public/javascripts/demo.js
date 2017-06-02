
$(function() {

	$( "#link" ).change( function () {
		if ($( "#link" ).val().match(/soundcloud/g)) {
			alert('No soundcloud');
			$( "#link" ).val( "" );
		}
	});

});