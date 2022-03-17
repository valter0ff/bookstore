# frozen_string_literal: true

class BooksController < ApplicationController
  ITEMS_PER_PAGE = 12
  
  before_action :all_categories, only: :index
  before_action :select_category, only: :index

  def index
    @books = BooksSelector.call(@category, self)
    @pagy, @books = pagy_array(@books.to_a, items: ITEMS_PER_PAGE, link_extra: 'data-remote="true"')
    respond_to do |format|
      format.html { render 'catalog' }
      format.js
    end
  end

  def show
    book = Book.find_by(id: params[:id])
    @book = BookPresenter.new(book, view_context)
    render 'book_page'
  end

  private

  def all_categories
    @categories = Category.all
  end
  
  def select_category
    @category = @categories.find_by(id: params[:category_id])
  end
end
