# frozen_string_literal: true

module CartItems
  class SetCartItemService < ApplicationService
    def initialize(order, params)
      @order = order
      @params = params
    end

    def call
      find_cart_item
      set_cart_item
      cart_item
    end

    private

    attr_reader :cart_item, :params, :order

    def find_cart_item
      @cart_item = order.cart_items.find_by(book_id: params[:book_id]) || CartItem.find_by(id: params[:id])
    end

    def set_cart_item
      create_cart_item unless cart_item.present?
    end

    def create_cart_item
      @cart_item = order.cart_items.build(book_id: params[:book_id])
    end
  end
end
