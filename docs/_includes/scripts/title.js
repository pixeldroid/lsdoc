update_dimensions = function() {
  $( "#result" ).html($(window).width() +' x ' +$(window).height());
}
set_resize_handler = function() {
  update_dimensions();
  $(window).resize(update_dimensions);
};

$(window).on( "load", set_resize_handler)
