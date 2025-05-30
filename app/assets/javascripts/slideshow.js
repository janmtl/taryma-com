// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require google-analytics
//= require_self

jQuery(document).ready(function($){

  function slideshow() {
    $('.spinner').hide();
    var index = 0;
    var max = $('.slide[id]').length;
    $('.slide[id]').first().show();
    
    setInterval(function(){
      $('.slide[id='+(index % max)+']').fadeOut(500);
      $('.slide[id='+((index+1) % max)+']').fadeIn(500);
      index++;
    }, $('.images').data('slide_interval'));
  }
  
  function fillWindow() {
    var wH = $(window).height()-150;
    var wW = $(window).width();
    $('.slide').each(function(){
      var iH = $(this).data('height');
      var iW = $(this).data('width');
 
      if (iH/iW < wH/wW){$(this).width(wW).height(wW/iW*iH);
      }else{$(this).height(wH).width(wH/iH*iW);}
      
      $(this).css('margin-top', -0.5*$(this).height()-62);
      $(this).css('margin-left', -0.5*$(this).width());
    });
  }

  $(window).load(function(){
    $('.slide[id]').each(function(){
        $(this).data('height', $(this).height()).data('width', $(this).width());
    });
    fillWindow();
    slideshow();
  });
  
  $(window).on('resize', function(){fillWindow();});
});

// require supersized.min
//jQuery(document).ready(function($){
//  $.ajax({
//    url: '/slides/browse',
//    dataType: 'json',
//    success: function(data){
//      $.supersized({
//        //Functionality
//        slideshow       : 1,    //Slideshow on/off
//        autoplay        : 1,    //Slideshow starts playing automatically
//        start_slide     : 1,    //Start slide (0 is random)
//        random          : 0,    //Randomize slide order (Ignores start slide)
//        slide_interval  : 1500,  //Length between transitions
//        transition      : 1,    //0-None, 1-Fade, 2-Slide Top, 3-Slide Right, 4-Slide Bottom, 5-Slide Left, 6-Carousel Right, 7-Carousel Left
//        transition_speed: 500,  //Speed of transition
//        new_window      : 1,    //Image links open in new window/tab
//        pause_hover     : 0,    //Pause slideshow on hover
//        keyboard_nav    : 1,    //Keyboard navigation on/off
//        performance     : 1,    //0-Normal, 1-Hybrid speed/quality, 2-Optimizes image quality, 3-Optimizes transition speed // (Only works for Firefox/IE, not Webkit)
//        image_protect   : 1,    //Disables image dragging and right click with Javascript
//        image_path      : 'img/', //Default image path
//
//        //Size & Position
//        min_width        : 1,    //Min width allowed (in pixels)
//        min_height       : 1,    //Min height allowed (in pixels)
//        vertical_center  : 1,    //Vertically center background
//        horizontal_center: 1,    //Horizontally center background
//        fit_portrait     : 1,    //Portrait images will not exceed browser height
//        fit_landscape    : 1,    //Landscape images will not exceed browser width
//        fit_always       : 1,    //Prevents cropping
//
//        //Components
//        navigation          : 0,    //Slideshow controls on/off
//        thumbnail_navigation: 0,    //Thumbnail navigation
//        slide_counter       : 0,    //Display slide numbers
//        slide_captions      : 0,    //Slide caption (Pull from "title" in slides array)
//        slides              : data
//      });
//    }
//  });
//});