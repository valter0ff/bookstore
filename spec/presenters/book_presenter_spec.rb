# frozen_string_literal: true

describe BookPresenter do
  subject(:presenter) { described_class.new(book, view) }

  let(:category) { create(:category) }
  let(:materials) { create_list(:material, 2) }
  let(:reviews) { create_list(:review, 5) }
  let(:authors) { create_list(:author, 2) }
  let(:description) { FFaker::Book.unique.description * 3 }
  let(:book) do
    create(:book,
           description: description,
           authors: authors,
           reviews: reviews,
           materials: materials,
           category: category)
  end
  let(:expected_rating) { (book.reviews.sum(&:rating) / book.reviews.count.to_f).to_s }
  let(:expected_price) { "€ #{format('%.2f', book.price)}" }

  it 'returns average rating of reviews' do
    expect(presenter.average_rating.to_s).to eq(expected_rating)
  end

  it 'returns price with currency' do
    expect(presenter.price_with_currency).to eq(expected_price)
  end
end
