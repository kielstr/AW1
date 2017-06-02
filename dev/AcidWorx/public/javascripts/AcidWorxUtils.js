
(function( $ ){
    $.fn.displayServerError = function() {
        if ( $("#server-error").length > 0) {

            console.log('display_server_errors');

            var msg = '<h1>Some fields are incorrect</h1><ul>';
            $( "#server-error li" ).each( function () {
                msg += '<li>' + $(this).text() + '</li>';
            });
            msg += '</ul>';

            alertify.alert(
                msg,
                function() {},
                "my-breed"
            );

            $( ".required input[type='text']" ).attr( "style", "border-color: red");
            $( ".required input" ).attr( "placeholder", "Required");

            placeholder="text"
        }

        return 1; 
   }; 
})( jQuery );

$(document).ready(function () {
    jQuery().displayServerError();

    $( "#profileMenuIcon" ).click( function() {
        $( "#profileDropDown" ).toggle();
    });

});