# frozen_string_literal: true

module Pages
  module Checkout
    module Addresses
      class Edit < SitePrism::Page
        include Pages::Helpers::AddressFormFieldsFillable

        set_url '/checkout/address/edit'

        element :flash_notice, '#flash_notice'
        element :page_title, '.general-title-margin'
        elements :billing_title, 'h3.billing-title'
        elements :shipping_title, 'h3.shipping-title'
        element :use_billing_checkbox, '.checkbox-icon'
        element :submit_button, 'input.submit-btn'
        element :order_summary_title, '.order-summary-title'

        section :checkout_progress_bar, Pages::Sections::CheckoutProgressBar, '.checkout-progress'
        section :billing_form, Pages::Sections::AddressForm, '.billing-form'
        section :shipping_form, Pages::Sections::AddressForm, '.shipping-form'
        section :order_summary_table, Pages::Sections::OrderSummary, '.general-summary-table'
      end
    end
  end
end
