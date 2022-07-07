# frozen_string_literal: true

module Pages
  module Sections
    class CartItemsTable < SitePrism::Section
      section :table_headers, '.cart-items-table-headers' do
        element :book_label, '.book-label'
        element :price_label, '.price-label'
        element :quantity_label, '.quantity-label'
        element :subtotal_label, '.sub-total-label'
      end

      sections :cart_items, '.general-cart-item' do
        element :book_image, '.cart-img-shadow.pull-left'
        element :book_title, 'p.title'
        element :book_description, '.description'
        element :book_price, '.in-gold-500.price'
        element :book_quantity, 'span.quantity'
        element :subtotal_price, '.in-gold-500.subtotal'
      end
    end
  end
end
