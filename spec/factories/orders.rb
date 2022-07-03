# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user_account
    coupon
    state { 0 }
    step { 0 }

    trait :completed do
      billing_address { build(:billing_address).to_json }
      shipping_address { build(:shipping_address).to_json }
      shipping_method
      shipping_price { shipping_method.price }
      completed_at { DateTime.now.in_time_zone }
      number { 'R00000123' }
      state { :in_progress }
      step { :complete }
      with_shipping_method { false }
    end

    trait :filled do
      with_cart_items { true }
      with_credit_card { true }
      with_shipping_method { true }
    end

    transient do
      with_cart_items { false }
      with_credit_card { false }
      with_shipping_method { false }
    end

    after(:build) do |order, evaluator|
      order.cart_items << build(:cart_item) if evaluator.with_cart_items
      order.credit_card = build(:credit_card) if evaluator.with_credit_card
      order.shipping_method = build(:shipping_method) if evaluator.with_shipping_method
    end
  end
end
