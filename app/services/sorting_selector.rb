# frozen_string_literal: true

class SortingSelector < ApplicationService
  SORTING = {
    'newest_first' => 'created_at DESC',
    'popular_first' => '',
    'price_low_to_high' => 'price ASC',
    'price_high_to_low' => 'price DESC',
    'title_a_z' => 'title ASC',
    'title_z_a' => 'title DESC'
  }.freeze

  def initialize(books, controller_context)
    @books = books
    super(controller_context)
  end

  def call
    initialize_sort_filter
    handle_sorting
    @books
  end

  private

  def initialize_sort_filter
    session[:sorted_by] = params[:sorted_by] if params[:sorted_by]
  end

  def handle_sorting
    return unless SORTING.key?(session[:sorted_by])
    return @books = popular_books if session[:sorted_by] == 'popular_first'

    @books = @books.includes(:authors).order(SORTING[session[:sorted_by]])
  end

  #   def average_book_rating(book)
  #     rev = book.reviews.pluck(:rating)
  #     rev.sum(0.0) / rev.size
  #   end

  def popular_books
    #     @books.sort_by { |book| average_book_rating(book) }.reverse
    @books
  end
end
