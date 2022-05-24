# frozen_string_literal: true

class OrderDecorator < ApplicationDecorator
  delegate_all
  decorates_association :cart_items

  def subtotal_value
    cart_items.map(&:subtotal_value).sum
  end

  def discount_value
    coupon.try(:discount)
  end

  def subtotal_price
    price_with_currency(subtotal_value)
  end

  def discount
    price_with_currency(discount_value)
  end

  def total_price
    price_with_currency(subtotal_value - discount_value.to_i)
  end
end
