# frozen_string_literal: true

module Orders
  class ConfirmOrderService < ApplicationService
    def initialize(user, order)
      @current_user = user
      @order = order
    end

    def call
      @order.update(params_with_json)
#       @order.complete_step!
#       @order.in_progress!
    end

    private

    attr_reader :current_user, :order

    def params_with_json
      { billing_address: current_user.billing_address.as_json,
        shipping_address: order.select_shipping_address.as_json,
        all_cart_items: json_cart_items,
        total_price: order.total_with_shipping,
        number: order_number,
        step: :complete,
        state: :in_progress}
    end

    def json_cart_items
      order.cart_items.as_json(only: :books_count,
                                include: { book: { include: { pictures: { only: :image_data } },
                                           only: %i[title description price] } })
    end

    def order_number
      Constants::Order::NUMBER_PREFIX + order.id.to_s.rjust(Constants::Order::NUMBER_SIZE, Constants::Order::NUMBER_FILLER)
    end
  end
end
