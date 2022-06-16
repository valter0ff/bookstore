# frozen_string_literal: true

module Pages
  module Checkout
    module Deliveries
      class New < SitePrism::Page
        set_url '/checkout/delivery/new'

        element :flash_notice, '#flash_notice'
        element :flash_alert, '#flash_alert'
        element :page_title, '.general-title-margin'
        element :shipping_subtitle, '.general-subtitle'
        element :submit_button, 'input.submit-btn'
        element :order_summary_title, '.order-summary-title'

        section :checkout_progress_bar, Pages::Sections::CheckoutProgressBar, '.checkout-progress'
        section :order_summary_table, Pages::Sections::OrderSummary, '.general-summary-table'

        section :shipping_methods_form, '.shipping-methods-form' do
          elements :shipping_name_title, '.shipping-name-label'
          elements :shipping_time_title, '.shipping-time-label'
          elements :shipping_price_title, '.shipping-price-label'

          sections :shipping_method_info, '.shipping-method-info' do
            element :shipping_name, '.shipping-name'
            element :shipping_time, '.shipping-time'
            element :shipping_price, '.shipping-price'
            element :radio_button, '.radio'
          end
        end
      end
    end
  end
end
