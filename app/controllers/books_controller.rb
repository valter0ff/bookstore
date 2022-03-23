# frozen_string_literal: true

class BooksController < ApplicationController
  ITEMS_PER_PAGE = 12

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :set_all_categories
  before_action :set_category, only: :index

  def index
    @books = BooksSelectorService.call(@category, params[:sorted_by])
    @pagy, @books = pagy_array(@books.to_a, items: ITEMS_PER_PAGE, link_extra: 'data-remote="true"')
    respond_to :html, :js
  end

  def show
    book = Book.find(params[:id])
    gon.book_full_description = book.description
    @book = BookPresenter.new(book, view_context)
  end

  private

  def set_all_categories
    @categories = Category.all
  end

  def set_category
    @category = @categories.find_by(id: params[:category_id])
  end

  def record_not_found
    flash[:error] = I18n.t('books.errors.record_not_found')
    redirect_to action: :index
  end
end
