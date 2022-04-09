# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.html_safe_last_name }
    address { FFaker::Address.street_address }
    country_code { FFaker::Address.country_code }
    city { FFaker::AddressAU.city }
    zip { FFaker::AddressUS.zip_code }
    phone { FFaker::PhoneNumberPL.international_mobile_phone_number }
    type { %w[BillingAddress ShippingAddress].sample }
    user_account_id { UserAccount.take.id }
  end
end
