# frozen_string_literal: true

class CartsController < ClientController
  def show
    if @order.present?
      @order = @order.decorate
      @cart_items = @order.cart_items.includes(book: :pictures)
    else
      flash.now[:alert] = 'Cart is empty'
    end
  end
end
