# frozen_string_literal: true

module Pages
  module Admin
    module Books
      class View < SitePrism::Page
        set_url '/admin/books/{id}/edit'

        element :flash_notice, '.flash_notice'
        element :flash_error, '.flash_error'
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
          title_field.set(params[:title])
          category_select.select(Category.find_by_id(params[:category_id]).title)
          description_field.set(params[:description])
          year_publication_field.set(params[:year_publication])
          height_field.set(params[:height])
          width_field.set(params[:width])
          depth_field.set(params[:depth])
          price_field.set(params[:price])
          quantity_field.set(params[:quantity])
          submit_button.click
        end
      end
    end
  end
end
