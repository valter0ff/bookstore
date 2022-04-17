# frozen_string_literal: true

module ActiveAdmin
  module BooksHelper
    def clickable_authors(book)
      book.authors.map { |author| auto_link(author, "#{author.first_name} #{author.last_name}") }
    end
  end
end
