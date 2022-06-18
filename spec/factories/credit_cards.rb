# frozen_string_literal: true

FactoryBot.define do
  factory :credit_card do
    number { FFaker::Bank.card_number.delete(' ') }
    holder_name { FFaker::Lorem.word }
    expiry_date { FFaker::Bank.card_expiry_date }
    cvv_code { rand(100..9999) }
    order
  end
end
