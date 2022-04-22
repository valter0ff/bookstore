# frozen_string_literal: true

module Pages
  module Admin
    module Authors
      class AuthorForm < SitePrism::Section
        element :first_name_error, '#author_first_name_input p.inline-errors'
        element :last_name_error, '#author_last_name_input p.inline-errors'
        element :description_error, '#author_description_input p.inline-errors'

        element :first_name_label, 'li#author_first_name_input>label'
        element :last_name_label, 'li#author_last_name_input>label'
        element :description_label, 'li#author_description_input>label'

        element :first_name_field, '#author_first_name'
        element :last_name_field, '#author_last_name'
        element :description_field, '#author_description'

        element :submit_button, '#author_submit_action>input'
        element :cancel_button, '.actions li.cancel>a'

        def fill_and_submit_form(params)
          first_name_field.set(params[:first_name])
          last_name_field.set(params[:last_name])
          description_field.set(params[:description])
          submit_button.click
        end
      end
    end
  end
end
