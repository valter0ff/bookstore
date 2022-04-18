# frozen_string_literal: true

module Pages
  module Admin
    module Categories
      class Edit < SitePrism::Page
        set_url '/admin/categories/{id}/edit'

        element :flash_notice, '.flash_notice'
        element :title_error, '#category_title_input p.inline-errors'

        element :title_label, 'li#category_title_input>label'
        element :submit_button, '#category_submit_action>input'
        element :cancel_button, '.actions li.cancel>a'
        element :title_field, '#category_title'

        def fill_and_submit_form(params)
          title_field.set(params[:title])
          submit_button.click
        end
      end
    end
  end
end
