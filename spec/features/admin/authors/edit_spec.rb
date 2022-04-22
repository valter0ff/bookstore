# frozen_string_literal: true

RSpec.describe 'Authors->Edit', type: :feature do
  let(:edit_author_page) { Pages::Admin::Authors::Edit.new }
  let(:admin) { create(:admin_user) }
  let(:author) { create(:author) }
  let(:author_form) { edit_author_page.author_form }

  before do
    sign_in(admin)
    edit_author_page.load(id: author.id)
  end

  context 'when shows elements on page' do
    it_behaves_like 'all attributes labels present'

    it 'all fields have appropriate values' do
      expect(author_form.first_name_field.value).to eq(author.first_name.to_s)
      expect(author_form.last_name_field.value).to eq(author.last_name.to_s)
      expect(author_form.description_field.value).to eq(author.description.to_s)
    end
  end

  context 'when update author successfull' do
    let(:params) { attributes_for(:author) }
    let(:notice_message) { I18n.t('flash.actions.update.notice', resource_name: Author.to_s) }

    before do
      author_form.fill_and_submit_form(params)
      author.reload
    end

    it_behaves_like 'updates author`s attributes'

    it_behaves_like 'shows apropriate flash message' do
      let(:page) { edit_author_page }
    end

    it 'redirects to show author path' do
      expect(page).to have_current_path(admin_author_path(author))
    end
  end

  context 'when update author failed' do
    it_behaves_like 'returns blank errors'
  end
end
