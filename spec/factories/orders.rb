# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user_account
    coupon
    state { 0 }
  end
end
