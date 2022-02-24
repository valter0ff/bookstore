# frozen_string_literal: true

class BooksSelector < ApplicationService
  def initialize(category, controller_context)
    @category = category
    super(controller_context)
  end

  def call
    setup_books
#     sort_books
    @books
  end

  private

  def setup_books
    @books = if @category.blank?
              Book.all  # Book.includes(:authors, :reviews).all
             else
               @category.books
             end
  end

#   def sort_books
#     @books = SortingSelector.call(@books, __getobj__)
#   end
end
