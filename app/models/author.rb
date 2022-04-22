# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :author_books, dependent: :destroy
  has_many :books, through: :author_books

  validates :first_name, :last_name, :description,
            presence: true,
            length: { maximum: Constants::Author::STRING_MAX_SIZE }
end
