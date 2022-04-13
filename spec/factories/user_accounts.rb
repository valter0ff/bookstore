# frozen_string_literal: true

FactoryBot.define do
  factory :user_account do
    email { FFaker::Internet.email }
    password { "#{FFaker::Internet.password}aA1" }
  end
end
