# frozen_string_literal: true

module Checkout
  class CompletesController < ClientController
    prepend_before_action :authenticate_user!

    def show
      if @order.complete?
        @cart_items = @order.cart_items.includes(book: :pictures)
      else
        redirect_back(fallback_location: root_path, alert: I18n.t('checkout.errors.not_authorized'))
      end
    end

    private

    def set_order
      @order = current_user.orders.find(params[:id]).decorate
    end
  end
end
