# frozen_string_literal: true

module Orders
  class SetOrderService < ApplicationService
    def initialize(user, session)
      @current_user = user
      @session = session
      @session_order = Order.find_by(id: @session[:order_id])
    end

    def call
      current_user.present? ? set_order_for_user : set_order_for_guest
      order
    end

    private

    attr_reader :current_user, :session, :session_order, :order

    def set_order_for_user
      @order = current_user.current_order
      order.present? ? update_order_from_session : build_order
    end

    def update_order_from_session
      return unless session_order

      sum_by_book_hash.each { |book_id, books_count| update_cart_item(book_id, books_count) }
      delete_session_order
    end

    def sum_by_book_hash
      Order.where(id: [order.id, session_order.id])
           .joins(:cart_items)
           .group(:book_id)
           .sum(:books_count)
    end

    def update_cart_item(book_id, books_count)
      item = order.cart_items.find_or_create_by(book_id: book_id)
      item.assign_attributes(books_count: books_count)
      item.save if item.books_count_changed?
    end

    def delete_session_order
      session_order.destroy
      session.delete(:order_id)
    end

    def build_order
      @order = session_order || Order.new

      order.update(user_account_id: current_user.id)
      session.delete(:order_id)
    end

    def set_order_for_guest
      return create_new_order unless session_order

      @order = session_order
    end

    def create_new_order
      @order = Order.create
      session[:order_id] = order.id
    end
  end
end
