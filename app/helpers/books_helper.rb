# frozen_string_literal: true

module BooksHelper
  def all_books_count
    Book.count
  end
end
