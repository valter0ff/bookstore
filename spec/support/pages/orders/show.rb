# frozen_string_literal: true

module Pages
  module Orders
    class Show < SitePrism::Page
      set_url '/orders/{id}'

      element :page_title, '.general-title-margin'
      element :billing_address_title, 'h3.billing-title'
      element :shipping_address_title, 'h3.shipping-title'
      element :shipping_method_title, 'h3.shipping-method-title'
      element :shipping_method_name, 'span.shipping-method-name'
      element :payment_title, 'h3.payment-title'
      element :credit_card_number, 'span.credit-card-number'
      element :credit_card_expiry_date, 'span.credit-card-expiry-date'
      element :order_summary_title, '.order-summary-title'

      section :order_summary_table, Pages::Sections::OrderSummary, '.general-summary-table'
      sections :address_block, Pages::Sections::AddressBlock, '.address-block'
      section :cart_items_table, Pages::Sections::CartItemsTable, '.cart-items-table'
    end
  end
end
