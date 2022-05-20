# frozen_string_literal: true

class CartItemsController < ClientController
  before_action :set_book!, only: [:create]
  before_action :set_cart_item, only: [:create]

  def create
    if @cart_item.save
      redirect_to book_path(@book), notice: I18n.t('orders.book_added')
    else
      redirect_to book_path(@book), alert: @cart_item.errors.full_messages.first
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:books_count)
  end

  def set_book!
    @book = Book.find(params[:book_id]).decorate
  end

  def set_cart_item
    @cart_item = CartItems::SetCartItemService.call(@order, @book, cart_item_params)
  end
end
