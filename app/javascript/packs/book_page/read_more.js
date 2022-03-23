$(document).ready(function(){
  $('.read-more').on('click', function(e) {
//    let fullContent = $(this).parent().attr('data-full-content')
    e.preventDefault()
    $(this).parent().html(gon.book_full_description)
  })
});
