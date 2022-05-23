# frozen_string_literal: true

class CartItemDecorator < ApplicationDecorator
  delegate_all
  decorates_association :book

  def subtotal_price
    books_count * book.price
  end
end
