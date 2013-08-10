function updateCountdown(){
	//max-length: 140
	var left = 140 - jQuery('#micropost_content').val().length;
	if(left == 1){
		var characters_left = '.characters left.'
	}else 
		if ( left < 0 ){
			var characters_left = '.characters too many.'
		}else{
			var  characters_left = ' characters left.'
		}

		jQuery('.countdown').text(Math.abs(left))+ characters_left;
}

jQuery(document).ready(function($){
	updateCountdown();
	$(#micropost_content).change(updateCountdown);
	$(#micropost_content).keyup(updateCountdown);
});