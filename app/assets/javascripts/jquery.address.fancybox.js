//= require jquery.address
//= require jquery.fancybox.pack


jQuery(function($) {
	$('[rel*="fancybox"]').click(function(event){
		event.preventDefault();
	});
	
	var title = document.title;
	var fancybox_is_open = false;
  
  var remote_url = 'http://www.ewataryma.com/';
  var local_url = 'http://localhost:3000/';
  var base_path = location.href.replace(local_url, '').replace(remote_url, '');
  var stripped_path = location.href.replace(local_url+base_path, '').replace(remote_url+base_path, '');
	
	// Init and change handlers
  //$.address.strict(false);
	$.address.state(stripped_path).init(function(event) {
		$('[rel*="fancybox"]').address();
	}).bind('change', function(event) {
		//alert("event.value: " + event.value);
		//if(event.value == "/"){
		if(fancybox_is_open == true){
			$.fancybox.close(true);
			fancybox_is_open = false;
			$.address.title(title);
		}else{
			$('[rel*="fancybox"]').each(function(){
				if($(this).attr('href') == event.value){
					//alert('Opening a box with: ' + $(this).data('fancybox'));
					$.fancybox({
            href:			$(this).data('fancybox'),
            openEffect:  'none', openSpeed:   0, closeEffect:	'none',closeSpeed: 0,
            helpers: {overlay : {speedIn  : 0, speedOut : 0}},
            title: $(this).data('title'), 
						afterClose:	function(){
							//alert('closing with base_path: '+ base_path);
							$.address.value(base_path);
							}
					});
					fancybox_is_open = true;
					$.address.title($(this).data('title'));
				}
			});
		}
	});
});