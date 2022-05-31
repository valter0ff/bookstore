# frozen_string_literal: true

class CartItemsController < ClientController
  before_action :set_cart_item
  before_action :replace_books_quantity, only: %i[create update]

  def create
    if @cart_item.save
      redirect_to request.referer, notice: I18n.t('orders.book_added')
    else
      redirect_to request.referer, alert: @cart_item.errors.full_messages.first
    end
  end

  def update
    return_updating_response
  end

  def increment_book
    @cart_item.increment(:books_count)
    return_updating_response
  end

  def decrement_book
    @cart_item.decrement(:books_count)
    return_updating_response
  end

  def destroy
    @cart_item.destroy
    respond_to :js
  end

  private

  def set_cart_item
    @cart_item = CartItems::SetCartItemService.call(@order, params).decorate
  end

  def replace_books_quantity
    @cart_item.books_count = cart_item_params[:books_count]
  end

  def cart_item_params
    params.require(:cart_item).permit(:books_count)
  end

  def return_updating_response
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
