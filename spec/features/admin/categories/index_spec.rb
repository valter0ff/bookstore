# frozen_string_literal: true

RSpec.describe 'Categories->Index', type: :feature do
  let(:index_categories_page) { Pages::Admin::Categories::Index.new }
  let(:admin) { create(:admin_user) }
  let(:categories_count) { rand(2..20) }

  before do
    create_list(:category, categories_count)
    sign_in(admin)
    index_categories_page.load
  end

  context 'with page elemens' do
    it 'all elements present' do
      expect(index_categories_page).to have_batch_menu_button
      expect(index_categories_page).to have_batch_action_destroy_button(text: 'Delete Selected')
      expect(index_categories_page).to have_new_category_button
    end
  end

  context 'with categories table' do
    let(:categories_table) { index_categories_page.categories_table }

    it 'all elements present' do
      expect(categories_table).to have_select_column
      expect(categories_table).to have_select_all_checkbox
      expect(categories_table).to have_title_column
      expect(categories_table).to have_view_category_buttons
      expect(categories_table).to have_edit_category_buttons
      expect(categories_table).to have_delete_category_buttons
    end
  end

  context 'when use batch destroy function', js: true, bullet: :skip do
    let(:notice_message) { /Successfully deleted .+ categories/ }

    it 'deletes categories from database' do
      expect { index_categories_page.batch_delete_categories }.to change(Category, :count).from(categories_count).to(0)
    end

    it 'shows apropriate flash message' do
      index_categories_page.batch_delete_categories
      expect(index_categories_page).to have_flash_notice
      expect(index_categories_page.flash_notice.text).to match(notice_message)
    end
  end

  context 'when delete one category from table', js: true do
    let(:notice_message) { I18n.t('flash.actions.destroy.notice', resource_name: Category.to_s) }

    it 'deletes one category from database' do
      expect { index_categories_page.delete_category }.to change(Category, :count).by(-1)
    end

    it 'shows apropriate flash message' do
      index_categories_page.delete_category
      index_categories_page.wait_until_flash_notice_visible
      expect(index_categories_page).to have_flash_notice
      expect(index_categories_page.flash_notice.text).to match(notice_message)
    end
  end
end
