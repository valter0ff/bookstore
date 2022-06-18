# frozen_string_literal: true

module Pages
  module Sections
    class AddressForm < SitePrism::Section
      element :first_name_label, 'label.first-name-label', text: I18n.t('addresses.address_form.first_name')
      element :first_name_input, 'input[id*=firstName]'
      element :last_name_label, 'label.last-name-label', text: I18n.t('addresses.address_form.last_name')
      element :last_name_input, 'input[id*=lastName]'
      element :address_label, 'label.address-label', text: I18n.t('addresses.address_form.address')
      element :address_input, 'input[id*=address]'
      element :city_label, 'label.city-label', text: I18n.t('addresses.address_form.city')
      element :city_input, 'input[id*=city]'
      element :zip_label, 'label.zip-label', text: I18n.t('addresses.address_form.zip')
      element :zip_input, 'input[id*=zip]'
      element :country_label, 'label.country-label', text: I18n.t('addresses.address_form.country')
      element :country_input, 'select[id*=country]'
      element :phone_label, 'label.phone-label', text: I18n.t('addresses.address_form.phone')
      element :phone_input, 'input[id*=phone]'
      element :submit_button, 'input.submit-btn'
      element :error_message, '.error.text-danger'
    end
  end
end
