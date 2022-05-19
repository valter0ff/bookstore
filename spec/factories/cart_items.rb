# frozen_string_literal: true

FactoryBot.define do
  factory :cart_item do
    order
    book
    books_count { rand(1..10) }
  end
end
