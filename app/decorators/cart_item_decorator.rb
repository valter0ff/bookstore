# frozen_string_literal: true

class CartItemDecorator < ApplicationDecorator
  delegate_all
  decorates_association :book

  def subtotal_value
    books_count * (book_price || book.price)
  end

  def subtotal_price
    price_with_currency(subtotal_value)
  end

  def book_id_with_count
    "book_id: #{book_id} - count: #{books_count}"
  end

  def book_price_with_currency
    book_price ? price_with_currency(book_price) : book.price_with_currency
  end
end
