# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    first_name { FFaker::Lorem.word }
    last_name { FFaker::Lorem.word }
    address { FFaker::Address.street_address }
    country_code { FFaker::Address.country_code }
    city { FFaker::Lorem.word }
    zip { FFaker::AddressUS.zip_code }
    phone { FFaker::PhoneNumberPL.international_mobile_phone_number }
    type { %w[BillingAddress ShippingAddress].sample }
    user_account
  end
end
