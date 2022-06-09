$(document).ready(function(){
  $('.img-thumbnail').on('click', function(e){
      e.preventDefault();
      let img_src = $(this).children('img').attr('src');
      let main_img_scr = $('.main-image').attr('src');
      $('.main-image').attr('src', img_src);
      $(this).children('img').attr('src', main_img_scr)
  });
});
