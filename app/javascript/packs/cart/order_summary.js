function calculateOrderSummary() {
  let currency, discount, order_subtotal, item_subtotal, order_total;
  currency = $('.order-subtotal:visible').text().match(/\D/)[0];
  discount = parseFloat($('.discount:visible').text().match(/[\d.]+/g));
  order_subtotal = 0;

  $('.subtotal:visible').each(function(){
    item_subtotal = parseFloat($(this).text().match(/[\d.]+/g));
    order_subtotal += item_subtotal;
  });

  order_total = (order_subtotal <= discount) ? 0 : (order_subtotal - discount);

  $('.order-subtotal:visible').text(currency + order_subtotal.toFixed(2));
  $('.order-total:visible').text(currency + order_total.toFixed(2));
};

$(document).ready(function(){
  window.calculateOrderSummary = calculateOrderSummary;
  $('.close.general-cart-close').on('ajax:success',function(){
    calculateOrderSummary();
  });
});
