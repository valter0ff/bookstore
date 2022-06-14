# frozen_string_literal: true

class OrderDecorator < ApplicationDecorator
  delegate_all
  decorates_association :cart_items

  def subtotal_price
    price_with_currency(subtotal_value)
  end

  def discount
    price_with_currency(discount_value)
  end

  def total_price
    price_with_currency(total_value)
  end

  def shipping_amount
    price_with_currency(shipping_method.price || 0)
  end

  def total_with_shipping
    price_with_currency(total_with_shipping_value)
  end

  private

  def subtotal_value
    cart_items.sum(&:subtotal_value)
  end

  def discount_value
    coupon.try(:discount) || 0
  end

  def total_value
    return 0 if subtotal_value <= discount_value.to_i

    subtotal_value - discount_value.to_i
  end

  def total_with_shipping_value
    total = subtotal_value + shipping_method.price
    return 0 if total <= discount_value.to_i

    total - discount_value.to_i
  end
end
