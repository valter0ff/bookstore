# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { FFaker::Book.genre + rand(999).to_s }
    year_publication { rand(1990..2020) }
    description { FFaker::Book.unique.description * rand(1..3) }
    height { rand(5.0..10.0).round(1) }
    width { rand(0.5..1.0).round(1) }
    depth { rand(4.0..7.0).round(1) }
    price { rand(5...150) }
    quantity { rand(1..20) }
    category

    factory :book_with_reviews do
      transient do
        reviews_count { 5 }
      end

      after(:create) do |book, evaluator|
        create_list(:review, evaluator.reviews_count, book: book)

        book.reload
      end
    end

    trait :with_picture do
      pictures { [(association :picture, imageable: instance)] }
    end
  end
end
