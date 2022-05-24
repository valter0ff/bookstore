# frozen_string_literal: true

class CartItemsController < ClientController
  before_action :set_cart_item

  def create
    add_books_quantity
    if @cart_item.save
      redirect_to request.referrer, notice: I18n.t('orders.book_added')
    else
      redirect_to request.referrer, alert: @cart_item.errors.full_messages.first
    end
  end

  def update
    replace_books_quantity
    if @cart_item.save
#       notice: I18n.t('orders.book_added')
      respond_to :js
    else
#       alert: @cart_item.errors.full_messages.first
      respond_to :js
    end
  end

  def destroy
    @cart_item.destroy
    respond_to :js
  end

  private

  def set_cart_item
    @cart_item = CartItems::SetCartItemService.call(@order, params).decorate
  end

  def add_books_quantity
    @cart_item.books_count += cart_item_params[:books_count].to_i
  end

  def replace_books_quantity
    return add_books_quantity unless cart_item_params[:books_count].to_i > 1

    @cart_item.books_count = cart_item_params[:books_count].to_i
  end

  def cart_item_params
    return unless params[:cart_item].present?

    params.require(:cart_item).permit(:books_count)
  end
end
