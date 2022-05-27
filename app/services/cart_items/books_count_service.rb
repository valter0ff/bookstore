# frozen_string_literal: true

module CartItems
  class BooksCountService < ApplicationService
    attr_reader :cart_item, :params

    def initialize(cart_item, params)
      @cart_item = cart_item
      @params = params
    end

    def call
      update_quantity if params[:action] == 'create'
      replace_quantity if params[:action] == 'update'
      cart_item
    end

    private

    def update_quantity
      cart_item.persisted? && books_count_positive? ? add_books_quantity : replace_quantity
    end

    def replace_quantity
      cart_item.books_count = cart_item_params[:books_count]
    end

    def add_books_quantity
      cart_item.books_count += cart_item_params[:books_count].to_i
    end

    def books_count_positive?
      cart_item_params[:books_count].to_i.positive?
    end

    def cart_item_params
      params.require(:cart_item).permit(:books_count)
    end
  end
end
