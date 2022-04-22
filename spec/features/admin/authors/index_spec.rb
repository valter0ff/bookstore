# frozen_string_literal: true

RSpec.describe 'Authors->Index', type: :feature do
  let(:index_authors_page) { Pages::Admin::Authors::Index.new }
  let(:admin) { create(:admin_user) }
  let(:authors_count) { rand(2..20) }

  before do
    create_list(:author, authors_count)
    sign_in(admin)
    index_authors_page.load
  end

  context 'with page elemens' do
    it 'all elements present' do
      expect(index_authors_page).to have_batch_menu_button
      expect(index_authors_page).to have_batch_action_destroy_button(text: 'Delete Selected')
      expect(index_authors_page).to have_new_author_button
    end
  end

  context 'with authors table' do
    let(:authors_table) { index_authors_page.authors_table }

    it 'all elements present' do
      expect(authors_table).to have_select_column
      expect(authors_table).to have_select_all_checkbox
      expect(authors_table).to have_first_name_column
      expect(authors_table).to have_last_name_column
      expect(authors_table).to have_description_column
      expect(authors_table).to have_view_author_buttons
      expect(authors_table).to have_edit_author_buttons
      expect(authors_table).to have_delete_author_buttons
    end
  end

  context 'when use batch destroy function', js: true do
    let(:notice_message) do
      I18n.t('active_admin.batch_actions.succesfully_destroyed',
             count: authors_count,
             plural_model: Author.to_s.pluralize.titleize.downcase)
    end

    it 'deletes authors from database' do
      expect { index_authors_page.batch_delete_authors }.to change(Author, :count).from(authors_count).to(0)
    end

    it 'shows apropriate flash message' do
      index_authors_page.batch_delete_authors
      expect(index_authors_page).to have_flash_notice
      expect(index_authors_page.flash_notice.text).to match(notice_message)
    end
  end

  context 'when delete one author from table', js: true do
    let(:notice_message) { I18n.t('flash.actions.destroy.notice', resource_name: Author.to_s) }

    it 'deletes one author from database' do
      expect { index_authors_page.delete_author }.to change(Author, :count).by(-1)
    end

    it 'shows apropriate flash message' do
      index_authors_page.delete_author
      index_authors_page.wait_until_flash_notice_visible
      expect(index_authors_page).to have_flash_notice
      expect(index_authors_page.flash_notice.text).to match(notice_message)
    end
  end
end
