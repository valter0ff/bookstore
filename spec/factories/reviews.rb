# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    title { FFaker::Lorem.unique.phrase }
    rating { rand(1..5) }
    body { FFaker::Lorem.unique.paragraph }
    book
  end
end
