# frozen_string_literal: true

module CurrentOrder
  private

  def set_order
    if user_signed_in?
      @order = current_user.orders.where(state: :in_progress).take || current_user.orders.create
      session.delete(:order_id)
    else
      @order = Order.find(session[:order_id])
    end
  rescue ActiveRecord::RecordNotFound
    @order = Order.create
    session[:order_id] = @order.id
  end
end
