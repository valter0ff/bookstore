# frozen_string_literal: true

class BooksController < ClientController
  ITEMS_PER_PAGE = 12

  before_action :set_category, only: :index
  before_action :set_book!, only: :show
  before_action :set_cart_item, only: :show

  def index
    @books = BooksSelectorService.call(@category, params[:sorted_by]).decorate
    @pagy, @books = pagy_array(@books.to_a, items: ITEMS_PER_PAGE, link_extra: 'data-remote="true"')
    respond_to :html, :js
  end

  def show
    gon.book_full_description = @book.description
    @review = Review.new
    set_reviews
  end

  private

  def set_category
    @category = @categories.find_by(id: params[:category_id])
  end

  def set_cart_item
    @cart_item = @order.cart_items.find_by(book_id: @book.id)
  end

  def set_book!
    @book = Book.find(params[:id]).decorate
  end

  def set_reviews
    @reviews = @book.reviews
                    .includes(user_account: %i[billing_address shipping_address picture])
                    .order(:created_at)
                    .approved
                    .decorate
  end
end
