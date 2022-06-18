# frozen_string_literal: true

module Pages
  module Helpers
    module AddressFormFieldsFillable
      def fill_form_fields(form, params)
        form.first_name_input.set(params[:first_name])
        form.last_name_input.set(params[:last_name])
        form.city_input.set(params[:city])
        form.address_input.set(params[:address])
        form.zip_input.set(params[:zip])
        form.country_input.select(country_name(params[:country_code]))
        form.phone_input.set(params[:phone])
      end

      private

      def country_name(country_code)
        country = ISO3166::Country[country_code]
        country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name
      end
    end
  end
end
