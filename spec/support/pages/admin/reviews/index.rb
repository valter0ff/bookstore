# frozen_string_literal: true

module Pages
  module Admin
    module Reviews
      class Index < SitePrism::Page
        set_url '/admin/reviews'

        element :flash_notice, '.flash_notice'

        section :reviews_table, 'table.index_table' do
          element :select_column, 'th.col-selectable'
          element :select_all_checkbox, 'input.toggle_all'
          element :book_column, 'th.col-book'
          element :title_column, 'th.col-title'
          element :date_column, 'th.col-date'
          element :user_account_column, 'th.col-user_account'
          element :status_column, 'th.col-status'
          element :actions_column, 'th.col-actions'
          elements :view_review_buttons, 'a.view_link.member_link'
          elements :delete_review_buttons, 'a.delete_link.member_link'
        end

        element :popup_ui_dialog, 'div.ui-dialog'
        element :popup_ui_dialog_ok_button, '.ui-button', text: 'OK'
        element :batch_menu_button, 'a.dropdown_menu_button'
        element :batch_action_destroy_button, 'a[data-action="destroy"]'

        def batch_delete_reviews
          reviews_table.select_all_checkbox.check
          wait_until_batch_menu_button_visible
          batch_menu_button.click
          wait_until_batch_action_destroy_button_visible
          batch_action_destroy_button.click
          wait_until_popup_ui_dialog_visible
          popup_ui_dialog_ok_button.click
        end

        def delete_review
          accept_confirm do
            reviews_table.delete_review_buttons.first.click
          end
        end
      end
    end
  end
end
