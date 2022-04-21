# frozen_string_literal: true

RSpec.describe 'Authors->Edit', type: :feature do
  let(:edit_author_page) { Pages::Admin::Authors::Edit.new }
  let(:admin) { create(:admin_user) }
  let(:author) { create(:author) }

  before do
    sign_in(admin)
    edit_author_page.load(id: author.id)
  end

  context 'when shows elements on page' do
    it 'all author attributes labels present' do
      expect(edit_author_page).to have_first_name_label
      expect(edit_author_page).to have_last_name_label
      expect(edit_author_page).to have_description_label
      expect(edit_author_page).to have_submit_button
      expect(edit_author_page).to have_cancel_button
    end

    it 'all fields have appropriate values' do
      expect(edit_author_page.first_name_field.value).to eq(author.first_name.to_s)
      expect(edit_author_page.last_name_field.value).to eq(author.last_name.to_s)
      expect(edit_author_page.description_field.value).to eq(author.description.to_s)
    end
  end

  context 'when update author successfull' do
    let(:params) { attributes_for(:author) }
    let(:notice_message) { I18n.t('flash.actions.update.notice', resource_name: Author.to_s) }

    before do
      edit_author_page.fill_and_submit_form(params)
      author.reload
    end

    it 'updates author`s attributes' do
      expect(author.first_name).to eq(params[:first_name])
      expect(author.last_name).to eq(params[:last_name])
      expect(author.description).to eq(params[:description])
    end

    it 'shows apropriate flash message' do
      expect(edit_author_page).to have_flash_notice
      expect(edit_author_page.flash_notice.text).to match(notice_message)
    end

    it 'redirects to show author path' do
      expect(page).to have_current_path(admin_author_path(author))
    end
  end

  context 'when update author failed' do
    let(:params) { attributes_for(:author, first_name: '', last_name: '') }
    let(:error_message) { I18n.t('activerecord.errors.messages.blank') }

    before do
      edit_author_page.fill_and_submit_form(params)
      author.reload
    end

    it 'returns blank error' do
      expect(edit_author_page).to have_first_name_error(text: error_message)
      expect(edit_author_page).to have_last_name_error(text: error_message)
    end
  end
end
