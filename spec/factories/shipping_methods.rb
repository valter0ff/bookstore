# frozen_string_literal: true

FactoryBot.define do
  factory :shipping_method do
    name { FFaker::Lorem.word }
    days { rand(0...20) }
    price { rand(5...150) }
  end
end
