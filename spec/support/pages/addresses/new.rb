# frozen_string_literal: true

require_relative './address_form'

module Pages
  module Addresses
    class New < SitePrism::Page
      set_url '/settings/addresses/new'

      element :page_title, 'h1.general-title-margin', text: I18n.t('partials.account_settings_menu.title')
      element :address_tab, 'a.address-tab', text: I18n.t('partials.account_settings_menu.address')
      element :privacy_tab, 'a.privacy-tab', text: I18n.t('partials.account_settings_menu.privacy')
      element :billing_title, 'h3.billing-title', text: I18n.t('addresses.new.billing_title')
      element :shipping_title, 'h3.shipping-title', text: I18n.t('addresses.new.shipping_title')

      section :billing_form, Pages::Addresses::AddressForm, '.billing-form'
      section :shipping_form, Pages::Addresses::AddressForm, '.shipping-form'

      def fill_and_submit_form(form, params)
        form.first_name_input.set(params[:first_name])
        form.last_name_input.set(params[:last_name])
        form.phone_input.set(params[:phone])
        form.city_input.set(params[:city])
        form.address_input.set(params[:address])
        form.zip_input.set(params[:zip])
        form.country_input.select(country_name(params[:country_code]))
        form.submit_button.click
      end

      private

      def country_name(country_code)
        country = ISO3166::Country[country_code]
        country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
      end
    end
  end
end
