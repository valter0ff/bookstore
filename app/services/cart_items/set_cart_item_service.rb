# frozen_string_literal: true

module CartItems
  class SetCartItemService < ApplicationService
    def initialize(order, params)
      @order = order
      @params = params
    end

    def call
      set_cart_item_by_id || set_cart_item_by_book_id
      cart_item
    end

    private

    attr_reader :cart_item, :params, :order

    def set_cart_item_by_id
      @cart_item = order.cart_items.find_by(id: params[:id])
    end

    def set_cart_item_by_book_id
      @cart_item = order.cart_items.find_or_initialize_by(book_id: params[:book_id])
    end
  end
end
