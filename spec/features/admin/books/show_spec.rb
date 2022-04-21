# frozen_string_literal: true

RSpec.describe 'Books->Edit', type: :feature do
  let(:show_book_page) { Pages::Admin::Books::Show.new }
  let(:admin) { create(:admin_user) }
  let(:category) { create(:category) }
  let(:book) { create(:book, category: category) }

  before do
    sign_in(admin)
    show_book_page.load(id: book.id)
  end

  context 'when shows book info section' do
    let(:book_info) { show_book_page.book_info }

    it 'all fields present with appropriate values' do
      expect(book_info).to have_book_title(text: book.title)
      expect(book_info).to have_description(text: book.description)
      expect(book_info).to have_year_publication(text: book.year_publication)
      expect(book_info).to have_height(text: book.height)
      expect(book_info).to have_width(text: book.width)
      expect(book_info).to have_depth(text: book.depth)
      expect(book_info).to have_price(text: book.price)
      expect(book_info).to have_quantity(text: book.quantity)
      expect(book_info).to have_category(text: book.category.title)
      expect(book_info).to have_created_at(text: I18n.l(book.created_at, format: :admin))
      expect(book_info).to have_updated_at(text: I18n.l(book.updated_at, format: :admin))
      expect(book_info).to have_materials
      expect(book_info).to have_authors
    end
  end

  context 'when shows action buttons section' do
    let(:buttons_section) { show_book_page.action_buttons }

    it 'all buttons present' do
      expect(buttons_section).to have_edit_button
      expect(buttons_section).to have_delete_button
    end
  end

  context 'when edit button clicked' do
    before { show_book_page.action_buttons.edit_button.click }

    it 'redirects to edit book path' do
      expect(page).to have_current_path(edit_admin_book_path(book))
    end
  end

  context 'when delete button clicked', js: true do
    let(:notice_message) { I18n.t('flash.actions.destroy.notice', resource_name: Book.to_s) }

    it 'deletes book from database' do
      expect { show_book_page.delete_book }.to change(Book, :count).by(-1)
    end

    it 'redirects to books index page' do
      show_book_page.delete_book
      expect(page).to have_current_path(admin_books_path)
    end

    it 'shows apropriate flash message' do
      show_book_page.delete_book
      expect(show_book_page).to have_flash_notice
      expect(show_book_page.flash_notice.text).to match(notice_message)
    end
  end
end
