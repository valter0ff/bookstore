# frozen_string_literal: true

module Checkout
  class CompletesController < ClientController
    before_action :authenticate_user!
    skip_before_action :set_order

    def show
      @order = current_user.orders.find(params[:id]).decorate
      @cart_items = @order.cart_items.includes(book: :pictures)
    end
  end
end
