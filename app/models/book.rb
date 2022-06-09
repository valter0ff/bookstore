# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :category, counter_cache: true
  has_many :author_books, dependent: :destroy
  has_many :authors, through: :author_books
  has_many :book_materials, dependent: :destroy
  has_many :materials, through: :book_materials
  has_many :reviews, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :cart_items, dependent: :nullify

  validates :title, presence: true

  accepts_nested_attributes_for :pictures, allow_destroy: true
end
