$(function() {
	$( "#addTrack" ).click(function() {
		var html = ' \
			<div> \
			<label>Name</label> \
			<input type="text" name=track> \
			</div> \
			<br> \
		';
		$( "#tasks" ).append(html);
	})
});