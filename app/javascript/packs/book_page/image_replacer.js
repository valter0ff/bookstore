$(document).ready(function(){
  $('.img-thumbnail').on('click', function(e){
      e.preventDefault();
      var img_src = $(this).children('img').attr('src');
      var main_img_scr = $('.main-image').attr('src');
      $('.main-image').attr('src', img_src);
      $(this).children('img').attr('src', main_img_scr)
  });
});
