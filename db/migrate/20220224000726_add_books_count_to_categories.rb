class AddBooksCountToCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :books_count, :integer
  end
end
