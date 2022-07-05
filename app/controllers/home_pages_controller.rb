# frozen_string_literal: true

class HomePagesController < ClientController
  def index
    @best_sellers = BookDecorator.decorate_collection(best_sellers_collection)
    @latest_books = BookDecorator.decorate_collection(Book.order(created_at: :desc).first(3))
  end

  private

  def best_sellers_collection
    BooksSelectorService.call(nil, Constants::Shared::BEST_SELLERS_PROPERTY).take(Constants::Shared::BEST_SELLERS_COUNT)
  end
end
