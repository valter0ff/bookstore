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

  describe '#show' do
    let(:show_page) { Pages::Books::Show.new }
    let(:long_description) { FFaker::Book.description * rand(3..5) }
    let(:book) { create(:book, materials: create_list(:material, 2), description: long_description) }
    let(:book_info) { show_page.book_info }

    before { show_page.load(id: book.id) }

    context 'when all book elements present' do
      it { expect(show_page).to have_back_button }
      it { expect(show_page).to have_product_gallery }
      it { expect(show_page).to have_book_info }

      it { expect(show_page.product_gallery).to have_main_image }
      it { expect(show_page.product_gallery).to have_preview_images }

      it { expect(book_info).to have_book_title }
      it { expect(book_info).to have_authors }
      it { expect(book_info).to have_price }
      it { expect(book_info).to have_description }
      it { expect(book_info).to have_year_publication }
      it { expect(book_info).to have_dimensions }
      it { expect(book_info).to have_materials }
      it { expect(book_info).to have_cart_button }
      it { expect(book_info).to have_plus_button }
      it { expect(book_info).to have_minus_button }
      it { expect(book_info).to have_quantity_input }
      it { expect(book_info).to have_read_more }
    end

    context 'when book description shorter than 250 symbols' do
      let(:book) { create(:book, description: FFaker::Book.genre) }

      it 'does not show a read more button' do
        expect(book_info).to have_no_read_more
      end
    end

    context 'when read more clicked' do
      let!(:truncated_description) { book_info.description.text }

      before { book_info.read_more.click }

      it 'displays book full description', js: true do
        expect(book_info.description.text.size).to be > truncated_description.size
        expect(book_info.description.text.size).to eq(book.description.size)
      end
    end

    context 'when clicking the ‘-’ or ‘+’ buttons' do
      let(:book_quantity) { book_info.quantity_input }

      it 'increases quantity in the input field by 1', js: true do
        expect { book_info.plus_button.click }.to change(book_quantity, :value).from('1').to('2')
      end

      it 'reduces quantity in the input field by 1', js: true do
        expect { book_info.minus_button.click }.to change(book_quantity, :value).from('1').to('0')
      end
    end
  end
end
