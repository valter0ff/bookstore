# frozen_string_literal: true

CountrySelect::FORMATS[:with_data_attrs] = lambda do |country|
  [
    country.iso_short_name,
    country.alpha2,
    {
      'data-country-code' => country.country_code
    }
  ]
end
