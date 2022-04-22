# frozen_string_literal: true

module Pages
  module Admin
    module Authors
      class Show < SitePrism::Page
        set_url '/admin/authors/{id}'

        element :flash_notice, '.flash_notice'

        section :author_info, '.attributes_table.author' do
          element :author_first_name, '.row-first_name>td'
          element :author_last_name, '.row-last_name>td'
          element :description, '.row-description>td'
          element :created_at, '.row-created_at>td'
          element :updated_at, '.row-updated_at>td'
        end

        section :action_buttons, '.action_items' do
          element :edit_button, '.action_item>a', text: 'Edit Author'
          element :delete_button, '.action_item>a', text: 'Delete Author'
        end

        def delete_author
          accept_confirm do
            action_buttons.delete_button.click
          end
        end
      end
    end
  end
end
