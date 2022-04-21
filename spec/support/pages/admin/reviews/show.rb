# frozen_string_literal: true

module Pages
  module Admin
    module Reviews
      class Show < SitePrism::Page
        set_url '/admin/reviews/{id}'

        element :flash_notice, '.flash_notice'

        section :review_info, '.attributes_table.review' do
          element :review_title, '.row-title>td'
          element :body, '.row-body>td'
          element :rating, '.row-rating>td'
          element :book, '.row-book>td'
          element :user_account, '.row-user_account>td'
          element :status, '.row-status>td'
          element :created_at, '.row-created_at>td'
          element :updated_at, '.row-updated_at>td'
        end

        section :action_buttons, '.action_items' do
          element :approve_button, '.action_item>a', text: I18n.t('reviews.admin.approve')
          element :reject_button, '.action_item>a', text: I18n.t('reviews.admin.reject')
          element :delete_button, '.action_item>a', text: 'Delete Review'
        end

        def delete_review
          accept_confirm do
            action_buttons.delete_button.click
          end
        end
      end
    end
  end
end
