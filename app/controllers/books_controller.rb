class BooksController < ApplicationController
  def index
    @categories = Category.all
    @category = CategorySelector.call(@categories, self)
    @books = BooksSelector.call(@category, self)
    @catalog = CatalogViewObject.new(view_context)
    render 'catalog'
  end
end
