# frozen_string_literal: true

class OrderDecorator < ApplicationDecorator
  delegate_all
  decorates_association :cart_items
  decorates_association :credit_card

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
    price_with_currency(shipping_method_price)
  end

  def total_with_shipping
    price_with_currency(total_with_shipping_value)
  end

  def complete_date
    completed_at.strftime('%B %d, %Y')
  end

  def from_json_shipping_address
    Address.new.from_json(shipping_address)
  end

  def from_json_billing_address
    Address.new.from_json(billing_address)
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
    total = subtotal_value + shipping_method_price
    return 0 if total <= discount_value.to_i

    total - discount_value.to_i
  end

  def shipping_method_price
    try(:shipping_price) || shipping_method.try(:price) || 0
  end
end
