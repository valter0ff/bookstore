# frozen_string_literal: true

FactoryBot.define do
  factory :author do
    first_name { FFaker::Name.unique.first_name }
    last_name  { FFaker::Name.unique.last_name }
    description { FFaker::Lorem.paragraph }
  end
end
