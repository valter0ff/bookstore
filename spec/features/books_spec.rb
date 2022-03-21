# frozen_string_literal: true

RSpec.describe 'Books' do
  describe '#index' do
    let(:index_page) { Pages::Books::Index.new }
    let(:categories_names) { I18n.t('partials.header.categories').values }
    let(:categories) { categories.map { |name| create(:category, title: name) } }

    before do
      create_list(:book_with_reviews, rand(5..20), category: categories.sample)
      home_page.load
    end
    
    context 'when category filter used' do
      include_context 'with random and category books'

      it 'request filter with url params' do
        index_page.load(query: { category_id: category.id })
        expect(index_page.books.length).to eq(category_books_amount)
      end

      it 'click category filter' do
        index_page.load
        index_page.filters.last.click
        expect(index_page.books.length).to eq(category_books_amount)
      end
    end
  end
end
