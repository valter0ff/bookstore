# frozen_string_literal: true

module Pages
  module Sections
    class OrderSummary < SitePrism::Section
      element :order_summary_title, '.order-summary-title'
      element :order_subtotal_title, '.order-subtotal-title'
      element :order_subtotal, '.order-subtotal'
      element :coupon_title, '.coupon-title'
      element :discount, '.discount'
      element :order_total_title, '.order-total-title'
      element :order_total, '.order-total'
      element :shipping_title, '.shipping-title'
      element :shipping_amount, '.shipping-amount'
    end
  end
end
