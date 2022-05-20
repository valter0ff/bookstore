# frozen_string_literal: true

module CartItems
  class SetCartItemService < ApplicationService

    def initialize(order, book, cart_item_params)
      @order = order
      @book = book
      @cart_item_params = cart_item_params
    end

    def call
      find_cart_item
      set_cart_item
    end

    private

    def find_cart_item
      @cart_item = @order.cart_items.find_by(book_id: @book.id)
    end

    def set_cart_item
      @cart_item.present? ? update_cart_item : create_cart_item
    end

    def update_cart_item
      @cart_item.books_count += @cart_item_params[:books_count].to_i
      @cart_item
    end

    def create_cart_item
      cart_item = @order.cart_items.build(@cart_item_params)
      cart_item.book = @book
      cart_item.order = @order
      cart_item
    end
  end
end

