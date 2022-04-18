$('.checkbox-input').click(function() {
 if ($(this).is(':checked')) {
  $('.remove-account-block a.btn').removeClass('disabled');
 } else {
  $('.remove-account-block a.btn').addClass('disabled');
 }
}); 
