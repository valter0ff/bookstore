# frozen_string_literal: true

RSpec.describe 'Categories->New', type: :feature do
  let(:new_category_page) { Pages::Admin::Categories::New.new }
  let(:admin) { create(:admin_user) }
  let(:category) { Category.first }
  let(:category_form) { new_category_page.category_form }

  before do
    sign_in(admin)
    new_category_page.load
  end

  context 'when shows elements on page' do
    it 'all category attributes labels present' do
      expect(category_form).to have_title_label
      expect(category_form).to have_submit_button
      expect(category_form).to have_cancel_button
    end
  end

  context 'when create category successfull' do
    let(:params) { attributes_for(:category) }
    let(:notice_message) { I18n.t('flash.actions.create.notice', resource_name: Category.to_s) }

    before do
      category_form.fill_and_submit_form(params)
      category.reload
    end

    it 'updates category`s title' do
      expect(category.title).to eq(params[:title])
    end

    it 'shows apropriate flash message' do
      expect(new_category_page).to have_flash_notice
      expect(new_category_page.flash_notice.text).to match(notice_message)
    end

    it 'redirects to show category path' do
      expect(page).to have_current_path(admin_category_path(category))
    end
  end

  context 'when create category failed' do
    let(:params) { { title: '' } }
    let(:error_message) { I18n.t('activerecord.errors.messages.blank') }

    before { category_form.fill_and_submit_form(params) }

    it 'returns blank error' do
      expect(category_form).to have_title_error(text: error_message)
    end
  end
end
