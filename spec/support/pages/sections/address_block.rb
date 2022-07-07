# frozen_string_literal: true

module Pages
  module Sections
    class AddressBlock < SitePrism::Section
      element :address_full_name, 'span.address-full-name'
      element :address_address, 'span.address-address'
      element :address_city_zip, 'span.address-city-zip'
      element :address_country, 'span.address-country'
      element :address_phone, 'span.address-phone'
    end
  end
end
