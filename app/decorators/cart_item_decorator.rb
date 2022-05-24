# frozen_string_literal: true

class CartItemDecorator < ApplicationDecorator
  delegate_all
  decorates_association :book

  def subtotal_value
    books_count * book.price
  end

  def subtotal_price
    price_with_currency(subtotal_value)
  end

  def book_id_with_count
    "book_id: #{book_id} - count: #{books_count}"
  end
end
