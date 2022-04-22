# frozen_string_literal: true

module Pages
  module Admin
    module Authors
      class Index < SitePrism::Page
        set_url '/admin/authors'

        element :flash_notice, '.flash_notice'

        section :authors_table, 'table.index_table' do
          element :select_column, 'th.col-selectable'
          element :select_all_checkbox, 'input.toggle_all'
          element :first_name_column, 'th.col-first_name'
          element :last_name_column, 'th.col-last_name'
          element :description_column, 'th.col-description'
          elements :view_author_buttons, 'a.view_link.member_link'
          elements :edit_author_buttons, 'a.edit_link.member_link'
          elements :delete_author_buttons, 'a.delete_link.member_link'
        end

        element :popup_ui_dialog, 'div.ui-dialog'
        element :popup_ui_dialog_ok_button, '.ui-button', text: 'OK'
        element :batch_menu_button, 'a.dropdown_menu_button'
        element :batch_action_destroy_button, 'a[data-action="destroy"]'
        element :new_author_button, 'a[href="/admin/authors/new"]'

        def batch_delete_authors
          authors_table.select_all_checkbox.check
          wait_until_batch_menu_button_visible
          batch_menu_button.click
          wait_until_batch_action_destroy_button_visible
          batch_action_destroy_button.click
          wait_until_popup_ui_dialog_visible
          popup_ui_dialog_ok_button.click
        end

        def delete_author
          accept_confirm do
            authors_table.delete_author_buttons.first.click
          end
        end
      end
    end
  end
end
