# frozen_string_literal: true

FactoryBot.define do
  factory :material do
    title { FFaker::Lorem.word }
  end
end
