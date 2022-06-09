# frozen_string_literal: true

FactoryBot.define do
  factory :user_account do
    email { FFaker::Internet.email }
    password { "#{FFaker::Internet.password}aA1" }
    password_confirmation { password }

    trait :with_avatar do
      picture { association :picture, imageable: instance }
    end
  end
end
