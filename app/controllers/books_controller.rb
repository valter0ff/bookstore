# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :all_categories

  def index
    @category = CategorySelector.call(@categories, self)
    @books = BooksSelector.call(@category, self)
    @catalog = CatalogViewObject.new(view_context)
    @pagy, @books = pagy_array(@books.to_a, items: 12, link_extra: 'data-remote="true"')
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
end
