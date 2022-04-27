# frozen_string_literal: true

class BooksController < ClientController
  ITEMS_PER_PAGE = 12

  before_action :set_category, only: :index

  def index
    @books = BooksSelectorService.call(@category, params[:sorted_by]).decorate
    @pagy, @books = pagy_array(@books.to_a, items: ITEMS_PER_PAGE, link_extra: 'data-remote="true"')
    respond_to :html, :js
  end

  def show
    @book = Book.find(params[:id]).decorate
    gon.book_full_description = @book.description
    @review = Review.new
    set_reviews
  end

  private

  def set_category
    @category = @categories.find(params[:category_id])
  end

  def set_reviews
    @reviews = @book.reviews.includes(user_account: %i[billing_address shipping_address]).order(:created_at).decorate
  end
end
