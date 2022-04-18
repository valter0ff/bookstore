# frozen_string_literal: true

module Pages
  module Admin
    module Categories
      class Show < SitePrism::Page
        set_url '/admin/categories/{id}'

        element :flash_notice, '.flash_notice'

        section :category_info, '.attributes_table.category' do
          element :category_title, '.row-title>td'
          element :created_at, '.row-created_at>td'
          element :updated_at, '.row-updated_at>td'
        end

        section :action_buttons, '.action_items' do
          element :edit_button, '.action_item>a', text: 'Edit Category'
          element :delete_button, '.action_item>a', text: 'Delete Category'
        end

        def delete_category
          accept_confirm do
            action_buttons.delete_button.click
          end
        end
      end
    end
  end
end
