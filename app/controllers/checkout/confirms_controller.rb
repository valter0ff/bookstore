# frozen_string_literal: true

module Checkout
  class ConfirmsController < BaseCheckoutController
    before_action :set_cart_items

    def show; end

    def update
      if @order.may_to_complete_step?
        @order.update(associations_to_json)
        @order.to_complete_step!
        @order.in_progress!
      else
        render :show, alert: I18n.t('checkout.confirms.show.confirm_error')
      end
    end

    private

    def set_cart_items
      @cart_items = @order.cart_items.includes(book: :pictures)
    end

    def associations_to_json
      { billing_address: current_user.billing_address.as_json,
        shipping_address: @order.select_shipping_address.as_json,
        all_cart_items: json_cart_items,
        total_price: @order.total_with_shipping }
    end

    def json_cart_items
      @order.cart_items.as_json(only: :books_count,
                                include: { book: { include: { pictures: { only: :image_data } },
                                           only: %i[title description price] } })
    end
  end
end
