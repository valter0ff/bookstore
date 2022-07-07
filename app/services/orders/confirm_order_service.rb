# frozen_string_literal: true

module Orders
  class ConfirmOrderService < ApplicationService
    def initialize(user, order)
      @current_user = user
      @order = order
    end

    def call
      save_book_prices_and_sales_count
      use_coupon
      order.update(step: :complete, state: :in_progress, **detailed_order_information)
    end

    private

    attr_reader :current_user, :order

    def save_book_prices_and_sales_count
      @order.cart_items.find_each do |cart_item|
        cart_item.update(book_price: cart_item.book.price)
        book = cart_item.book
        book.update(sales_count: book.sales_count += cart_item.books_count)
      end
    end

    def use_coupon
      return if order.coupon.blank?

      order.coupon.used!
    end

    def detailed_order_information
      { billing_address: current_user.billing_address.to_json,
        shipping_address: order.select_shipping_address.to_json,
        shipping_price: order.shipping_method.price,
        completed_at: DateTime.now.in_time_zone,
        number: order_number }
    end

    def order_number
      number_prefix = Constants::Order::NUMBER_PREFIX
      number_format = "%0#{Constants::Order::NUMBER_SIZE}d"
      number_prefix + format(number_format, order.id)
    end
  end
end
