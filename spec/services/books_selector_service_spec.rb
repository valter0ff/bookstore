# frozen_string_literal: true

RSpec.describe BooksSelectorService do
  let(:category1) { create(:category) }
  let!(:books) { Book.all }
  let(:sorted_books) { described_class.new(category1, sorted_by).call }

  describe '#call', bullet: :skip do
    before { create_list(:book_with_reviews, rand(5..20), category: category1) }

    context 'when newest first' do
      let(:sorted_by) { 'newest_first' }

      it 'returns newest book first' do
        expect(sorted_books[1..].pluck(:created_at)).to all(be < sorted_books.first.created_at)
      end

      it 'changes books order' do
        expect(sorted_books).not_to eq(books)
      end
    end

    context 'when low price first' do
      let(:sorted_by) { 'price_low_to_high' }

      it 'returns cheapest book first' do
        expect(sorted_books[1..].pluck(:price)).to all(be >= sorted_books.first.price)
      end

      it 'changes books order' do
        expect(sorted_books).not_to eq(books)
      end
    end

    context 'when high price first' do
      let(:sorted_by) { 'price_high_to_low' }

      it 'returns expensive book first' do
        expect(sorted_books[1..].pluck(:price)).to all(be <= sorted_books.first.price)
      end

      it 'changes books order' do
        expect(sorted_books).not_to eq(books)
      end
    end

    context 'when popular_first' do
      let(:sorted_by) { 'popular_first' }
      let(:sorted_average_ratings) { sorted_books[1..].map { |book| book.reviews.average(:rating) } }

      it 'returns first books with highest average rating' do
        expect(sorted_average_ratings).to all(be <= sorted_books.first.reviews.average(:rating))
      end

      it 'changes books order' do
        expect(sorted_books).not_to eq(books)
      end
    end

    context 'when order not set' do
      let(:sorted_by) { FFaker::Lorem.word }

      it 'not changes books order' do
        expect(sorted_books).to eq(books)
      end
    end

    context 'when category filter used' do
      let(:category2) { create(:category) }
      let(:books_cat2) { create_list(:book, rand(5..20), category: category2) }
      let(:filtered_books) { described_class.new(category2, nil).call }

      it 'returns books of exact category' do
        expect(filtered_books).to eq(category2.books)
      end

      it 'not returns books of other category' do
        expect(filtered_books).not_to eq(category1.books)
      end
    end

    context 'when category doesn`t exists' do
      let(:filtered_books) { described_class.new(nil, nil).call }

      it 'returns all books' do
        expect(filtered_books).to eq(books)
      end
    end
  end
end
