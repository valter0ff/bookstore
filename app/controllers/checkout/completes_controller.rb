# frozen_string_literal: true

module Checkout
  class CompletesController < BaseCheckoutController
    def show
      @completed_order = current_user.orders.where(step: :complete)
    end
  end
end
