function checkoutOrderSummary() {
  let currency, discount, order_subtotal, order_total, shipping, shipping_value;
  currency = $('.order-subtotal').text().match(/\D/)[0];
  shipping = $(":radio:checked").parents('tr').find('.shipping-price').text();
  discount = parseFloat($('.discount').text().match(/[\d.]+/g));
  order_subtotal = parseFloat($('.order-subtotal').text().match(/[\d.]+/g));
  shipping_value = parseFloat(shipping.match(/[\d.]+/g));

  subtotal_w_shipping = order_subtotal + shipping_value
  order_total = (subtotal_w_shipping <= discount) ? 0 : (subtotal_w_shipping - discount)

  $('.shipping-amount').text(shipping);
  $('.order-total').text(currency + order_total.toFixed(2));
};

$(document).ready(function(){
  window.checkoutOrderSummary = checkoutOrderSummary;
  $('.radio-label').click(function() {
    checkoutOrderSummary();
  });
});
