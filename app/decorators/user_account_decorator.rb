# frozen_string_literal: true

class UserAccountDecorator < ApplicationDecorator
  delegate_all

  def full_name
    "#{billing_address&.first_name} #{billing_address&.last_name}" ||
      "#{shipping_address&.first_name} #{shipping_address&.last_name}"
  end
end
