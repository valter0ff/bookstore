# frozen_string_literal: true

FactoryBot.define do
  factory :billing_address, parent: :address do
    type { 'BillingAddress' }
  end
end
