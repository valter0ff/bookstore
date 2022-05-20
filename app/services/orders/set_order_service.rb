# frozen_string_literal: true

module Orders
  class SetOrderService < ApplicationService

    def initialize(user, session)
      @current_user = user
      @session = session
    end

    def call
      @current_user.present? ? set_order_for_user : set_order_for_guest
    end

    private

    def set_order_for_user
      @order = @current_user.orders.find_by(state: :in_progress)
      @order.present? ? update_order_from_session : build_order
      @order
    end

    def update_order_from_session
      return unless @session[:order_id]

      books_hash = Order.where(id: [@order.id, @session[:order_id]])
                    .joins(:cart_items)
                    .group(:book_id)
                    .sum(:books_count)
      books_hash.each do |book_id, books_count|
        @order.cart_items.find_or_create_by(book_id: book_id).update(books_count: books_count)
      end
      session_order!.destroy
      @session.delete(:order_id)
    end

    def build_order
      return @order = @current_user.orders.create unless @session[:order_id]

      @order = session_order!
      @order.update(user_account_id: @current_user.id)
      @session.delete(:order_id)
    end

    def set_order_for_guest
      @order = @session[:order_id] ? session_order! : create_new_order
    end

    def session_order!
      Order.find(@session[:order_id])
    end

    def create_new_order
      order = Order.create
      @session[:order_id] = order.id
      order
    end
  end
end
