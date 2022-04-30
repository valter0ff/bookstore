# frozen_string_literal: true

RSpec.describe 'Categories->Show', type: :feature do
  let(:show_category_page) { Pages::Admin::Categories::Show.new }
  let(:admin) { create(:admin_user) }
  let(:category) { create(:category) }

  before do
    sign_in(admin)
    show_category_page.load(id: category.id)
  end

  context 'when shows category info section' do
    let(:category_info) { show_category_page.category_info }

    it 'all fields present with appropriate values' do
      expect(category_info).to have_category_title(text: category.title)
      expect(category_info).to have_created_at(text: I18n.l(category.created_at, format: :admin))
      expect(category_info).to have_updated_at(text: I18n.l(category.updated_at, format: :admin))
    end
  end

  context 'when shows action buttons section' do
    let(:buttons_section) { show_category_page.action_buttons }

    it 'all buttons present' do
      expect(buttons_section).to have_edit_button
      expect(buttons_section).to have_delete_button
    end
  end

  context 'when edit button clicked' do
    before { show_category_page.action_buttons.edit_button.click }

    it 'redirects to edit category path' do
      expect(page).to have_current_path(edit_admin_category_path(category))
    end
  end

  context 'when delete button clicked', js: true do
    let(:notice_message) { I18n.t('flash.actions.destroy.notice', resource_name: Category.to_s) }

    it 'deletes category from database' do
      expect { show_category_page.delete_category }.to change(Category, :count).by(-1)
    end

    it 'redirects to categorys index page' do
      show_category_page.delete_category
      expect(page).to have_current_path(admin_categories_path)
    end

    it 'shows apropriate flash message' do
      show_category_page.delete_category
      expect(show_category_page).to have_flash_notice
      expect(show_category_page.flash_notice.text).to match(notice_message)
    end
  end
end
