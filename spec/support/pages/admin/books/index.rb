# frozen_string_literal: true

module Pages
  module Admin
    module Books
      class Index < SitePrism::Page
        set_url '/admin/books'

        element :flash_notice, '.flash_notice'
        element :flash_error, '.flash_error'

        section :books_table, 'table.index_table' do
          element :select_column, 'th.col-selectable'
          element :select_all_checkbox, 'input.toggle_all'
          element :image_column, 'th.col-image'
          element :title_column, 'th.col-title'
          element :category_column, 'th.col-category'
          element :authors_column, 'th.col-authors'
          element :description_column, 'th.col-short_description'
          element :price_column, 'th.col-price'
          element :actions_column, 'th.col-actions'
          elements :view_book_buttons, 'a.view_link.member_link'
          elements :edit_book_buttons, 'a.edit_link.member_link'
          elements :delete_book_buttons, 'a.delete_link.member_link'
        end

        element :popup_ui_dialog, 'div.ui-dialog'
        element :popup_ui_dialog_ok_button, '.ui-button', text: 'OK'
        element :batch_menu_button, 'a.dropdown_menu_button'
        element :batch_action_destroy_button, 'a[data-action="destroy"]'
        element :new_book_button, 'a[href="/admin/books/new"]'

        def batch_delete_books
          books_table.select_all_checkbox.check
          wait_until_batch_menu_button_visible
          batch_menu_button.click
          wait_until_batch_action_destroy_button_visible
          batch_action_destroy_button.click
          wait_until_popup_ui_dialog_visible
          popup_ui_dialog_ok_button.click
        end

        def delete_book
          accept_confirm do
            books_table.delete_book_buttons.first.click
          end
        end
      end
    end
  end
end
