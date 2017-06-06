
$(function() {

	$( "#link" ).change( function () {
		if ($( "#link" ).val().match(/soundcloud/g)) {
			alert('No soundcloud');
			$( "#link" ).val( "" );
		}
	});

	$("#email").change(function(){
		if ($("#email").validateEmail()) {
			console.log('valid email');
		} else {
			console.log('invalid email');
		}
	})

});