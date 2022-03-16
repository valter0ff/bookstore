# frozen_string_literal: true

RSpec.describe Review do
  subject(:review) { described_class.new(title: good_title, rating: rating, body: body, book: book) }

  let(:good_title) { FFaker::Lorem.unique.phrase }
  let(:rating) { rand(1..5) }
  let(:body) { FFaker::Lorem.unique.paragraph }
  let(:book) { Book.new(title: good_title, category: Category.new(title: good_title)) }

  it 'is valid with valid attributes' do
    expect(review).to be_valid
  end
end
