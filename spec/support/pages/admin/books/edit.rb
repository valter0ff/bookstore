# frozen_string_literal: true

module Pages
  module Admin
    module Books
      class Edit < SitePrism::Page
        set_url '/admin/books/{id}/edit'

        element :flash_notice, '.flash_notice'
        element :title_error, '#book_title_input p.inline-errors'

        element :category_label, 'li#book_category_input>label'
        element :authors_label, 'li#book_authors_input>label'
        element :materials_label, 'li#book_materials_input label'
        element :title_label, 'li#book_title_input>label'
        element :description_label, 'li#book_description_input>label'
        element :year_publication_label, 'li#book_year_publication_input>label'
        element :height_label, 'li#book_height_input>label'
        element :width_label, 'li#book_width_input>label'
        element :depth_label, 'li#book_depth_input>label'
        element :price_label, 'li#book_price_input>label'
        element :quantity_label, 'li#book_quantity_input>label'
        element :submit_button, '#book_submit_action>input'
        element :cancel_button, '.actions li.cancel>a'

        element :category_field, 'select#book_category_id option[selected="selected"]'
        element :title_field, '#book_title'
        element :description_field, '#book_description'
        element :year_publication_field, '#book_year_publication'
        element :height_field, '#book_height'
        element :width_field, '#book_width'
        element :depth_field, '#book_depth'
        element :price_field, '#book_price'
        element :quantity_field, '#book_quantity'
        element :category_select, 'select#book_category_id'

        def fill_and_submit_form(params)
          category_select.select(Category.find_by(id: params.delete(:category_id)).title)
          params.each { |param, value| public_send("#{param}_field").set(value) }
          submit_button.click
        end
      end
    end
  end
end
