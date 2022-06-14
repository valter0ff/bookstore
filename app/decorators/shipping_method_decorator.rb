# frozen_string_literal: true

class ShippingMethodDecorator < ApplicationDecorator
  delegate_all

  def price_with_currency
    super(price)
  end
end
