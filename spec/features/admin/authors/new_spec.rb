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
    it_behaves_like 'all attributes labels present'
  end

  context 'when create author successfull' do
    let(:params) { attributes_for(:author) }
    let(:notice_message) { I18n.t('flash.actions.create.notice', resource_name: Author.to_s) }

    before do |example|
      author_form.fill_and_submit_form(params) unless example.metadata[:skip_before]
    end

    it 'creates author in database', skip_before: true do
      expect { author_form.fill_and_submit_form(params) }.to change(Author, :count).by(1)
    end

    it_behaves_like 'updates author`s attributes'

    it_behaves_like 'shows apropriate flash message' do
      let(:page) { new_author_page }
    end

    it 'redirects to index authors page' do
      expect(page).to have_current_path(admin_author_path(author))
    end
  end

  context 'when create author failed' do
    it_behaves_like 'returns blank errors'
  end
end
