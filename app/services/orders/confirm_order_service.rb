# frozen_string_literal: true

module Orders
  class ConfirmOrderService < ApplicationService
    def initialize(user, order)
      @current_user = user
      @order = order
    end

    def call
      @order.update(step: :complete, state: :in_progress, **detailed_order_information)
    end

    private

    attr_reader :current_user, :order

    def detailed_order_information
      { billing_address: current_user.billing_address.as_json,
        shipping_address: order.select_shipping_address.as_json,
        all_cart_items: json_cart_items,
        summary_price: order.total_with_shipping,
        completed_at: DateTime.now.in_time_zone,
        number: order_number }
    end

    def json_cart_items
      order.cart_items.as_json(only: :books_count,
                               include: { book: { include: { pictures: { only: :image_data } },
                                                  only: %i[title description price] } })
    end

    def order_number
      number_prefix = Constants::Order::NUMBER_PREFIX
      number_format = "%0#{Constants::Order::NUMBER_SIZE}d"
      number_prefix + format(number_format, order.id)
    end
  end
end
