# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :category, counter_cache: true
  has_many :author_books, dependent: :destroy
  has_many :authors, through: :author_books
  has_many :book_materials, dependent: :destroy
  has_many :materials, through: :book_materials
  
  validates_presence_of :title
end
