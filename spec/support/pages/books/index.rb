# frozen_string_literal: true

module Pages
  module Books
    class Index < SitePrism::Page
      set_url '/books{?query*}'

      element :page_title, 'h1.general-title-margin'
      element :category_dropdown, 'form.category-dropdown'
      element :all_books_link, 'a.filter-link', text: I18n.t('books.index.all_books')
      element :next_page_button, '#div_next_link'
      elements :sorting_dropdowns, 'form.sorting-dropdown'
      elements :category_filters, '.filter-link.custom-filter'
      elements :sorting_options, 'select#sorted_by option'

      sections :books, '.book_card' do
        element :show_link, '.show-link'
        element :buy_link, '.buy-link'
        element :book_title, '.general-thumb-info .title'
        element :price, '.general-thumb-info .price'
        element :authors, '.general-thumb-info .authors'
      end

      def filter_books_by_category
        category_filters.first.click
      end

      def change_books_order
        sorting_options.first.select_option
      end
    end
  end
end
