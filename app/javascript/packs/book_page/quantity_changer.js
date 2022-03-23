$(document).ready(function(){
  $('i.fa-plus').click(function(e){
    e.preventDefault();
    $('input.quantity-input').val(parseInt($('input.quantity-input').val()) + 1 );
    console.log($('input.quantity-input').val())
  });

  $('i.fa-minus').click(function(e){
    e.preventDefault();
    $('input.quantity-input').val(parseInt($('input.quantity-input').val()) - 1 );
  });
});
 
