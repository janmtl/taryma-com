jQuery(document).ready(function($){
  $('#filter_dropdown').on('click', function(){
    $('#gallery_form').toggle();
    $('#filter_blackout').toggle();
  });
  $('#filter_blackout').on('click', function(){
    $('#gallery_form').toggle();
    $('#filter_blackout').toggle();
  });
}); 