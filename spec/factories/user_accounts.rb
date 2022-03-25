# frozen_string_literal: true

FactoryBot.define do
  factory :user_account do
    email { FFaker::Internet.email }
    password { 'ValidPassword1' }
  end
end
