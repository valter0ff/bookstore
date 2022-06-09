# frozen_string_literal: true

FactoryBot.define do
  factory :coupon do
    code { SecureRandom.uuid }
    discount { rand(10...20) }
    status { 0 }
  end
end
