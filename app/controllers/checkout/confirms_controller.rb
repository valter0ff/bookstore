# frozen_string_literal: true

module Checkout
  class ConfirmsController < BaseCheckoutController
    def show
      @cart_items = @order.cart_items.includes(book: :pictures)
    end

    def create
      if @order.confrim?
        @order.update(associations_to_json)
        @order.to_complete!
      else
        render :new, alert: 'Not pass some steps'
      end
    end
  end
end
