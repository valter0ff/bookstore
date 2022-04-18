# frozen_string_literal: true

RSpec.describe 'Books->View', type: :feature do
  let(:view_book_page) { Pages::Admin::Books::View.new }
  let(:admin) { create(:admin_user) }
  let(:category) { create(:category) }
  let(:book) { create(:book, category: category) }

  before do
    sign_in(admin)
    view_book_page.load(id: book.id)
  end

  shared_examples 'all fields have appropriate values' do
    it 'populate all fields with exact values' do
      expect(view_book_page.category_field.value).to eq(book.category.id.to_s)
      expect(view_book_page.title_field.value).to eq(book.title.to_s)
      expect(view_book_page.description_field.text).to eq(book.description.to_s)
      expect(view_book_page.year_publication_field.value).to eq(book.year_publication.to_s)
      expect(view_book_page.height_field.value).to eq(book.height.to_s)
      expect(view_book_page.width_field.value).to eq(book.width.to_s)
      expect(view_book_page.depth_field.value).to eq(book.depth.to_s)
      expect(view_book_page.price_field.value).to eq(book.price.to_s)
      expect(view_book_page.quantity_field.value).to eq(book.quantity.to_s)
    end
  end

  context 'when render view page' do
    it 'all book attributes labels present' do
      expect(view_book_page).to have_category_label
      expect(view_book_page).to have_authors_label
      expect(view_book_page).to have_materials_label
      expect(view_book_page).to have_title_label
      expect(view_book_page).to have_description_label
      expect(view_book_page).to have_year_publication_label
      expect(view_book_page).to have_height_label
      expect(view_book_page).to have_width_label
      expect(view_book_page).to have_depth_label
      expect(view_book_page).to have_price_label
      expect(view_book_page).to have_quantity_label
      expect(view_book_page).to have_submit_button
      expect(view_book_page).to have_cancel_button
    end

    it_behaves_like 'all fields have appropriate values'
  end

  context 'when submit form with updated data' do
    let(:other_category) { create(:category) }
    let(:params) { attributes_for(:book, category_id: other_category.id) }
    let(:notice_message) { I18n.t('flash.actions.update.notice', resource_name: Book.to_s) }

    before do
      view_book_page.fill_and_submit_form(params)
      book.reload
    end

    it_behaves_like 'all fields have appropriate values'

    it 'updates book title' do
      expect(book.category.title).to eq(other_category.title)
    end
    
    it 'updates book title' do
      expect(book.title).to eq(params[:title])
    end

    it 'shows apropriate flash message' do
      expect(view_book_page).to have_flash_notice
      expect(view_book_page.flash_notice.text).to match(notice_message)
    end
  end
end
