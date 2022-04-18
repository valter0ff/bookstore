# frozen_string_literal: true

CountrySelect::FORMATS[:with_data_attrs] = lambda do |country|
  [
    country.translations[I18n.locale.to_s] || country.common_name || country.iso_short_name,
    country.alpha2,
    {
      'data-country-code' => country.country_code
    }
  ]
end
