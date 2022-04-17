# frozen_string_literal: true

RSpec.describe 'AdminUsers->Index', type: :feature do
  let(:index_books_page) { Pages::Admin::Books::Index.new }
  let(:admin) { create(:admin_user) }
  let(:books_count) { rand(2..20) }

  before do |example|
    unless example.metadata[:skip_before]
      create_list(:book, books_count)
      sign_in(admin)
      index_books_page.load
    end
  end

  context 'with page elemens' do
    it 'all elements present' do
      expect(index_books_page).to have_batch_menu_button
      expect(index_books_page).to have_batch_action_destroy_button(text: 'Delete Selected')
      expect(index_books_page).to have_new_book_button
    end
  end

  context 'with books table' do
    let(:books_table) { index_books_page.books_table }

    it 'all elements present' do
      expect(books_table).to have_select_column
      expect(books_table).to have_select_all_checkbox
      expect(books_table).to have_image_column
      expect(books_table).to have_category_column
      expect(books_table).to have_authors_column
      expect(books_table).to have_description_column
      expect(books_table).to have_price_column
      expect(books_table).to have_actions_column
      expect(books_table).to have_view_book_buttons(text: I18n.t('active_admin.view'))
      expect(books_table).to have_delete_book_buttons(text: I18n.t('active_admin.delete'))
    end
  end

  context 'when use batch destroy function', js: true, bullet: :skip do
    let(:notice_message) { /Successfully deleted .+ books/ }

    it 'deletes books from database' do
      expect { index_books_page.batch_delete_books }.to change(Book, :count).by(-books_count)
    end

    it 'shows apropriate flash message' do
      index_books_page.batch_delete_books
      sleep 4
      expect(index_books_page).to have_flash_notice
      expect(index_books_page.flash_notice.text).to match(notice_message)
    end
  end

  context 'when delete one book from table', js: true do
    let(:notice_message) { I18n.t('flash.actions.destroy.notice', resource_name: Book.to_s) }

    it 'deletes one book from database' do
      expect { index_books_page.delete_book }.to change(Book, :count).by(-1)
    end

    it 'shows apropriate flash message' do
      index_books_page.delete_book
      index_books_page.wait_until_flash_notice_visible
      expect(index_books_page).to have_flash_notice
      expect(index_books_page.flash_notice.text).to match(notice_message)
    end
  end
end
