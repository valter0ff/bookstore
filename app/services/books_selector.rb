# frozen_string_literal: true

class BooksSelector < ApplicationService
  SORTING = {
    'newest_first' => 'created_at DESC',
    'popular_first' => '',
    'price_low_to_high' => 'price ASC',
    'price_high_to_low' => 'price DESC',
    'title_a_z' => 'title ASC',
    'title_z_a' => 'title DESC'
  }.freeze
    
  def initialize(category, controller_context)
    @category = category
    super(controller_context)
  end

  def call
    setup_books
    sort_books
  end

  private

  def setup_books
    books = @category.blank? ? Book.all : @category.books
    @books = books.includes(:authors)
  end
  
  def sort_books
    return unless SORTING.key?(params[:sorted_by])
    return popular_books if params[:sorted_by] == 'popular_first'

    @books = @books.order(SORTING[params[:sorted_by]])
  end

  def average_book_rating(book)
    rev = book.reviews.pluck(:rating)
    rev.sum(0.0) / rev.size
  end

  def popular_books
    @books.sort_by { |book| average_book_rating(book) }.reverse
  end
end
