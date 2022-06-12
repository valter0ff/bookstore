# frozen_string_literal: true

module Checkout
  class BaseCheckoutController < ClientController
    before_action :authenticate_on_checkout
    before_action :decorate_order

    private

    def authenticate_on_checkout
      redirect_to new_checkout_session_path unless user_signed_in?
    end

    def decorate_order
      @order = Order.includes(cart_items: :book).find_by(id: @order.id).decorate
    end
  end
end
