# frozen_string_literal: true

RSpec.describe 'Books' do
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

      before do
        book_info.read_more.click
        book_info.wait_until_description_visible
      end

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
