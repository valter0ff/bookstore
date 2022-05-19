# frozen_string_literal: true

class CartItemsController < ClientController
  before_action :set_book, only: [:create]
  before_action :set_cart_item, only: [:create]

  def create
    if @cart_item.save
      redirect_to book_path(@book), notice: I18n.t('orders.book_added')
    else
      set_reviews
      flash.now[:alert] = @cart_item.errors.full_messages.first
      render 'books/show'
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:books_count).merge(book_id: @book.id, order_id: @order.id)
  end

  def current_cart_item
    current_item = @order.cart_items.find_by(book_id: @book.id)
    return unless current_item

    current_item.books_count += cart_item_params[:books_count].to_i
    current_item
  end

  def set_book
    @book = Book.find(params[:book_id]).decorate
  end

  def set_cart_item
    @cart_item = current_cart_item || @order.cart_items.build(cart_item_params)
  end
end
