$(document).ready(function(){
  $('.read-more').on('click', function(e) {
    let fullContent = $(this).parent().attr('data-full-content')
    e.preventDefault()
    $(this).parent().html(fullContent)
  })

  $('i.fa-plus').click(function(e){
    e.preventDefault();
    $('input.quantity-input').val(parseInt($('input.quantity-input').val()) + 1 );
  });

  $('i.fa-minus').click(function(e){
    e.preventDefault();
    $('input.quantity-input').val(parseInt($('input.quantity-input').val()) - 1 );
  });
});
