# frozen_string_literal: true

class OrderDecorator < ApplicationDecorator
  delegate_all
  decorates_association :cart_items

  def subtotal_price
    cart_items.map(&:subtotal_price).sum
  end

  def discount
    coupon.try(:discount)
  end

  def total_price
    subtotal_price - discount
  end
end
