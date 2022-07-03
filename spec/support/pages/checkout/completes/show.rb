# frozen_string_literal: true

module Pages
  module Checkout
    module Completes
      class Show < SitePrism::Page
        set_url '/checkout/complete{?params*}'

        element :page_title, '.general-title-margin'
        element :thank_you_message, '.general-subtitle'
        element :email_sent_message, '.email-sent-message'
        elements :order_number, '.general-order-number'
        elements :complete_date, '.complete-date'
        element :order_summary_title, '.order-summary-title'
        element :back_to_store_button, '.mb-20.btn-default'

        section :checkout_progress_bar, Pages::Sections::CheckoutProgressBar, '.checkout-progress'
        section :order_summary_table, Pages::Sections::OrderSummary, '.general-summary-table'
        section :address_block, Pages::Sections::AddressBlock, '.address-block'
        section :cart_items_table, Pages::Sections::CartItemsTable, '.cart-items-table'
      end
    end
  end
end
