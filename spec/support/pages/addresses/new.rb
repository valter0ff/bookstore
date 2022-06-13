# frozen_string_literal: true

module Pages
  module Addresses
    class New < SitePrism::Page
      include Pages::Helpers::AddressFormFieldsFiller

      set_url '/settings/addresses/new'

      element :page_title, 'h1.general-title-margin', text: I18n.t('partials.account_settings_menu.title')
      element :address_tab, 'a.address-tab', text: I18n.t('partials.account_settings_menu.address')
      element :privacy_tab, 'a.privacy-tab', text: I18n.t('partials.account_settings_menu.privacy')
      element :billing_title, 'h3.billing-title', text: I18n.t('addresses.new.billing_title')
      element :shipping_title, 'h3.shipping-title', text: I18n.t('addresses.new.shipping_title')

      section :billing_form, Pages::Sections::AddressForm, '.billing-form'
      section :shipping_form, Pages::Sections::AddressForm, '.shipping-form'
    end
  end
end
