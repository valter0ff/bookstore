class BooksController < ApplicationController
  def index
    @categories = Category.all
    @category = CategorySelector.call(@categories, self)
    @books = BooksSelector.call(@category, self)
    @catalog = CatalogViewObject.new(view_context)
    @pagy, @books = pagy_array(@books.to_a, items: 12, link_extra: 'data-remote="true"')
    respond_to do |format|
      format.html { render 'catalog' }
      format.js
    end
  end
end
