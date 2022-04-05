# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    user_account { UserAccount.take }

    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    address { FFaker::Address.street_address }
    country_code { FFaker::Address.country_code }
    city { FFaker::Address.city }
    zip { FFaker::AddressUS.zip_code }
    phone { FFaker::PhoneNumberPL.international_mobile_phone_number }
    type { %w[BillingAddress ShippingAddress].sample }
  end
end
