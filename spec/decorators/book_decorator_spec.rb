# frozen_string_literal: true

describe BookDecorator do
  subject(:decorated_book) { described_class.new(book) }

  let(:reviews) { create_list(:review, 5) }
  let(:book) { create(:book, reviews: reviews) }
  let(:expected_rating) { (book.reviews.sum(&:rating) / book.reviews.count.to_f).to_s }
  let(:expected_price) { "€#{format('%.2f', book.price)}" }

  it 'returns average rating of reviews' do
    expect(decorated_book.average_rating.to_s).to eq(expected_rating)
  end

  it 'returns price with currency' do
    expect(decorated_book.price_with_currency).to eq(expected_price)
  end
end
