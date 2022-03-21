# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    title { FFaker::Book.genre + rand(999).to_s }
  end
end
