# frozen_string_literal: true

module Pages
  module Checkout
    class OrderSummary < SitePrism::Section
      element :order_summary_title, '.order-summary-title'
      element :order_subtotal_title, '.order-subtotal-title'
      element :order_subtotal, '.order-subtotal'
      element :coupon_title, '.coupon-title'
      element :discount, '.discount'
      element :order_total_title, '.order-total-title'
      element :order_total, '.order-total'
    end
  end
end
