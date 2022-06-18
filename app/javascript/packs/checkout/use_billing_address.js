$('.checkbox-input').click(function() {
  if ($(this).is(':checked')) {
    $('.shipping-form').addClass('hidden');
  } else {
    $('.shipping-form').removeClass('hidden');
  }
});
