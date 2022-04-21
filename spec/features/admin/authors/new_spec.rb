# frozen_string_literal: true

RSpec.describe 'Authors->New', type: :feature do
  let(:new_author_page) { Pages::Admin::Authors::New.new }
  let(:admin) { create(:admin_user) }
  let(:author_form) { new_author_page.author_form }
  let(:author) { Author.first }

  before do
    sign_in(admin)
    new_author_page.load
  end

  context 'when shows elements on page' do
    it 'all author attributes labels present' do
      expect(author_form).to have_first_name_label
      expect(author_form).to have_last_name_label
      expect(author_form).to have_description_label
      expect(author_form).to have_submit_button
      expect(author_form).to have_cancel_button
    end
  end

  context 'when create author successfull' do
    let(:params) { attributes_for(:author) }
    let(:notice_message) { I18n.t('flash.actions.create.notice', resource_name: Author.to_s) }

    before do |example|
      new_author_page.create_author(author_form, params) unless example.metadata[:skip_before]
    end

    it 'creates author in database', skip_before: true do
      expect { new_author_page.create_author(author_form, params) }.to change(Author, :count).by(1)
    end

    it 'updates new author`s attributes' do
      expect(author.first_name).to eq(params[:first_name])
      expect(author.last_name).to eq(params[:last_name])
      expect(author.description).to eq(params[:description])
    end

    it 'shows apropriate flash message' do
      expect(new_author_page).to have_flash_notice
      expect(new_author_page.flash_notice.text).to match(notice_message)
    end

    it 'redirects to index authors page' do
      expect(page).to have_current_path(admin_author_path(author))
    end
  end

  context 'when create author failed' do
    let(:params) { { first_name: '', last_name: '', description: '' } }
    let(:error_message) { I18n.t('activerecord.errors.messages.blank') }

    before { new_author_page.create_author(author_form, params) }

    it 'returns blank error' do
      expect(author_form).to have_first_name_error(text: error_message)
      expect(author_form).to have_last_name_error(text: error_message)
      expect(author_form).to have_description_error(text: error_message)
    end
  end
end
