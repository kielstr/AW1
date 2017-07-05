var acidworx = {
	demo : {}
};

$(function() {

    Dropzone.options.fileUploader = {
		paramName : "file",
		maxFilesize : 150,
		timeout : 1000000000,
		addRemoveLinks : true,
		params : {
			token : acidworx.demo.token
		},
		url : "/upload",
		dictDefaultMessage : "Tap, click or drop files here to upload to AcidWorx.",

		init: function() {
		    this.on("addedfile", function(file) { 
	    		// push into 
	    		acidworx.demo.files.push(file.name);

				if (acidworx.demo.mode === "validating" && $(".dropzone").hasClass("borderRed")) {
					console.log("add file -- removing red border class");
				  	$(".dropzone").removeClass("borderRed");
				}

			}),

			this.on("removedfile", function(file) {  
		    	var index = acidworx.demo.files.indexOf(file.name);
		    	acidworx.demo.files.splice(index, 1);
		    	if (acidworx.demo.mode === "validating" && index === 0) {
					console.log("removing file -- adding red border class");
				  	$(".dropzone").addClass("borderRed");
				}

		    }),
		    this.on("sending", function(file) {  
		    	var index = acidworx.demo.files.indexOf(file.name);
		    	// mark file as sending
		    	alert("upload sending");
		    }),
		    this.on("success", function(file) {  
		    	var index = acidworx.demo.files.indexOf(file.name);
		    	// mark file as successful
		    	alert("upload successful");
		    }),
		    this.on("canceled", function(file) {  
		    	var index = acidworx.demo.files.indexOf(file.name);
		    	// mark file as canceled
		    	alert("upload canceled");
		    }),
		    this.on("error", function(file, errorMessage) {  
		    	var index = acidworx.demo.files.indexOf(file.name);
		    	// mark file as error
		    	alert("upload error: " + errorMessage);
		    }),
			this.on("complete", function(file, errorMessage) {  
		    	var index = acidworx.demo.files.indexOf(file.name);
		    	// mark file as complete
		    	alert("upload complete");
		    });

		 }
    };

    $("#name").change(function() {
    	acidworx.demo.name = $(this).val();
    });

    $("#artistName").change(function() {
		acidworx.demo.artistName = $(this).val();
    });

    $("#country").change(function() {
		acidworx.demo.country.code = $(this).val();
		acidworx.demo.country.text = $("#country option:selected").text();
    });

	$("#email").change(function(){
		acidworx.demo.email.value = $(this).val();
		if ($("#email").validateEmail()) {

			acidworx.demo.email.valid = true;

			$.ajax({
	            url: '/api/confirm_email_send/'+ acidworx.demo.token + '/' + $("#email").val() + '/Demo Submitter',
	            type: "GET",
	            contentType: "application/json",
	            success: function(data) {
	                if (data.status == "ok" ) {
	                    
	                } else {
	                    alert("Server failed " + data.error);
	                }
	            },
	            error: function(XMLHttpRequest, textStatus, errorThrown) {
	                alert("Server failed " + textStatus);
	            }
	        });

			$(".pageShadow").show();
			$(".confirmEmail").show();

		} else {
			console.log('invalid email');
		}
	});

	$("#emailConfirmCode").bind("enterKey",function(e){

		$.ajax({
            url: '/api/confirm_email/'+ acidworx.demo.token + '/' + $("#emailConfirmCode").val(),
            type: "GET",
            contentType: "application/json",
            success: function(data) {
                if (data.status == "ok" ) {
                	acidworx.demo.email.confimed = true;
                    $(".confirmEmail").hide();
                    $(".pageShadow").hide();
                } else {
                	acidworx.demo.email.confimed = false;
                    alert("Server failed " + data.error);
                }
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                alert("Server failed " + textStatus);
            }
        });
	});

	$("#emailConfirmButton").click(function() {
		$.ajax({
            url: '/api/confirm_email/'+ acidworx.demo.token + '/' + $("#emailConfirmCode").val(),
            type: "GET",
            contentType: "application/json",
            success: function(data) {
                if (data.status == "ok" ) {
                	acidworx.demo.email.confimed = true;
                    $(".confirmEmail").hide();
                    $(".pageShadow").hide();
                } else {
                	acidworx.demo.email.confimed = false;
                    alert("Server failed " + data.error);
                }
            },
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                alert("Server failed " + textStatus);
            }
        });
	});

	$("#emailConfirmCode").keyup(function(e){
	    if(e.keyCode == 13) {
	        $(this).trigger("enterKey");
	    }
	});

	$("#otherLabelsRadio input[type='radio']").change(function(){
		console.log($(this).val());
		acidworx.demo.sentToOtherLabels = ($(this).val() === "1" ? true : false);
	});

	$("#sendBy input[type='radio']").change(function(){
		if($(this).val() == "upload" ) {
			$("#linkContainer").hide();

			if (acidworx.demo.loggedIn === true) {
				$("#fileUploadContainer").show();
			} else {
				$(".noLoginUpload").show();
			}

			acidworx.demo.sendBy = "upload";
			$("#link").removeClass("borderRed");
			$(".dropzone").removeClass("borderRed");
		} else {
			$("#linkContainer").show();

			if (acidworx.demo.loggedIn === true) {
				$("#fileUploadContainer").hide();
			} else {
				$(".noLoginUpload").hide();
			}

			acidworx.demo.sendBy = "link";
		}
	});

	$("#link").change(function () {
		acidworx.demo.linkURL = $( "#link" ).val();

		if(/^(http|https|ftp):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/i.test($("#link").val())) {
	    	$("#link").removeClass("borderRed");
		} else {
			$("#link").addClass("borderRed");
		}
	});

	var demoDesc = 255;
	$("#charCountDown").html(demoDesc);
	$("#demoDesc").keypress(function () {
		$("#charCountDown").html(demoDesc - $("#demoDesc").val().length);
		//console.log($("#demoDesc").val().length);
	});

	$("#demoDesc").change(function(){
		acidworx.demo.description = $("#demoDesc").val();
	});
	
	$("#submitButton").click(function(){
		acidworx.demo.mode = "validating";
		acidworx.demo.errors = [];
		console.log(acidworx.demo);

		var status = acidworx.demo.valid();
		console.log("return status from valid: " + status);
		if ( status == true ) {
			console.log("submit form now");
			$("#demoForm").submit();
		} else {
			//$(window).scrollTop(300);

			var errorStr = "";

			$.each( acidworx.demo.errors, function (index, value) {
				errorStr += "<div class=error>"+value+"</div>";
			});

			$(".errors").html(errorStr);


			$(".pageError").show();
			$(".pageShadow").show();
		}
	});

	$(".closeError").click(function() {
		$(".pageError").hide();
		$(".pageShadow").hide();
	});
});