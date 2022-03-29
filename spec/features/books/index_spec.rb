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

      it do
        expect(index_page).to have_page_title
        expect(index_page).to have_next_page_button
        expect(index_page).to have_books
        expect(index_page).to have_all_books_link
        expect(index_page).to have_category_dropdown
        expect(index_page).to have_sorting_dropdowns
        expect(index_page).to have_sorting_options
        expect(index_page).to have_category_filters
      end
    end

    context 'when all book card elements present' do
      let(:book_card) { index_page.books.first }

      it do
        expect(book_card).to have_show_link
        expect(book_card).to have_buy_link
        expect(book_card).to have_book_title
        expect(book_card).to have_price
        expect(book_card).to have_authors
      end
    end

    context 'when category filter used' do
      it 'click category filter' do
        index_page.filter_books_by_category
        expect(index_page.books.size).to eq(category.books.size)
      end
    end

    context 'when sorting used' do
      let!(:books_before) { index_page.books }

      it 'clicks and changes books order' do
        within(index_page.sorting_dropdowns.first) do
          index_page.change_books_order
        end
        expect(index_page.books.first).not_to eq(books_before.first)
      end
    end

    context 'when View more button clicked' do
      let(:books_count) { 20 }

      it 'clicks and loads more books to page', js: true do
        index_page.next_page_button.click
        index_page.wait_until_books_visible
        expect(index_page.books.size).to eq(books_count)
      end
    end
  end
end
