# frozen_string_literal: true

class HomePagesController < ClientController
  def index
    @best_sellers = best_sellers_books.decorate
    @latest_books = latest_added_books.decorate
  end

  private

  def best_sellers_books
    Book.includes(%i[authors pictures]).order(sales_count: :desc).limit(Constants::Shared::BEST_SELLERS_COUNT)
  end

  def latest_added_books
    Book.includes(%i[authors pictures]).order(created_at: :desc).limit(Constants::Shared::LATEST_BOOKS_COUNT)
  end
end
