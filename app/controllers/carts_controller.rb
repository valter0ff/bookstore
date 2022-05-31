# frozen_string_literal: true

class CartsController < ClientController
  def show
    @order = @order.decorate
    @cart_items = @order.cart_items.includes(book: :pictures)
  end
end
