# frozen_string_literal: true

FactoryBot.define do
  factory :picture do
    imageable { nil }

    image { Rack::Test::UploadedFile.new('spec/fixtures/images/test.jpg', 'image/jpeg') }
  end
end
