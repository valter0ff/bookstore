# frozen_string_literal: true

class UserAccountDecorator < ApplicationDecorator
  delegate_all

  def full_name
    address = billing_address || shipping_address
    return unless address

    "#{address.first_name} #{address.last_name}"
  end
end
