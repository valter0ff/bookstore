class AddBookPriceToCartItem < ActiveRecord::Migration[6.1]
  def change
    add_column :cart_items, :book_price, :float, null: true
  end
end
