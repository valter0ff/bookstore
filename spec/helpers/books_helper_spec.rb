# frozen_string_literal: true

RSpec.describe BooksHelper, type: :helper do
  describe '#all_books_count' do
    it 'returns the default title' do
      expect(helper.all_books_count).to eq(Book.count)
    end
  end
end
