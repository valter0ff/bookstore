# frozen_string_literal: true

class BooksSelectorService < ApplicationService
  SORTING = {
    'newest_first' => 'created_at DESC',
    'price_low_to_high' => 'price ASC',
    'price_high_to_low' => 'price DESC',
    'title_a_z' => 'title ASC',
    'title_z_a' => 'title DESC'
  }.freeze
  POPULAR_FIRST_ORDER = 'popular_first'

  def initialize(category, sorting_param)
    @category = category
    @sorting_param = sorting_param
  end

  def call
    filter_books
    sort_books
  end

  private

  def filter_books
    books = @category.blank? ? Book.all : @category.books
    @books = books.includes(:authors)
  end

  def sort_books
    return popular_books if @sorting_param == POPULAR_FIRST_ORDER

    SORTING.key?(@sorting_param) ? @books.order(SORTING[@sorting_param]) : @books
  end

  def popular_books
    @books.sort_by { |book| book.reviews.average(:rating) }.reverse
  end
end
