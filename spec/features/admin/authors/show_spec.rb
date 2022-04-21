# frozen_string_literal: true

RSpec.describe 'Authors->Show', type: :feature do
  let(:show_author_page) { Pages::Admin::Authors::Show.new }
  let(:admin) { create(:admin_user) }
  let(:author) { create(:author) }

  before do
    sign_in(admin)
    show_author_page.load(id: author.id)
  end

  context 'when shows author info section' do
    let(:author_info) { show_author_page.author_info }

    it 'all fields present with appropriate values' do
      expect(author_info).to have_author_first_name(text: author.first_name)
      expect(author_info).to have_author_last_name(text: author.last_name)
      expect(author_info).to have_description(text: author.description)
      expect(author_info).to have_created_at(text: I18n.l(author.created_at, format: :admin))
      expect(author_info).to have_updated_at(text: I18n.l(author.updated_at, format: :admin))
    end
  end

  context 'when shows action buttons section' do
    let(:buttons_section) { show_author_page.action_buttons }

    it 'all buttons present' do
      expect(buttons_section).to have_edit_button
      expect(buttons_section).to have_delete_button
    end
  end

  context 'when edit button clicked' do
    before { show_author_page.action_buttons.edit_button.click }

    it 'redirects to edit author path' do
      expect(page).to have_current_path(edit_admin_author_path(author))
    end
  end

  context 'when delete button clicked', js: true do
    let(:notice_message) { I18n.t('flash.actions.destroy.notice', resource_name: Author.to_s) }

    it 'deletes author from database' do
      expect { show_author_page.delete_author }.to change(Author, :count).by(-1)
    end

    it 'redirects to authors index page' do
      show_author_page.delete_author
      expect(page).to have_current_path(admin_authors_path)
    end

    it 'shows apropriate flash message' do
      show_author_page.delete_author
      expect(show_author_page).to have_flash_notice
      expect(show_author_page.flash_notice.text).to match(notice_message)
    end
  end
end
