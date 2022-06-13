# frozen_string_literal: true

require_relative '../checkout_progress_bar'

module Pages
  module Checkout
    module Addresses
      class New < SitePrism::Page
        set_url '/checkout/address/new'

        element :flash_notice, '#flash_notice'
        element :page_title, '.general-title-margin'
        elements :billing_title, 'h3.billing-title', text: I18n.t('addresses.new.billing_title')
        elements :shipping_title, 'h3.shipping-title', text: I18n.t('addresses.new.shipping_title')
        element :use_billing_checkbox, '.checkbox-input'
        element :submit_button, 'input.submit-btn'
        element :order_summary_title, '.order-summary-title'

        section :checkout_progress_bar, Pages::Checkout::CheckoutProgressBar, '.checkout-progress'
        section :billing_form, Pages::Addresses::AddressForm, '.billing-form'
        section :shipping_form, Pages::Addresses::AddressForm, '.shipping-form'
        section :order_summary_table, Pages::Checkout::OrderSummary, '.general-summary-table'

        def fill_fields(form, params)
          form.first_name_input.set(params[:first_name])
          form.last_name_input.set(params[:last_name])
          form.phone_input.set(params[:phone])
          form.city_input.set(params[:city])
          form.address_input.set(params[:address])
          form.zip_input.set(params[:zip])
          form.country_input.select(country_name(params[:country_code]))
        end

        private

        def country_name(country_code)
          country = ISO3166::Country[country_code]
          country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
        end
      end
    end
  end
end
