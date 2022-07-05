# frozen_string_literal: true

class HomePagesController < ClientController
  def index
    @best_sellers = BookDecorator.decorate_collection(best_sellers_books)
    @latest_books = BookDecorator.decorate_collection(latest_added_books)
  end

  private

  def best_sellers_books
    Book.includes(%i[authors pictures]).order(:sales_count).first(Constants::Shared::BEST_SELLERS_COUNT)
  end

  def latest_added_books
    Book.includes(%i[authors pictures]).order(created_at: :desc).first(Constants::Shared::LATEST_BOOKS_COUNT)
  end
end
