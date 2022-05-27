# frozen_string_literal: true

class CartItemsController < ClientController
  before_action :set_cart_item
  before_action :assign_books_quantity, only: %i[create update]

  def create
    if @cart_item.save
      redirect_to request.referer, notice: I18n.t('orders.book_added')
    else
      redirect_to request.referer, alert: @cart_item.errors.full_messages.first
    end
  end

  def update
    make_response
  end

  def increment_book
    @cart_item.books_count += 1
    make_response
  end

  def decrement_book
    @cart_item.books_count -= 1
    make_response
  end

  def destroy
    @cart_item.destroy
    respond_to :js
  end

  private

  def set_cart_item
    @cart_item = CartItems::SetCartItemService.call(@order, params).decorate
  end

  def assign_books_quantity
    @cart_item = CartItems::BooksCountService.call(@cart_item, params)
  end

  def make_response
    if @cart_item.save
      flash.now[:notice] = I18n.t('orders.order_updated')
    else
      @cart_item.reload
      flash.now[:alert] = @cart_item.errors.full_messages.first
    end
    respond_to do |format|
      format.js { render action: :update }
    end
  end
end
