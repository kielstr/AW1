
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

			$.ajax({
	            url: '/api/confirm_email_send/'+ pageToken + '/' + $("#email").val() + '/Demo Submitter',
	            type: "GET",
	            contentType: "application/json",
	            success: function(data) {
	                if (data.status == "ok" ) {
	                    
	                } else {
	                    alert("Server failed " + data.error);
	                }
	            },
	            error: function(XMLHttpRequest, textStatus, errorThrown) {
	                alert("Server failed " + data.error);
	            }
	        });

			$("#popUpPage").show();

		} else {
			console.log('invalid email');
		}
	});

	$("#emailConfirmCode").bind("enterKey",function(e){
 		$("#popUpPage").hide();
	});

	$("#emailConfirmCode").keyup(function(e){
	    if(e.keyCode == 13) {
	        $(this).trigger("enterKey");
	    }
	});
});