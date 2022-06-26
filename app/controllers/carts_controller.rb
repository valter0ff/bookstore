# frozen_string_literal: true

class CartsController < ClientController
  def show
    if @total_books_count.zero?
      flash.now[:alert] = I18n.t('carts.show.cart_empty')
    else
      @order = @order.decorate
      @cart_items = @order.cart_items.includes(book: :pictures)
    end
  end
end
