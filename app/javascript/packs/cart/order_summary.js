function calculateOrderSummary() {
  let currency = $('.order_subtotal:visible').text().match(/\D/)[0];
  let discount = parseFloat($('.discount:visible').text().match(/[\d\.]+/g));
  let order_subtotal = 0;

  $('.subtotal:visible').each(function(){
    let item_subtotal = parseFloat($(this).text().match(/[\d\.]+/g));
    order_subtotal += item_subtotal;
  });

  let order_total = order_subtotal - discount;

  $('.order_subtotal:visible').text(currency + order_subtotal.toFixed(2));
  $('.order_total:visible').text(currency + order_total.toFixed(2));
};

$(document).ready(function(){
  $('.close.general-cart-close').on('ajax:success',function(){
    calculateOrderSummary();
  });
  $('.fa-plus').on('ajax:success',function(){
    calculateOrderSummary();
  });
    $('.fa-minus').on('ajax:success',function(){
    calculateOrderSummary();
  });
});
