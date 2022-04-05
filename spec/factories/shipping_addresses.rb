# frozen_string_literal: true

FactoryBot.define do
  factory :shipping_address, parent: :address do
    type { 'ShippingAddress' }
  end
end
