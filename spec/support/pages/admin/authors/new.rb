# frozen_string_literal: true

require_relative './author_form'

module Pages
  module Admin
    module Authors
      class New < SitePrism::Page
        set_url '/admin/authors/new'

        element :flash_notice, '.flash_notice'

        section :author_form, Pages::Admin::Authors::AuthorForm, 'form#new_author'
      end
    end
  end
end
