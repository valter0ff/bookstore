# frozen_string_literal: true

class Material < ApplicationRecord
  has_many :book_materials, dependent: :destroy
  has_many :books, through: :book_materials
end
