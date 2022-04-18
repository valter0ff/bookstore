# frozen_string_literal: true

module Pages
  module Admin
    module Books
      class Show < SitePrism::Page
        set_url '/admin/books/{id}'

        element :flash_notice, '.flash_notice'

        section :book_info, '.attributes_table.book' do
          element :book_title, '.row-title>td'
          element :description, '.row-description>td'
          element :year_publication, '.row-year_publication>td'
          element :height, '.row-height>td'
          element :width, '.row-width>td'
          element :depth, '.row-depth>td'
          element :price, '.row-price>td'
          element :quantity, '.row-quantity>td'
          element :category, '.row-category>td'
          element :created_at, '.row-created_at>td'
          element :updated_at, '.row-updated_at>td'
          element :materials, '.row-materials>td'
          element :authors, '.row-authors>td'
        end

        section :action_buttons, '.action_items' do
          element :edit_button, '.action_item>a', text: 'Edit Book'
          element :delete_button, '.action_item>a', text: 'Delete Book'
        end

        def delete_book
          accept_confirm do
            action_buttons.delete_button.click
          end
        end
      end
    end
  end
end
