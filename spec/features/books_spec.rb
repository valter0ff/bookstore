# frozen_string_literal: true

RSpec.describe 'Books' do
  describe '#index' do
    let(:index_page) { Pages::Books::Index.new }
    let!(:category) { create(:category) }
    let(:books_count) { rand(2..10) }

    before do
      create_list(:book_with_reviews, books_count, category: category)
      index_page.load
    end

    context 'when all elements present' do
      let(:books_count) { rand(13..20) }

      it { expect(index_page).to have_page_title }
      it { expect(index_page).to have_next_page_button }
      it { expect(index_page).to have_books }
      it { expect(index_page).to have_all_books_link }
      it { expect(index_page).to have_category_dropdown }
      it { expect(index_page).to have_sorting_dropdowns }
      it { expect(index_page).to have_sorting_options }
      it { expect(index_page).to have_category_filters }
    end

    context 'when all book card elements present' do
      let(:book_card) { index_page.books.first }

      it { expect(book_card).to have_show_link }
      it { expect(book_card).to have_buy_link }
      it { expect(book_card).to have_book_title }
      it { expect(book_card).to have_price }
      it { expect(book_card).to have_authors }
    end

    context 'when category filter used' do
      it 'request filter with url params' do
        index_page.load(query: { category_id: category.id })
        expect(index_page.books.size).to eq(category.books.size)
      end

      it 'click category filter' do
        index_page.category_filters.first.click
        expect(index_page.books.size).to eq(category.books.size)
      end
    end

    context 'when sorting used' do
      let!(:books_before) { index_page.books }

      it 'clicks and changes books order' do
        within(index_page.sorting_dropdowns.first) do
          index_page.sorting_options.first.select_option
        end
        expect(index_page.books.first).not_to eq(books_before.first)
      end
    end

    context 'when View more button clicked' do
      let(:books_count) { 20 }

      it 'clicks and loads more books to page', js: true do
        index_page.next_page_button.click
        expect(index_page.books.size).to eq(books_count)
      end
    end
  end
end
