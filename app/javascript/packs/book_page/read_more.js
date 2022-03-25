$(document).ready(function(){
  $('.read-more').on('click', function(e) {
    e.preventDefault()
    $(this).parent().html(gon.book_full_description)
  })
});
