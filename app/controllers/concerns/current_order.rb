# frozen_string_literal: true

module CurrentOrder
  private

  def set_order
    user_signed_in? ? set_order_to_user : set_order_to_session
  end

  def set_order_to_session
    @order = session[:order_id] ? session_order : create_new_order
  end

  def session_order
    Order.find(session[:order_id])
  end

  def create_new_order
    order = Order.create
    session[:order_id] = order.id
    order
  end

  def set_order_to_user
    @order = current_user.orders.find_by(state: :in_progress)
    @order.present? ? update_order_from_session || build_order
  end

  def update_order_from_session
    return unless session[:order_id]

    session_order.cart_items.each do |session_cart_item|
      existed_item = @order.cart_items.find_by(book_id: session_cart_item.book_id)
      update_cart_item(existed_item, session_cart_item.books_count) if existed_item.present?
    end
    session.delete(:order_id)
  end

  def update_cart_item(item, books_count)
    item.books_count += books_count
    item.save!
  end

  def build_order
     if session[:order_id]
      @order = session_order
      @order.user_account_id = current_user.id
      @order.save!
      session.delete(:order_id)
    else
      @order = current_user.orders.create
    end
  end
end
