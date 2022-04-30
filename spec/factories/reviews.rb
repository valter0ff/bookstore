# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    title { FFaker::Lorem.unique.phrase[0..79] }
    rating { rand(1..5) }
    body { FFaker::Lorem.unique.paragraph }
    status { rand(0..2) }
    book
    user_account
  end
end
