# frozen_string_literal: true

RSpec.describe 'Books->Edit', type: :feature do
  let(:edit_book_page) { Pages::Admin::Books::Edit.new }
  let(:admin) { create(:admin_user) }
  let(:category) { create(:category) }
  let(:book) { create(:book, category: category) }

  before do
    sign_in(admin)
    edit_book_page.load(id: book.id)
  end

  context 'when shows elements on page' do
    it 'all book attributes labels present' do
      expect(edit_book_page).to have_category_label
      expect(edit_book_page).to have_authors_label
      expect(edit_book_page).to have_materials_label
      expect(edit_book_page).to have_title_label
      expect(edit_book_page).to have_description_label
      expect(edit_book_page).to have_year_publication_label
      expect(edit_book_page).to have_height_label
      expect(edit_book_page).to have_width_label
      expect(edit_book_page).to have_depth_label
      expect(edit_book_page).to have_price_label
      expect(edit_book_page).to have_quantity_label
      expect(edit_book_page).to have_submit_button
      expect(edit_book_page).to have_cancel_button
    end

    it 'all fields have appropriate values' do
      expect(edit_book_page.category_field.value).to eq(book.category.id.to_s)
      expect(edit_book_page.title_field.value).to eq(book.title.to_s)
      expect(edit_book_page.description_field.text).to eq(book.description.to_s)
      expect(edit_book_page.year_publication_field.value).to eq(book.year_publication.to_s)
      expect(edit_book_page.height_field.value).to eq(book.height.to_s)
      expect(edit_book_page.width_field.value).to eq(book.width.to_s)
      expect(edit_book_page.depth_field.value).to eq(book.depth.to_s)
      expect(edit_book_page.price_field.value).to eq(book.price.to_s)
      expect(edit_book_page.quantity_field.value).to eq(book.quantity.to_s)
    end
  end

  context 'when update book successfull' do
    let!(:other_category) { create(:category) }
    let(:params) { attributes_for(:book, category_id: other_category.id) }
    let(:notice_message) { I18n.t('flash.actions.update.notice', resource_name: Book.to_s) }

    before do
      edit_book_page.load(id: book.id)
      edit_book_page.fill_and_submit_form(params)
      book.reload
    end

    it 'updates book category' do
      expect(book.category.id).to eq(other_category.id)
    end

    it 'updates book title' do
      expect(book.title).to eq(params[:title])
    end

    it 'shows apropriate flash message' do
      expect(edit_book_page).to have_flash_notice
      expect(edit_book_page.flash_notice.text).to match(notice_message)
    end

    it 'redirects to show book path' do
      expect(page).to have_current_path(admin_book_path(book))
    end
  end

  context 'when update book failed' do
    let(:params) { attributes_for(:book, title: '', category_id: category.id) }
    let(:error_message) { I18n.t('activerecord.errors.messages.blank') }

    before do
      edit_book_page.fill_and_submit_form(params)
      book.reload
    end

    it 'returns blank error' do
      expect(edit_book_page).to have_title_error(text: error_message)
    end
  end
end
