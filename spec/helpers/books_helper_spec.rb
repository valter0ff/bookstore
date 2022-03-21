# frozen_string_literal: true

RSpec.describe BooksHelper, type: :helper do
  before do
    create_list(:book, rand(2..50))
  end

  describe '#all_books_count' do
    it 'returns count of books in database' do
      expect(helper.all_books_count).to eq(Book.count)
    end

    it 'returns correct count of books in database' do
      expect(helper.all_books_count).not_to eq(Book.count + 1)
    end
  end
end
