# frozen_string_literal: true

module Checkout
  class CompletesController < BaseCheckoutController
    prepend_before_action :set_completed_order

    def show
      set_cart_items
#       @completed_order = current_user.orders.where(step: :complete)
    end

    private

    def set_completed_order
      @order = Order.find_by(id: params[:id]) || current_user.orders.complete.last
    end

    def set_cart_items
      @cart_items = @order.cart_items.includes(book: :pictures)
    end
  end
end
