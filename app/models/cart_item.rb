# frozen_string_literal: true

class CartItem < ApplicationRecord
  belongs_to :order
  belongs_to :book

  validates :books_count, presence: true, numericality: { greater_than: 0 }
end
