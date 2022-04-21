# frozen_string_literal: true

require_relative './author_form'

module Pages
  module Admin
    module Authors
      class New < SitePrism::Page
        set_url '/admin/authors/new'

        element :flash_notice, '.flash_notice'

        section :author_form, Pages::Admin::Authors::AuthorForm, 'form#new_author'

        def create_author(form, params)
          form.first_name_field.set(params[:first_name])
          form.last_name_field.set(params[:last_name])
          form.description_field.set(params[:description])
          form.submit_button.click
        end
      end
    end
  end
end
