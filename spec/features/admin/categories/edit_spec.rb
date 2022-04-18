# frozen_string_literal: true

RSpec.describe 'Categories->Edit', type: :feature do
  let(:edit_category_page) { Pages::Admin::Categories::Edit.new }
  let(:admin) { create(:admin_user) }
  let(:category) { create(:category) }

  before do
    sign_in(admin)
    edit_category_page.load(id: category.id)
  end

  context 'when shows elements on page' do
    it 'all category attributes labels present' do
      expect(edit_category_page).to have_title_label
      expect(edit_category_page).to have_submit_button
      expect(edit_category_page).to have_cancel_button
    end

    it 'all fields have appropriate values' do
      expect(edit_category_page.title_field.value).to eq(category.title.to_s)
    end
  end

  context 'when update category successfull' do
    let(:params) { attributes_for(:category) }
    let(:notice_message) { I18n.t('flash.actions.update.notice', resource_name: Category.to_s) }

    before do
      edit_category_page.load(id: category.id)
      edit_category_page.fill_and_submit_form(params)
      category.reload
    end

    it 'updates category`s title' do
      expect(category.title).to eq(params[:title])
    end

    it 'shows apropriate flash message' do
      expect(edit_category_page).to have_flash_notice
      expect(edit_category_page.flash_notice.text).to match(notice_message)
    end

    it 'redirects to show category path' do
      expect(page).to have_current_path(admin_category_path(category))
    end
  end

  context 'when update category failed' do
    let(:params) { { title: '' } }
    let(:error_message) { I18n.t('activerecord.errors.messages.blank') }

    before do
      edit_category_page.fill_and_submit_form(params)
      category.reload
    end

    it 'returns blank error' do
      expect(edit_category_page).to have_title_error(text: error_message)
    end
  end
end
