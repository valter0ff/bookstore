# frozen_string_literal: true

module Checkout
  class BaseCheckoutController < ClientController
    before_action :authenticate_on_checkout
    before_action :check_current_step
    before_action :decorate_order

    private

    def authenticate_on_checkout
      redirect_to new_checkout_session_path unless user_signed_in?
    end

    def decorate_order
      @order = Order.includes(cart_items: :book).find_by(id: @order.id).decorate
    end

    def check_current_step
      requested_step = request.controller_class.to_s.demodulize.downcase.sub('controller', '').singularize
      return if requested_step.to_sym == :complete

      order_steps = Order.steps
      if order_steps[@order.step] < order_steps[requested_step]
        routes = Rails.application.routes.url_helpers
        link = routes.public_send("edit_checkout_#{@order.step}_path")
        redirect_to link
      end
    end
  end
end
