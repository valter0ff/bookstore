# frozen_string_literal: true

module Checkout
  class ConfirmsController < BaseCheckoutController
    before_action :set_cart_items

    def show; end

    def update
      if @order.may_complete_step?
        Orders::ConfirmOrderService.call(current_user, @order.model)
        redirect_to checkout_complete_path(id: @order.id)
      else
        flash.now[:alert] = I18n.t('checkout.confirms.show.confirm_error')
        render :show
      end
    end

    private

    def set_cart_items
      @cart_items = @order.cart_items.includes(book: :pictures)
    end
  end
end
