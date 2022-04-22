# frozen_string_literal: true

require_relative './category_form'

module Pages
  module Admin
    module Categories
      class Edit < SitePrism::Page
        set_url '/admin/categories/{id}/edit'

        element :flash_notice, '.flash_notice'

        section :category_form, Pages::Admin::Categories::CategoryForm, 'form#edit_category'
      end
    end
  end
end
