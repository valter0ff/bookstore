# frozen_string_literal: true

class BooksController < ApplicationController
  ITEMS_PER_PAGE = 12

  before_action :set_all_categories, only: :index
  before_action :set_category, only: :index

  def index
    @books = BooksSelectorService.call(@category, self)
    @pagy, @books = pagy_array(@books.to_a, items: ITEMS_PER_PAGE, link_extra: 'data-remote="true"')
    respond_to :html, :js
  end

  def show
    book = Book.find_by(id: params[:id])
    @book = BookPresenter.new(book, view_context)
  end

  private

  def set_all_categories
    @categories = Category.all
  end

  def set_category
    @category = @categories.find_by(id: params[:category_id])
  end
end
