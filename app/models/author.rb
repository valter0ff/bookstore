# frozen_string_literal: true

class Author < ApplicationRecord
  has_many :author_books, dependent: :destroy
  has_many :books, through: :author_books

  validates :first_name, :last_name, presence: true
end
