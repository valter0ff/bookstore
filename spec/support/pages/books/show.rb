# frozen_string_literal: true

module Pages
  module Books
    class Show < SitePrism::Page
      set_url '/books{/id}'

      element :back_button, '.general-back-link'

      section :product_gallery, '.product-gallery' do
        element :main_image, 'img.main-image'
        elements :preview_images, '.img-link.preview'
      end

      section :book_info, '.book-info' do
        element :book_title, '.book-title'
        element :authors, '.book-authors'
        element :price, '.price.in-gold-500'
        element :description, '.description'
        element :year_publication, '.year_publication'
        element :dimensions, '.dimensions'
        element :materials, '.materials'
        element :cart_button, '.cart-btn'
        element :plus_button, '.fa.fa-plus'
        element :minus_button, '.fa.fa-minus'
        element :quantity_input, '.quantity-input'
        element :read_more, '.read-more'
      end
    end
  end
end
